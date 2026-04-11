# 🚀 Project Goal

*The goal of this project is not just deployment, but to build a production-like DevOps ecosystem independently that showcases a strong understanding of real-world DevOps practices, including:*

- **Containerization**
- **Kubernetes Orchestration**
- **Infrastructure as Code (IaC)**
- **CI/CD Pipelines**
- **Real-Time Alerts**
- **Monitoring**
- **Automation**

## 📑 Table of Contents

- **[Objectives and Sub-goals](#-objectives-and-sub-goals)**
- **[Vision](#-vision)**
- **[Why I Chose This Project](#-why-i-chose-this-project)**
- **[My Key Learnings & Implementation](#-my-key-learnings--implementation)**


## 🎯 Objectives and Sub-goals
1. **📚 To understand the application architecture:**  
*Analyze and reverse-engineer the microservices architecture to gain a deep understanding of how the system works.*

2. **🐳 Containerization:**  
    - *Containerize all services using Docker.*
    - *Docker Compose Setup*
    - *Run and manage multi-container application locally using **`Docker Compose`.***

3. **☸️ Kubernetes Deployment:**  
*Deploy and manage the application in a **`Kubernetes cluster.`***

4. **🏗️ Infrastructure as Code (IaC):**  
*Provision infrastructure using **`Terraform`** for automated and consistent environments.*

5. **ↈ CI/CD Implementation:**  
*Build complete **`CI/CD`** pipelines using:*
    - ***`GitOps`** approach **`(ArgoCD)`***
    - ***`Jenkins approach`** (traditional pipeline)*

6. **📧 Notification System:**  
*Integrate **`email notifications`** for pipeline events and alerts.*

7. **📊 Observability:**  
*Implement monitoring and visualization using:*
    - ***`Prometheus`** (metrics collection)*
    - ***`Grafana`** (dashboard visualization)*

8. **⚡ Finally Full Automation:**  
*Enable complete infrastructure and application setup with a single command:*

    ```yml
    terraform apply
    ```
## 💡 Vision

🌄 *The vision of this project is to **`go beyond the basics`** by simulating a production-grade environment that builds a strong, **`hands-on`** understanding of how real-world DevOps systems are designed, deployed, and operated at scale.*

🎯 *The focus is on mastering end-to-end system design, automation, and observability, while developing the mindset required to design, build, and operate reliable, cloud-native systems. Rather than just learning tools, the goal is to understand the **"`Why?`"** behind each decision—covering architecture, automation, deployment strategies, and observability within a production-like environment.*

## 📌 Why I Chose This Project

### 🔗 This project is intentionally outside my comfort zone.

*I am primarily proficient in **`Python`** and **`JavaScript`**, and deploying applications using these technologies is something I can do with confidence. However, I wanted to challenge myself with something more complex and unfamiliar.*

**💡 That’s why I chose a different technology with microservices architecture.**

---

### 📌 At the time of starting this project:

- *I had no prior experience with Java*
- *The system consists of 5 independent microservices*
- *The architecture is significantly more complex than typical projects*

**🧩 Instead of avoiding this gap, I decided to use it as an opportunity to grow.**

---

### 🧠 This project represents my ability to:

- *Learn unfamiliar technologies quickly*  
- *Understand and work with complex distributed systems*
- *Step out of my comfort zone and take on real-world challenges*

**🌱 For me, this is not just about building a project — it’s about building the mindset required for production-grade DevOps engineering.**

## 🧠 My Key Learnings & Implementation

### 1. [🏗️ App Architecture](./docs/architecture/README.md)

### 2. [📦 Containerzation with Docker](./docs/docker/README.md)

### 3. [🐳 Running app with docker-compose](./docs/docker-compose/README.md)

### 4. ☸️ Kubernetes Deployment (in parts ↴)

1. [**Individual micro service deployment on K8s for operational validation**](./ind-micro-svc-deploy-test-k8s/)

    - ⚡ Persistent DynamoDB integration for carts service *`(to retain data after cluster disposal)`*\
    [read here](./ind-micro-svc-deploy-test-k8s/cart-dynamodb-test/)

    - 🐘 PV and PVC for PostgreSQL database service *`(to retain data after cluster disposal)`*\
    [read here](./ind-micro-svc-deploy-test-k8s/orders-postgreSQL-test/)

    - Testing Checkout service\
    [read here](./ind-micro-svc-deploy-test-k8s/orders-postgreSQL-test/)

    - Testing Orders service\
    [read here](./ind-micro-svc-deploy-test-k8s/orders-postgreSQL-test/)

    - Testing UI service\
    [read here](./ind-micro-svc-deploy-test-k8s/orders-postgreSQL-test/)

2. [**Full app deployment on K8s via Helm**](./full-app-helm-deploy-k8s/)