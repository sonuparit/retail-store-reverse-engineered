# 🚀 Kuberenetes Deployment
*After **`Docker Compose`**, I didn’t directly jump to Kubernetes.*

*Instead, I **`isolated each microservice and tested them individually using custom-written Kubernetes YAML manifests`**.*

*This helped me **`verify service-level behavior, dependencies, and communication patterns in a better and controlled way`**.*

Once confident, I moved toward full Kubernetes deployment.

## 🧠 What I Did

### 1. 🔗 Individual service testing [(read here)](./ind-svc-test/):

- ### I. Carts Service *[(know more)](./ind-svc-test/cart-dynamodb-test/)*

    - *Integrated **`persistent DynamoDB`** integration for Carts service*


- ### II. Catalog Service *[(know more)](./ind-svc-test/catalog-test/)*

    - *Used **`in-memory storage`** for Catalog service*


- ### III. Checkout Service *[(know more)](./ind-svc-test/checkout-test/)*

    - *Used **`in-memory storage`** for Checkout service*


- ### IV. Orders Service *[(know more)](./ind-svc-test/orders-postgreSQL-test/)*

    - *Implemeted **`persistent PostgreSQL DB`** integration for Orders service*

    - *Deferred **`RabbitMQ`** integration to **`focus on Kubernetes orchestration and Terraform-driven automation`***


- ### V. UI Service *[(know more)](./ind-svc-test/ui-test/d)*

    - *Removed **`Kubernetes-specific environment flags`** to keep the application agnostic of its runtime environment*

### 2. ☸️ Final Kubernetes Deployment [(know more)](./final-app/)