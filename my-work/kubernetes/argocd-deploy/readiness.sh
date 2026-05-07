info "Waiting for application to become ready..."

SERVICE_NAME="orders-dev-service"
NAMESPACE="dev"

TIMEOUT=300
INTERVAL=10
ELAPSED=0

while true
do

    if kubectl get svc "$SERVICE_NAME" -n "$NAMESPACE" > /dev/null 2>&1
    then
        info "Service '$SERVICE_NAME' detected."

        ENDPOINTS=$(kubectl get endpoints "$SERVICE_NAME" \
            -n "$NAMESPACE" \
            -o jsonpath='{.subsets[*].addresses[*].ip}')

        if [ ! -z "$ENDPOINTS" ]
        then
            info "Application is ready."
            break
        fi
    fi

    if [ "$ELAPSED" -ge "$TIMEOUT" ]
    then
        error "Timed out waiting for application readiness."
        exit 1
    fi

    echo "Waiting... (${ELAPSED}s/${TIMEOUT}s)"

    sleep "$INTERVAL"

    ELAPSED=$((ELAPSED + INTERVAL))

done