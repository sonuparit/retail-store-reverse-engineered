#!/bin/bash

set -e

NAMESPACE="monitoring"

echo "========================================="
echo " Creating monitoring namespace"
echo "========================================="

kubectl apply -f monitoring/namespace.yaml

echo ""
echo "========================================="
echo " Adding Helm repositories"
echo "========================================="

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/

helm repo update

echo ""
echo "========================================="
echo " Installing Metrics Server"
echo "========================================="

helm install metrics-server metrics-server/metrics-server \
  -n kube-system \
  -f monitoring/metrics-server.yaml

echo ""
echo "========================================="
echo " Installing kube-prometheus-stack"
echo "========================================="

helm upgrade --install kube-prom-stack prometheus-community/kube-prometheus-stack \
  -n ${NAMESPACE} \
  -f monitoring/values-monitoring.yaml

echo ""
echo "========================================="
echo " Waiting for monitoring stack pods"
echo "========================================="

kubectl wait --for=condition=Ready pod \
  --all \
  -n ${NAMESPACE} \
  --timeout=300s

echo ""
echo "========================================="
echo " Applying ServiceMonitors"
echo "========================================="

kubectl apply -f service-monitors/argocd.yaml \
  -n ${NAMESPACE}

echo ""
echo "========================================="
echo " Monitoring stack installed successfully"
echo "========================================="

echo ""
echo "Useful commands:"
echo ""
echo "Check ServiceMonitors:"
echo "kubectl get servicemonitors -n ${NAMESPACE}"
echo ""
echo "Check Prometheus targets:"
echo "kubectl port-forward svc/kube-prom-stack-kube-prome-prometheus 9090:9090 -n ${NAMESPACE}"
echo ""
echo "Open Grafana:"
echo "kubectl port-forward svc/kube-prom-stack-grafana 3000:80 -n ${NAMESPACE}"
echo ""
echo "Get Grafana password:"
echo "kubectl get secret -n ${NAMESPACE} kube-prom-stack-grafana -o jsonpath='{.data.admin-password}' | base64 -d && echo"