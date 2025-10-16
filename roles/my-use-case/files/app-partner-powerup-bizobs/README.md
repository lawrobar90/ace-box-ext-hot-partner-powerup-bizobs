# Partner PowerUp BizObs App - ACE-Box Integration

This Ansible role deploys the Partner PowerUp BizObs application directly on EC2 instances without containerization, replacing the EasyTrade application in the ACE-Box framework.

## Overview

Partner PowerUp BizObs is a Node.js application that simulates customer journey analytics across various industries. It provides dynamic microservices (Step1Service - Step6Service) that can be configured for different business scenarios.

## Architecture

### Deployment Model
- **Platform**: EC2 direct deployment (no containers)
- **Runtime**: Node.js with systemd service management
- **Reverse Proxy**: nginx for load balancing and SSL termination
- **Monitoring**: Dynatrace OneAgent integration
- **Business Events**: Custom business event capture for step completions

### Application Structure
- **Main App**: Customer journey simulation engine
- **Step Services**: 6 dynamic microservices (step1-step6)
- **Industries**: Configurable templates (retail, banking, ecommerce, healthcare)
- **Analytics**: Real-time business metrics and journey tracking

## Configuration Variables

### Application Settings
```yaml
bizobs_user: "bizobs"                    # Application user
bizobs_home: "/opt/bizobs"               # Installation directory
bizobs_port: 4000                        # Application port
bizobs_domain: "bizobs.{{ ingress_domain }}"  # External domain
bizobs_git_branch: "main"                # Git branch to deploy
```

### Business Simulation
```yaml
bizobs_auto_start: true                  # Auto-start journeys
bizobs_journey_interval: 30000           # Journey interval (ms)
bizobs_concurrent_users: 10              # Concurrent simulated users
bizobs_error_rate: 0.05                  # Error rate (5%)
bizobs_industry_templates: "retail,banking,ecommerce,healthcare"
```

### Performance & Security
```yaml
bizobs_max_memory: "512"                 # Max memory (MB)
bizobs_cors_origins: "*"                 # CORS allowed origins
bizobs_rate_limit_window: 900000         # Rate limit window (ms)
bizobs_rate_limit_max: 100               # Max requests per window
```

## Files Structure

```
app-partner-powerup-bizobs/
├── defaults/main.yml           # Default variables
├── tasks/main.yml             # Deployment tasks
├── templates/
│   ├── partner-powerup-bizobs.service.j2  # systemd service
│   ├── bizobs.env.j2                      # Environment file
│   └── bizobs-nginx.conf.j2               # nginx configuration
└── handlers/main.yml          # Service handlers
```

## Deployment Process

1. **System Preparation**
   - Install Node.js, npm, git
   - Create application user and directories
   - Configure logging directories

2. **Application Deployment**
   - Clone Partner PowerUp BizObs from GitHub
   - Install Node.js dependencies
   - Configure environment variables
   - Set up systemd service

3. **Reverse Proxy Setup**
   - Configure nginx virtual host
   - Enable SSL/TLS termination
   - Set up load balancing for step services

4. **Service Management**
   - Start and enable systemd service
   - Configure service monitoring
   - Set up log rotation

5. **Health Verification**
   - Test application health endpoint
   - Verify service availability
   - Confirm Dynatrace integration

## Business Events Integration

The application generates business events for:
- `com.partner-powerup-bizobs.step1-completed`
- `com.partner-powerup-bizobs.step2-completed`
- `com.partner-powerup-bizobs.step3-completed`
- `com.partner-powerup-bizobs.step4-completed`
- `com.partner-powerup-bizobs.step5-completed`
- `com.partner-powerup-bizobs.step6-completed`
- `com.partner-powerup-bizobs.customer-journey-started`

## Dynatrace Integration

### Business Analytics
- Custom metrics for step completions
- Customer journey flow visualization
- Industry-specific business insights
- Revenue pipeline integration

### Monitoring Features
- Application performance monitoring
- Custom business metrics
- Error tracking and analysis
- Real-time journey analytics

## Usage

Once deployed, the application will be available at:
- **External URL**: `http://bizobs.{{ ingress_domain }}`
- **Health Check**: `http://bizobs.{{ ingress_domain }}/health`
- **API Endpoints**: `http://bizobs.{{ ingress_domain }}/api/*`

### Key Features
- **Dashboard**: Real-time journey analytics
- **Journey Simulation**: Start/stop customer journeys
- **Industry Templates**: Pre-configured business scenarios
- **Step Services**: Dynamic microservice simulation
- **Business Metrics**: Custom KPIs and measurements

## Monitoring & Troubleshooting

### Service Management
```bash
# Check service status
sudo systemctl status partner-powerup-bizobs

# View logs
sudo journalctl -u partner-powerup-bizobs -f

# Restart service
sudo systemctl restart partner-powerup-bizobs
```

### Log Locations
- **Application Logs**: `/var/log/bizobs/partner-powerup-bizobs.log`
- **Error Logs**: `/var/log/bizobs/partner-powerup-bizobs-error.log`
- **nginx Logs**: `/var/log/nginx/bizobs.*.log`

### Health Checks
- **Application Health**: `GET /api/health`
- **Metrics Endpoint**: `GET /api/metrics`
- **Step Services**: `GET /api/step{1-6}/health`

## Migration from EasyTrade

This role completely replaces the EasyTrade application with:
- ✅ Removed Kubernetes deployment (k3s, dt-operator)
- ✅ Replaced with EC2-native systemd services
- ✅ Updated Monaco business event configurations
- ✅ Migrated lab guide content and examples
- ✅ Replaced revenue pipeline configurations
- ✅ Updated dashboard and monitoring integrations