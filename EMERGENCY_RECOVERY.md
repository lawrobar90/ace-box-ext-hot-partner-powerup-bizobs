# Emergency Recovery Commands for ACE Box Deployment

## 🚨 **Root Cause**: Sudo configuration failed, causing package installation failures

## 🔧 **Immediate Fix Commands**

### 1. **Fix Sudo Configuration (Run on ACE Box)**
```bash
# SSH into your ACE Box first
ssh dt_training@ip-10-0-103-18

# Configure passwordless sudo manually
echo 'dt_training ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/dt_training
sudo chmod 440 /etc/sudoers.d/dt_training

# Verify sudo works
sudo -n whoami  # Should return 'root' without password prompt
```

### 2. **Clean APT Locks and Install Dependencies**
```bash
# Clean up any existing APT locks
sudo rm -f /var/lib/dpkg/lock-frontend
sudo rm -f /var/lib/dpkg/lock
sudo rm -f /var/cache/apt/archives/lock

# Kill any hanging APT processes
sudo killall apt apt-get dpkg 2>/dev/null || true

# Update package cache
sudo apt update

# Install required packages
sudo apt install -y nodejs npm git curl nginx
```

### 3. **Manual BizObs App Deployment**
```bash
# Create bizobs user and directory
sudo useradd -r -s /bin/bash -d /opt/bizobs bizobs
sudo mkdir -p /opt/bizobs
sudo chown bizobs:bizobs /opt/bizobs

# Clone the application
cd /opt/bizobs
sudo -u bizobs git clone https://github.com/lawrobar90/Partner-PowerUp-BizObs-App.git

# Install dependencies
cd /opt/bizobs/Partner-PowerUp-BizObs-App
sudo npm install --unsafe-perm

# Create systemd service
sudo tee /etc/systemd/system/partner-powerup-bizobs.service > /dev/null <<EOF
[Unit]
Description=Partner PowerUp BizObs Application
After=network.target

[Service]
Type=simple
User=bizobs
WorkingDirectory=/opt/bizobs/Partner-PowerUp-BizObs-App
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10
Environment=NODE_ENV=production
Environment=PORT=8080

[Install]
WantedBy=multi-user.target
EOF

# Start the service
sudo systemctl daemon-reload
sudo systemctl enable partner-powerup-bizobs
sudo systemctl start partner-powerup-bizobs

# Check if it's running
sudo systemctl status partner-powerup-bizobs
curl http://localhost:8080/api/health
```

### 4. **Create Missing Kubernetes Ingresses**
```bash
# Create BizObs ingress
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: bizobs-ingress
  namespace: default
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: "bizobs.4194dc15-250c-4765-9fdc-9c5ab25650ed.dynatrace.training"
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
  externalName: "localhost"
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 8080
EOF

# Create Dashboard ingress (if missing)
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: dashboard
  namespace: ace
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: "dashboard.4194dc15-250c-4765-9fdc-9c5ab25650ed.dynatrace.training"
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: dashboard
            port:
              number: 80
EOF
```

### 5. **Verification Commands**
```bash
# Check all ingresses
kubectl get ingress -A

# Check services
kubectl get svc -A

# Test URLs
curl -k https://dashboard.4194dc15-250c-4765-9fdc-9c5ab25650ed.dynatrace.training
curl -k https://bizobs.4194dc15-250c-4765-9fdc-9c5ab25650ed.dynatrace.training/api/health
```

## 🎯 **Expected Result After Running These Commands**

Your `kubectl get ingress -A` should show:
```
NAMESPACE    NAME                                 CLASS    HOSTS                                                             ADDRESS        PORTS   AGE
ace          dashboard                            <none>   dashboard.4194dc15-250c-4765-9fdc-9c5ab25650ed.dynatrace.training   10.0.103.18   80      1m
default      bizobs-ingress                       <none>   bizobs.4194dc15-250c-4765-9fdc-9c5ab25650ed.dynatrace.training      10.0.103.18   80      1m
default      docker-registry-ingress              <none>   registry.4194dc15-250c-4765-9fdc-9c5ab25650ed.dynatrace.training    10.0.103.18   80      24m
mattermost   mattermost-mattermost-team-edition   <none>   mattermost.4194dc15-250c-4765-9fdc-9c5ab25650ed.dynatrace.training  10.0.103.18   80      24m
```

## 🚀 **Access URLs**
- **Dashboard**: https://dashboard.4194dc15-250c-4765-9fdc-9c5ab25650ed.dynatrace.training
- **BizObs App**: https://bizobs.4194dc15-250c-4765-9fdc-9c5ab25650ed.dynatrace.training
- **Mattermost**: https://mattermost.4194dc15-250c-4765-9fdc-9c5ab25650ed.dynatrace.training
- **Registry**: https://registry.4194dc15-250c-4765-9fdc-9c5ab25650ed.dynatrace.training