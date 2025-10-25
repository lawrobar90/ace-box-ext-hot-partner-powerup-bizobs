# ✅ SUDO WORKS - Now Fix It Permanently

Since `sudo bash -c 'echo "test"'` worked, your sudo is functional. Let's set up passwordless sudo:

## 🔧 **Fix Sudo Configuration**

```bash
# This should work since your sudo is functional:
sudo bash -c 'echo "dt_training ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dt_training'
sudo chmod 440 /etc/sudoers.d/dt_training

# Test it works:
sudo -n whoami
```

If the above works and returns "root" without asking for password, you're good to go!

## 🚀 **Complete App Deployment Commands**

Now run these commands in sequence:

```bash
# 1. Clean up APT locks
sudo rm -f /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/cache/apt/archives/lock
sudo killall apt apt-get dpkg 2>/dev/null || true

# 2. Install required packages
sudo apt update
sudo apt install -y nodejs npm git curl nginx

# 3. Set up BizObs application
sudo useradd -r -s /bin/bash -d /opt/bizobs -m bizobs 2>/dev/null || true
sudo mkdir -p /opt/bizobs
cd /opt/bizobs

# 4. Clone and setup app
sudo git clone https://github.com/lawrobar90/Partner-PowerUp-BizObs-App.git 2>/dev/null || sudo git -C Partner-PowerUp-BizObs-App pull
sudo chown -R bizobs:bizobs /opt/bizobs

# 5. Install Node.js dependencies
cd Partner-PowerUp-BizObs-App
sudo -u bizobs npm install

# 6. Create systemd service
sudo tee /etc/systemd/system/partner-powerup-bizobs.service > /dev/null <<'EOF'
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

# 7. Start the service
sudo systemctl daemon-reload
sudo systemctl enable partner-powerup-bizobs
sudo systemctl start partner-powerup-bizobs

# 8. Verify it's running
sudo systemctl status partner-powerup-bizobs
curl http://localhost:8080/api/health

# 9. Create Kubernetes ingress for external access
kubectl apply -f - <<'EOF'
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

# 10. Check dashboard ingress exists (create if missing)
kubectl get ingress -n ace dashboard || kubectl apply -f - <<'EOF'
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

# 11. Final verification
echo "🎉 Checking all services..."
kubectl get ingress -A
echo ""
echo "🔗 Your URLs should now work:"
echo "Dashboard: https://dashboard.4194dc15-250c-4765-9fdc-9c5ab25650ed.dynatrace.training"
echo "BizObs App: https://bizobs.4194dc15-250c-4765-9fdc-9c5ab25650ed.dynatrace.training"
echo "Mattermost: https://mattermost.4194dc15-250c-4765-9fdc-9c5ab25650ed.dynatrace.training"
echo "Registry: https://registry.4194dc15-250c-4765-9fdc-9c5ab25650ed.dynatrace.training"
```

## 🎯 **Expected Result**

After running these commands, you should see:
- BizObs service running on localhost:8080
- All 4 ingresses showing up in `kubectl get ingress -A`
- Working external URLs for dashboard and bizobs

Let me know if any step fails!