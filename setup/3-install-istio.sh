#!/bin/bash

# Log script activity (https://serverfault.com/a/103569)
# exec 3>&1 4>&2
# trap 'exec 2>&4 1>&3' 0 1 2 3
# exec 1>/var/log/start-istio.log 2>&1
# set -x        

curl -L https://istio.io/downloadIstio | sh -
export PATH="$PATH:/root/istio-${ISTIO_VERSION}/bin"
istioctl install -y --set profile=demo

# Fixes the "<pending>" state found with this inspection: kubectl get service istio-ingressgateway -n istio-system
INGRESS_HOST=$(hostname -I | awk '{print $1}')

cat <<EOF >>patch.yaml
spec:
  externalIPs: 
    - $INGRESS_HOST
EOF

kubectl patch service -n istio-system istio-ingressgateway --patch "$(cat patch.yaml)"

kubectl get deployments,services -n istio-system

# Install Istio integrations
SEMVER_REGEX='[^0-9]*\([0-9]*\)[.]\([0-9]*\)[.]\([0-9]*\)\([0-9A-Za-z-]*\)'
INTEGRATIONS_VERSION=$(echo $ISTIO_VERSION | sed -e "s#$SEMVER_REGEX#\1#").$(echo $ISTIO_VERSION | sed -e "s#$SEMVER_REGEX#\2#")

## Install Jaeger integration
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-$INTEGRATIONS_VERSION/samples/addons/jaeger.yaml

kubectl apply -f dashboards.yaml