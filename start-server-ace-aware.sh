#!/bin/bash

# Partner PowerUp BizObs - ACE-BOX Aware Start Script
# Leverages ACE-BOX setup (Node.js, repo clone, npm install) but adds comprehensive features

set -e

echo "🚀 Partner PowerUp BizObs - ACE-BOX Aware Startup"
echo "================================================"

# Configuration (ACE-BOX integration)
PROJECT_NAME="Partner-PowerUp-BizObs-App"
DRY_RUN=false
FOLLOW_LOGS=false

# Parse command line arguments
for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --follow-logs)
            FOLLOW_LOGS=true
            shift
            ;;
        --ace-box-id=*)
            ACE_BOX_ID_OVERRIDE="${arg#*=}"
            shift
            ;;
        --external-url=*)
            EXTERNAL_URL_OVERRIDE="${arg#*=}"
            shift
            ;;
        *)
            echo "ACE-BOX Aware Options: [--dry-run] [--follow-logs] [--ace-box-id=ID] [--external-url=URL]"
            ;;
    esac
done

# Validate we're in the right directory (ACE-BOX should have set this up)
if [[ ! -f "package.json" || ! -f "server.js" ]]; then
    echo "❌ Error: Not in Partner PowerUp BizObs directory"
    echo "   Expected: package.json, server.js"
    echo "   Current: $(pwd)"
    echo "   Contents: $(ls -la)"
    exit 1
fi

PROJECT_DIR="$(pwd)"
echo "📂 Working in: $PROJECT_DIR"

# Quick ACE-BOX environment validation
echo "🔍 Validating ACE-BOX environment..."
echo "  Node: $(node --version 2>/dev/null || echo '❌ Missing')"
echo "  NPM: $(npm --version 2>/dev/null || echo '❌ Missing')" 
echo "  User: $(whoami)"
echo "  Git: $(git --version 2>/dev/null | head -n1 || echo '❌ Missing')"

# Check if dependencies were installed by ACE-BOX
if [[ ! -d "node_modules" ]]; then
    echo "📦 Installing dependencies (ACE-BOX may have skipped this)..."
    npm install --production
    echo "✅ Dependencies installed"
else
    echo "✅ Dependencies already installed by ACE-BOX"
fi

# ACE-BOX specific port cleanup (more thorough)
echo "🧹 Cleaning up ports and processes..."
if command -v lsof &> /dev/null; then
    # Kill any processes on port 8080
    lsof -i:8080 -sTCP:LISTEN -t 2>/dev/null | xargs kill -9 2>/dev/null || true
    sleep 1
    echo "✅ Port 8080 cleaned"
fi

# Clean up any existing BizObs processes
pkill -f "node server.js" 2>/dev/null || true
pkill -f "BizObs" 2>/dev/null || true
pkill -f "Service" 2>/dev/null || true
sleep 1

# Clean up specific service processes
ps aux | grep -E "(DesignEngineeringService|PurchaseService|DataPersistenceService|DiscoveryService)" | grep -v grep | awk '{print $2}' | xargs kill -9 2>/dev/null || true

echo "✅ Process cleanup complete"

# Create necessary directories
echo "📁 Ensuring directory structure..."
mkdir -p logs
mkdir -p services/.dynamic-runners
mkdir -p public/assets

# Environment file setup
if [[ ! -f ".env" && -f ".env.example" ]]; then
    cp .env.example .env
    echo "✅ Environment file created from template"
fi

# Make management scripts executable
chmod +x *.sh 2>/dev/null || true

echo "✅ Project structure validated"

# Dry run mode
if [[ "$DRY_RUN" == "true" ]]; then
    echo "🧪 Dry run complete - environment ready for startup"
    exit 0
fi

# ACE-BOX environment detection (enhanced)
echo "🔍 Detecting ACE-BOX environment..."

# Use override if provided
if [[ -n "${ACE_BOX_ID_OVERRIDE:-}" ]]; then
    ACE_BOX_ID="$ACE_BOX_ID_OVERRIDE"
    echo "📋 Using specified ACE-Box ID: ${ACE_BOX_ID}"
elif [[ -n "${EXTERNAL_URL_OVERRIDE:-}" ]]; then
    EXTERNAL_URL="$EXTERNAL_URL_OVERRIDE"
    echo "🔗 Using specified external URL: ${EXTERNAL_URL}"
else
    # Auto-detect from environment variables set by ACE-BOX
    ACE_BOX_ID="${ACE_BOX_ID:-}"
    EXTERNAL_URL="${BIZOBS_EXTERNAL_URL:-}"
    
    # Fallback detection methods
    if [[ -z "$ACE_BOX_ID" && -f "/etc/machine-id" ]]; then
        ACE_BOX_ID=$(cat /etc/machine-id | head -c 8)
        echo "📋 Detected ACE-Box ID from machine-id: ${ACE_BOX_ID}"
    fi
    
    # Try hostname pattern
    if [[ -z "$ACE_BOX_ID" ]]; then
        HOSTNAME=$(hostname)
        if [[ "$HOSTNAME" =~ ace-box-([a-f0-9-]+) ]]; then
            ACE_BOX_ID="${BASH_REMATCH[1]}"
            echo "📋 Detected ACE-Box ID from hostname: ${ACE_BOX_ID}"
        fi
    fi
