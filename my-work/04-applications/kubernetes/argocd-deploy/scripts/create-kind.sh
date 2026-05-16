#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# =========================================================
# 🚀 Kubernetes GitOps Bootstrap Script
# =========================================================
# Purpose:
# Recreate complete local platform automatically:
#
# - Create kind cluster
#
# =========================================================

# -----------------------------
# CONFIG
# -----------------------------

CLUSTER_NAME="retail"

KIND_CONFIG="${SCRIPT_DIR}/../kind-cluster/kind-config.yaml"

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
# CREATE KIND CLUSTER
# =========================================================

create_kind_cluster() {

    log_info "Checking if kind cluster exists..."

    if kind get clusters | grep -q "$CLUSTER_NAME"
    then
        log_warn "Kind cluster already exists."
    else

        log_info "Creating kind cluster..."

        kind create cluster \
            --name "$CLUSTER_NAME" \
            --config "$KIND_CONFIG"

        log_info "Kind cluster created."
        
        # no need to set context for kubectl
    fi
}

create_kind_cluster