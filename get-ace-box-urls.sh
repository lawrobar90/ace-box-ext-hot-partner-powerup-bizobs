#!/bin/bash
# Simple script to get all ACE Box URLs

echo "🔗 ACE Box URL Discovery Script"
echo "================================="

# Get the ingress domain from environment or kubectl
INGRESS_DOMAIN=$(kubectl get configmap ace-box-config -o jsonpath='{.data.INGRESS_DOMAIN}' 2>/dev/null || echo "UNKNOWN")
if [ "$INGRESS_DOMAIN" = "UNKNOWN" ]; then
    INGRESS_DOMAIN=$(kubectl get ingress -A -o jsonpath='{.items[0].spec.rules[0].host}' | cut -d'.' -f2-)
fi

echo "🌐 Domain: $INGRESS_DOMAIN"
echo ""

echo "📋 Available URLs:"
echo "==================="

# Get all ingresses and extract URLs
kubectl get ingress -A -o custom-columns="NAMESPACE:.metadata.namespace,NAME:.metadata.name,HOST:.spec.rules[0].host,PORT:.spec.rules[0].http.paths[0].backend.service.port.number" --no-headers | while read namespace name host port; do
    if [ "$host" != "<none>" ] && [ "$host" != "" ]; then
        protocol="https"
        if [ "$port" = "80" ] || [ "$port" = "" ]; then
            echo "🔗 $name: $protocol://$host"
        else
            echo "🔗 $name: $protocol://$host:$port"
        fi
    fi
done

echo ""
echo "🔍 Quick Access Commands:"
echo "=========================="
echo "Dashboard: curl -k https://dashboard.$INGRESS_DOMAIN"
echo "BizObs:    curl -k https://bizobs.$INGRESS_DOMAIN/api/health"
echo "Registry:  curl -k https://registry.$INGRESS_DOMAIN"
echo "Mattermost: curl -k https://mattermost.$INGRESS_DOMAIN"