fi

# Set external URL based on detection
if [[ -n "${EXTERNAL_URL_OVERRIDE:-}" ]]; then
    echo "🔗 Using specified external URL: $EXTERNAL_URL"
elif [[ -n "$ACE_BOX_ID" && "$ACE_BOX_ID" != "" ]]; then
    DYNAMIC_DOMAIN="${ACE_BOX_ID}.dynatrace.training"
    EXTERNAL_URL="http://bizobs.${DYNAMIC_DOMAIN}"
    echo "🌐 ACE-Box environment: $DYNAMIC_DOMAIN"
    echo "🔗 External URL: $EXTERNAL_URL"
else
    # Fallback
    EXTERNAL_URL="http://localhost:8080"
    echo "🌐 Using localhost fallback: $EXTERNAL_URL"
fi

# Deploy Kubernetes ingress (if kubectl available from ACE-BOX)
if command -v kubectl &> /dev/null; then
    echo "📡 Deploying Kubernetes ingress..."
    
    # Create ingress configuration
    cat > /tmp/bizobs-ingress.yaml << EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: bizobs-ingress
  namespace: default
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "300"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "300"
spec:
  ingressClassName: nginx
  rules:
  - host: bizobs.${ACE_BOX_ID}.dynatrace.training
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: bizobs-service
            port:
              number: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: bizobs-service
  namespace: default
spec:
  type: ExternalName
  externalName: localhost
  ports:
  - port: 8080
    targetPort: 8080
    name: http
EOF

    kubectl apply -f /tmp/bizobs-ingress.yaml
    sleep 2
    
    if kubectl get ingress bizobs-ingress >/dev/null 2>&1; then
        echo "✅ Kubernetes ingress deployed successfully"
    else
        echo "⚠️  Ingress deployment had issues, but continuing..."
    fi
    
    rm -f /tmp/bizobs-ingress.yaml
else
    echo "⚠️  kubectl not available, skipping ingress (ACE-BOX should handle this)"
fi

# Set environment variables for Dynatrace integration
echo "🔧 Configuring Dynatrace environment..."
export DT_SERVICE_NAME="bizobs-main-server"
export DT_APPLICATION_NAME="BizObs-CustomerJourney"
export NODE_ENV="production"
export SERVICE_VERSION="1.0.0"
export DT_CLUSTER_ID="bizobs-cluster"
export DT_NODE_ID="bizobs-main-001"
export DT_TAGS="environment=ace-box app=BizObs-CustomerJourney service=bizobs-main-server component=main-server deployment=ace-box"

# ACE-BOX specific tags
export DT_RELEASE_STAGE="ace-box-demo"
export DT_RELEASE_PRODUCT="Partner-PowerUp-BizObs"
export DT_RELEASE_VERSION="1.0.0"

# Business context
export COMPANY_NAME="${COMPANY_NAME:-Dynatrace}"
export COMPANY_DOMAIN="${COMPANY_DOMAIN:-dynatrace.com}"
export INDUSTRY_TYPE="${INDUSTRY_TYPE:-technology}"

# BizObs configuration
export BIZOBS_EXTERNAL_URL="$EXTERNAL_URL"
export BIZOBS_ACE_BOX_ID="$ACE_BOX_ID"

echo "✅ Environment configured for ACE-BOX + Dynatrace"

# Start server in background
echo "🚀 Starting BizObs server..."
mkdir -p logs
nohup node server.js > logs/bizobs.log 2>&1 &
SERVER_PID=$!

echo "📝 Server started with PID: $SERVER_PID"
echo "$SERVER_PID" > server.pid

# Wait for startup (reasonable timeout for ACE-BOX)
echo "⏳ Waiting for server startup..."
for i in {1..30}; do
    if curl -s http://localhost:8080/health >/dev/null 2>&1; then
        echo ""
        echo "✅ Server responding on port 8080"
        break
    fi
    if [[ $i -eq 30 ]]; then
        echo ""
        echo "❌ Server failed to start within 30 seconds"
        echo "📋 Recent logs:"
        tail -20 logs/bizobs.log 2>/dev/null || echo "No logs available"
        exit 1
    fi
    sleep 1
    echo -n "."
done

# Enhanced health checks
echo "🔍 Verifying application health..."
sleep 3

# Test core endpoints
HEALTH_OK=false
ADMIN_OK=false
SERVICES_RUNNING=0

if curl -s http://localhost:8080/health >/dev/null 2>&1; then
    HEALTH_OK=true
fi

