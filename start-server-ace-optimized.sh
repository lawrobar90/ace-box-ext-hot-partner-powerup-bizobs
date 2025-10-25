#!/bin/bash

# Partner PowerUp BizObs - ACE-BOX Optimized Start Script
# Designed specifically for ACE-BOX deployment (no overlap with curated roles)

set -e

echo "🚀 Starting Partner PowerUp BizObs for ACE-BOX"
echo "============================================="

# Validate we're in the right directory
if [[ ! -f "package.json" || ! -f "server.js" ]]; then
    echo "❌ Error: Must run from Partner PowerUp BizObs app directory"
    echo "   Looking for: package.json, server.js"
    echo "   Current dir: $(pwd)"
    echo "   Contents: $(ls -la)"
    exit 1
fi

PROJECT_DIR="$(pwd)"
echo "📂 Working in: $PROJECT_DIR"

# Quick environment check
echo "🔍 Environment check..."
echo "  Node: $(node --version 2>/dev/null || echo 'Not found')"
echo "  NPM: $(npm --version 2>/dev/null || echo 'Not found')"
echo "  User: $(whoami)"

# Clean up existing processes (ACE-BOX specific)
echo "🧹 Cleaning up existing processes..."
if command -v lsof &> /dev/null; then
    # Kill any processes on port 8080
    lsof -i:8080 -sTCP:LISTEN -t 2>/dev/null | xargs kill -9 2>/dev/null || true
fi

# Clean up any existing BizObs processes
pkill -f "node server.js" 2>/dev/null || true
pkill -f "BizObs" 2>/dev/null || true
sleep 1

# Ensure dependencies are current (ACE-BOX already ran npm install, but ensure it's complete)
echo "📦 Finalizing dependencies..."
npm install --production --silent || {
    echo "⚠️  npm install had issues, but continuing..."
}

# Create necessary directories
mkdir -p logs
mkdir -p services/.dynamic-runners

# Set environment variables optimized for ACE-BOX + Dynatrace
echo "🔧 Configuring environment for ACE-BOX..."

# Core Dynatrace integration
export DT_SERVICE_NAME="bizobs-main-server"
export DT_APPLICATION_NAME="BizObs-CustomerJourney" 
export NODE_ENV="production"
export DT_TAGS="environment=ace-box app=BizObs service=bizobs component=main-server deployment=ace-box"

# ACE-BOX specific Dynatrace tags
export DT_RELEASE_STAGE="ace-box-demo"
export DT_RELEASE_PRODUCT="Partner-PowerUp-BizObs"
export DT_RELEASE_VERSION="1.0.0"
export DT_CLUSTER_ID="ace-box-cluster"

# Business context for demo scenarios
export COMPANY_NAME="${COMPANY_NAME:-Dynatrace}"
export COMPANY_DOMAIN="${COMPANY_DOMAIN:-dynatrace.com}"
export INDUSTRY_TYPE="${INDUSTRY_TYPE:-technology}"

# ACE-BOX integration (these should be provided by ACE-BOX environment)
export BIZOBS_EXTERNAL_URL="${BIZOBS_EXTERNAL_URL:-http://localhost:8080}"
export BIZOBS_ACE_BOX_ID="${ACE_BOX_ID:-ace-box-demo}"

echo "✅ Environment configured for ACE-BOX deployment"

# Start server in background (ACE-BOX pattern)
echo "🚀 Starting BizObs server in background..."
nohup node server.js > logs/bizobs.log 2>&1 &
SERVER_PID=$!

echo "📝 Server started with PID: $SERVER_PID"
echo "$SERVER_PID" > server.pid

# Wait for server startup (quick check for ACE-BOX)
echo "⏳ Waiting for server startup..."
for i in {1..15}; do
    if curl -s http://localhost:8080/health >/dev/null 2>&1; then
        echo ""
        echo "✅ Server responding on port 8080"
        break
    fi
    if [[ $i -eq 15 ]]; then
        echo ""
        echo "❌ Server failed to start within 15 seconds"
        echo "📋 Recent logs:"
        tail -15 logs/bizobs.log 2>/dev/null || echo "No logs available"
        echo ""
        echo "🔍 Process check:"
        ps aux | grep "node server.js" | grep -v grep || echo "No server process found"
        exit 1
    fi
    sleep 1
    echo -n "."
done

# Quick health check
echo "🔍 Verifying application health..."
sleep 2

# Test core endpoints
HEALTH_STATUS="unknown"
if curl -s http://localhost:8080/health >/dev/null 2>&1; then
    HEALTH_STATUS="✅ healthy"
else
    HEALTH_STATUS="⚠️ not responding"
fi

ADMIN_STATUS="unknown"
if curl -s http://localhost:8080/api/admin/services/status >/dev/null 2>&1; then
    ADMIN_STATUS="✅ ready"
else
    ADMIN_STATUS="⚠️ not ready"
fi

echo "  Health endpoint: $HEALTH_STATUS"
echo "  Admin endpoint: $ADMIN_STATUS"

# Create minimal management scripts for ACE-BOX
cat > status.sh << 'EOF'
#!/bin/bash
echo "📊 BizObs ACE-BOX Status"
echo "======================"
if [[ -f "server.pid" ]]; then
    PID=$(cat server.pid)
    if ps -p $PID > /dev/null 2>&1; then
        echo "✅ Server running (PID: $PID)"
        echo "💾 Memory: $(ps -p $PID -o %mem= | xargs)%"
    else
        echo "❌ Server not running (stale PID)"
    fi
else
    echo "❓ No PID file found"
fi

echo ""
if curl -s http://localhost:8080/health > /dev/null 2>&1; then
    echo "🌐 HTTP: Responding"
    if curl -s http://localhost:8080/api/admin/services/status > /dev/null 2>&1; then
        echo "🎯 Admin API: Ready"
    else
        echo "⚠️ Admin API: Not ready"
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
        sleep 2
        if ps -p $PID > /dev/null 2>&1; then
            echo "Force stopping..."
            kill -9 $PID 2>/dev/null
        fi
    fi
    rm -f server.pid
fi

# Clean up any remaining processes
pkill -f "node server.js" 2>/dev/null || true
pkill -f "BizObs.*Service" 2>/dev/null || true

echo "✅ BizObs stopped and cleaned up"
EOF

chmod +x status.sh stop.sh

echo ""
echo "✅ Partner PowerUp BizObs started successfully for ACE-BOX!"
echo ""
echo "🔗 Application Access:"
echo "  • Local URL: http://localhost:8080/"
echo "  • Health Check: http://localhost:8080/health"
echo "  • Admin Panel: http://localhost:8080/api/admin/services/status"
echo "  • External URL: ${BIZOBS_EXTERNAL_URL:-Will be set by ACE-BOX ingress}"
echo ""
echo "🎯 Demo Features Ready:"
echo "  • Customer Journey Simulation"
echo "  • Multi-persona Load Generation"
echo "  • Dynatrace Integration & Tagging"
echo "  • Real-time Business Observability"
echo ""
echo "🔧 Management (optional):"
echo "  • Status: ./status.sh"
echo "  • Stop: ./stop.sh"
echo "  • Logs: tail -f logs/bizobs.log"
echo ""
echo "🚀 Ready for ACE-BOX integration and Dynatrace observability!"