# 🚀 Microservices Individual Testing

*After **`Docker Compose`**, I didn’t directly jump to Kubernetes.*

*Instead, I **`isolated each microservice and tested them individually using custom-written Kubernetes YAML manifests`**.*

*This helped me **`verify service-level behavior, dependencies, and communication patterns in a better and controlled way`**.*

Once confident, I moved toward full Kubernetes deployment.

## 🔗 Individual service deployment

*Individual service **`testing and configs`** are linked below:*

- ### 1. Carts Service *[(know more)](./ind-svc-test/cart-dynamodb-test/)*

  - ***`Persistent DynamoDB`** integration for Carts service*

- ### 2. Catalog Service *[(know more)](./ind-svc-test/catalog-test/)*

  - *Used **`in-memory storage`** for Catalog service*

- ### 3. Checkout Service *[(know more)](./ind-svc-test/checkout-test/)*

  - *Used **`in-memory storage`** for Checkout service*

- ### 4. Orders Service *[(know more)](./ind-svc-test/orders-postgreSQL-test/)*

  - *Implemeted **`persistent PostgreSQL DB integration for Orders service by using external EBS volume`**, to sustain data after cluster disposal*

  - *Deferred **`RabbitMQ`** integration to **`focus on Kubernetes orchestration and Terraform-driven automation`***

- ### 5. UI Service *[(know more)](./ind-svc-test/ui-test/)*

  - *Removed **`Kubernetes-specific environment flags`** to keep the application agnostic of its runtime environment*

## ☸️ Final Kubernetes Deployment

### 1. helmfile deployment *[(read more)](./helmfile-deploy/)*

- ***`Integrated two distinct approaches`** to handle application secrets securely without relying on hardcoded credentials*

    1. **Carts Service:**\
        ***`Implemented AWS Instance Metadata Service (IMDSv2) to securely manage dynamodb credentials`**, removing any hard coded secrets*

    2. **Orders service:**\
        ***`Added External Secrets Operator (ESO) - Custom Resource Definition (CRD) to pull secrets from AWS secrets manager`**, removing any hard coded secrets from code*

- **Created env specific dynamic chart naming to avoid naming colision for multi deployments**

### 2. Argo deployment *[(read more)](./argocd-deploy/)*

- Currently under progress...
