#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# =========================================================
# 🚀 Kubernetes GitOps Bootstrap Script
# =========================================================
# Purpose:
# Recreate complete local platform automatically:
#
# - Install ArgoCD
#
# =========================================================

# -----------------------------
# CONFIG
# -----------------------------

PUBLIC_IP=$(curl -s ifconfig.me)

ARGO_NAMESPACE="argocd"

ARGO_RELEASE_NAME="argocd"

ARGO_HELM_REPO="https://argoproj.github.io/argo-helm"

ARGO_VALUES_FILE="${SCRIPT_DIR}/../argocd/argocd-install-values.yaml"

PROJECT_FILE="${SCRIPT_DIR}/../argocd/argocd-project.yaml"

ARGOCD_LOCAL_PORT="8080"

# -----------------------------
# COLORS
# -----------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# -----------------------------
# LOGGING HELPERS
# -----------------------------

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# =========================================================
# INSTALL ARGOCD
# =========================================================

install_argocd() {

    log_info "Installing ArgoCD..."

    helm install "$ARGO_RELEASE_NAME" argo/argo-cd \
        -n "$ARGO_NAMESPACE" \
        -f "$ARGO_VALUES_FILE" \
        # --create-namespace

    log_info "ArgoCD installation completed."
}

# =========================================================
# WAIT FOR ARGOCD
# =========================================================

wait_for_argocd() {

    log_info "Waiting for ArgoCD server..."

    kubectl wait \
        --for=condition=available \
        deployment/argocd-server \
        -n "$ARGO_NAMESPACE" \
        --timeout=300s

    log_info "ArgoCD is ready."
}

# =========================================================
# PORT FORWARD ARGOCD
# =========================================================

port_forward_argocd() {

    log_info "Starting ArgoCD port-forward..."

    kubectl port-forward svc/argocd-server \
      -n "$ARGO_NAMESPACE" \
      ${ARGOCD_LOCAL_PORT}:80 \
      --address=0.0.0.0 \
      > /dev/null 2>&1 &

    sleep 3
    
}

# =========================================================
# FETCH ARGOCD PASSWORD
# =========================================================

fetch_argocd_password() {

    log_info "Fetching ArgoCD admin password..."

    ARGO_PASSWORD=$(kubectl -n "$ARGO_NAMESPACE" get secret argocd-initial-admin-secret \
      -o jsonpath="{.data.password}" | base64 -d)

    echo ""
    echo "========================================="
    echo " ArgoCD Login"
    echo "-----------------------------------------"
    echo " URL:      http://${PUBLIC_IP}:$ARGOCD_LOCAL_PORT"
    echo " Username: admin"
    echo " Password: $ARGO_PASSWORD"
    echo "========================================="
    echo ""
}


# =========================================================
# APPLY PROJECT
# =========================================================

apply_project() {

    log_info "Applying project to ArgoCD..."

    kubectl apply -f "$PROJECT_FILE" -n "$ARGO_NAMESPACE"
    
    echo ""
}

argocd() {
  
  install_argocd
  
  wait_for_argocd
  
  port_forward_argocd
  
  fetch_argocd_password
  
  apply_project

}

argocd