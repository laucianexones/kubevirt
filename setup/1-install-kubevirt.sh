#! /bin/sh

export RELEASE=v0.48.0
kubectl apply -f https://github.com/kubevirt/kubevirt/releases/download/${RELEASE}/kubevirt-operator.yaml
kubectl apply -f https://github.com/kubevirt/kubevirt/releases/download/${RELEASE}/kubevirt-cr.yaml


export VERSION=v0.41.0
wget https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/virtctl-${VERSION}-linux-amd64

mv virtctl-${VERSION}-linux-amd64 virtctl
chmod +x virtctl
mv virtctl /usr/local/bin/