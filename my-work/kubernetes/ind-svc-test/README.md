# 🚀 Microservices Individual Testing

*After **`Docker Compose`**, I didn’t directly jump to Kubernetes.*

*Instead, I **`isolated each microservice and tested them individually using custom-written Kubernetes YAML manifests`**.*

*This helped me **`verify service-level behavior, dependencies, and communication patterns in a better and controlled way`**.*

Once confident, I moved toward full Kubernetes deployment.

## 🧠 What I Did

🔗 *Individual service **`testing and configs`** are linked below:*

- ### 1. Carts Service *[(know more)](./cart-dynamodb-test/README.md)*

    - *Integrated **`persistent DynamoDB`** integration for Carts service*


- ### 2. Catalog Service *[(know more)](./catalog-test/README.md)*

    - *Used **`in-memory storage`** for Catalog service*


- ### 3. Checkout Service *[(know more)](./checkout-test/README.md)*

    - *Used **`in-memory storage`** for Checkout service*


- ### 4. Orders Service *[(know more)](./orders-postgreSQL-test/README.md)*

    - *Implemeted **`persistent PostgreSQL DB`** integration for Orders service*

    - *Deferred **`RabbitMQ`** integration to **`focus on Kubernetes orchestration and Terraform-driven automation`***


- ### 5. UI Service *[(know more)](./ui-test/README.md)*

    - *Removed **`Kubernetes-specific environment flags`** to keep the application agnostic of its runtime environment*

## ☸️ Final Kubernetes Deployment