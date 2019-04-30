#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 config file"
    exit -2
fi

ns=monitoring
kubeCmd="kubectl --kubeconfig $1 "
helmCmd="helm --kubeconfig $1 "

# Uncomment if helm is not initialized
# helm init
# helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/

$kubeCmd create serviceaccount --namespace kube-system tiller
$kubeCmd create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
$kubeCmd --namespace kube-system patch deploy tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
$kubeCmd create namespace $ns
$helmCmd install coreos/prometheus-operator --name prometheus-operator --namespace $ns
$helmCmd install coreos/kube-prometheus --name kube-prometheus --set global.rbacEnable=true --namespace $ns
$kubeCmd patch svc kube-prometheus-grafana -p '{"spec": {"ports": [{"port": 80,"targetPort": 3000,"name": "http"}],"type": "LoadBalancer"}}' -n $ns
