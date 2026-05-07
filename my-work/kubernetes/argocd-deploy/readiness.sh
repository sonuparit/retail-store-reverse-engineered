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

log_info "Waiting for application to become ready..."

SERVICE_NAME="orders-dev-service"
NAMESPACE="dev"

TIMEOUT=300
INTERVAL=10
ELAPSED=0

while true
do

    ENDPOINTS=$(kubectl get endpointslice \
        -n "$NAMESPACE" \
        -l kubernetes.io/service-name="$SERVICE_NAME" \
        -o jsonpath='{.items[*].endpoints[*].addresses[*]}' \
        2>/dev/null)

    if [ ! -z "$ENDPOINTS" ]
    then
        log_info "Application is ready."
        break
    fi

    if [ "$ELAPSED" -ge "$TIMEOUT" ]
    then
        log_error "Timed out waiting for application readiness."
        exit 1
    fi

    echo "Waiting... (${ELAPSED}s/${TIMEOUT}s)"

    sleep "$INTERVAL"

    ELAPSED=$((ELAPSED + INTERVAL))

done