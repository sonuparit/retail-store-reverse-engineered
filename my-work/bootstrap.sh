#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# =======================================
# 🚀 Kubernetes GitOps Bootstrap Script
# =======================================
# Purpose:
# Recreate complete local platform automatically:
#
# - Bootstrap everything
#
# =======================================

# -----------------------------
# CONFIG
# -----------------------------

EBS_DEVICE="/dev/nvme1n1"

EBS_MOUNT_PATH="/mnt/postgre-data"

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

trap 'log_error "Script failed at line $LINENO"' ERR

# =======================================
# CHECK DEPENDENCIES
# =======================================

check_dependencies() {

    log_info "Checking required tools..."

    tools=("docker" "kubectl" "helm" "kind")

    for tool in "${tools[@]}"
    do
        if ! command -v "$tool" &> /dev/null
        then
            log_error "$tool is not installed."
            exit 1
        fi
    done

    log_info "All dependencies found."
}

# ======================================
# CHECK DOCKER
# ======================================

check_docker() {

    log_info "Checking Docker daemon..."

    if ! docker log_info > /dev/null 2>&1
    then
        log_error "Docker is not running."
        exit 1
    fi

    log_info "Docker is running."
}

# =======================================
# MOUNT EBS
# =======================================

mount_ebs() {

    log_info "Checking EBS mount..."

    if mountpoint -q "$EBS_MOUNT_PATH"
    then
        log_warn "EBS already mounted at $EBS_MOUNT_PATH"
    else

        sudo mkdir -p "$EBS_MOUNT_PATH"

        sudo mount "$EBS_DEVICE" "$EBS_MOUNT_PATH"

        log_info "EBS mounted successfully."
    fi
    echo ""
}

create_kind_cluster() {

  bash "${SCRIPT_DIR}/kubernetes/argocd-deploy/scripts/create-kind.sh"
    
}

create_monitoring_stack() {

  bash "${SCRIPT_DIR}/observability/scripts/monitoring.sh"

}

install_argocd() {

  bash "${SCRIPT_DIR}/kubernetes/argocd-deploy/scripts/install-argocd.sh"

}

install_apps() {

  bash "${SCRIPT_DIR}/kubernetes/argocd-deploy/scripts/install-apps.sh"

}

# =====================================
# MAIN
# =====================================

main() {

  pkill -f "kubectl port-forward" || true

  # check_dependencies

  # check_docker

  mount_ebs

  create_kind_cluster

  create_monitoring_stack
  
  install_argocd
  
  install_apps

  log_info "Bootstrap completed successfully 🚀"
  echo ""
}

main