if curl -s http://localhost:8080/api/admin/services/status >/dev/null 2>&1; then
    ADMIN_OK=true
    SERVICES_DATA=$(curl -s http://localhost:8080/api/admin/services/status 2>/dev/null || echo "{}")
    SERVICES_RUNNING=$(echo "$SERVICES_DATA" | jq -r '.runningServices // 0' 2>/dev/null || echo "0")
fi

# Quick journey test
JOURNEY_OK=false
if curl -s -X POST http://localhost:8080/api/journey-simulation/simulate-journey \
  -H "Content-Type: application/json" \
  -d '{"journey": {"companyName": "ACE-BOX Demo", "domain": "acebox.com", "industryType": "Technology", "steps": [{"stepName": "UserRegistration", "serviceName": "RegistrationService", "category": "Onboarding"}]}}' >/dev/null 2>&1; then
    JOURNEY_OK=true
fi

# Report health status
echo "📊 Health Check Results:"
echo "  ✓ Health endpoint: $([ "$HEALTH_OK" = true ] && echo "✅ OK" || echo "❌ Failed")"
echo "  ✓ Admin endpoint: $([ "$ADMIN_OK" = true ] && echo "✅ OK" || echo "❌ Failed")"
echo "  ✓ Running services: $SERVICES_RUNNING"
echo "  ✓ Journey simulation: $([ "$JOURNEY_OK" = true ] && echo "✅ OK" || echo "⚠️ Issues")"

# Create enhanced management scripts
echo "🔧 Creating management utilities..."

cat > status.sh << 'EOF'
#!/bin/bash
echo "📊 BizObs ACE-BOX Status"
echo "======================"
if [[ -f "server.pid" ]]; then
    PID=$(cat server.pid)
    if ps -p $PID > /dev/null 2>&1; then
        echo "✅ Server running (PID: $PID)"
        echo "💾 Memory: $(ps -p $PID -o %mem= | xargs)%"
        echo "⏱️  CPU: $(ps -p $PID -o %cpu= | xargs)%"
        echo "🕒 Start time: $(ps -p $PID -o lstart= | xargs)"
    else
        echo "❌ Server not running (stale PID)"
    fi
else
    echo "❓ No PID file found"
fi

if curl -s http://localhost:8080/health > /dev/null 2>&1; then
    echo "🌐 HTTP: Responding"
    if curl -s http://localhost:8080/api/admin/services/status > /dev/null 2>&1; then
        SERVICES=$(curl -s http://localhost:8080/api/admin/services/status | jq -r '"Services: " + (.runningServices | tostring) + "/" + (.totalServices | tostring)' 2>/dev/null || echo "Services: Status unknown")
        echo "🎯 $SERVICES"
    else
        echo "⚠️  Admin API: Not ready"
    fi
else
    echo "❌ HTTP: Not responding"
fi
EOF

cat > stop.sh << 'EOF'
#!/bin/bash
echo "🛑 Stopping BizObs ACE-BOX deployment..."
if [[ -f "server.pid" ]]; then
    PID=$(cat server.pid)
    if ps -p $PID > /dev/null 2>&1; then
        echo "Stopping server (PID: $PID)..."
        kill $PID 2>/dev/null
        sleep 3
        if ps -p $PID > /dev/null 2>&1; then
            echo "Force stopping..."
            kill -9 $PID 2>/dev/null
        fi
    fi
    rm -f server.pid
fi

pkill -f "node server.js" 2>/dev/null || true
pkill -f "BizObs.*Service" 2>/dev/null || true
echo "✅ BizObs stopped"
EOF

cat > restart.sh << 'EOF'
#!/bin/bash
echo "🔄 Restarting BizObs..."
./stop.sh
sleep 2
./start-server-ace-aware.sh
EOF

chmod +x status.sh stop.sh restart.sh

echo ""
echo "✅ Partner PowerUp BizObs started successfully!"
echo ""
echo "🔗 Access Information:"
echo "  • External URL: $EXTERNAL_URL"
echo "  • Local URL: http://localhost:8080/"
echo "  • Health Check: http://localhost:8080/health"
echo "  • Admin Panel: http://localhost:8080/api/admin/services/status"
echo ""
echo "🎯 Demo Features Ready:"
echo "  • Customer Journey Simulation"
echo "  • Multi-persona Load Generation (Karen, Raj, Alex, Sophia)"
echo "  • Dynatrace Integration & Metadata Injection"
echo "  • Real-time Business Observability"
echo ""
echo "🔧 Management Commands:"
echo "  • Status: ./status.sh"
echo "  • Stop: ./stop.sh"
echo "  • Restart: ./restart.sh"
echo "  • Logs: tail -f logs/bizobs.log"
echo ""
echo "🚀 Ready for ACE-BOX Dynatrace demonstrations!"

# Follow logs if requested
if [[ "${FOLLOW_LOGS:-false}" == "true" ]]; then
    echo ""
    echo "📋 Following logs (Ctrl+C to exit):"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    tail -f logs/bizobs.log
fi