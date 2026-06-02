# 🚀 Productionizing a Microservices Application (Reverse-Engineered)

> [!NOTE]
> This project is based on an existing application that I reverse-engineered and enhanced → [(original repo)](https://github.com/aws-containers/retail-store-sample-app).

> [!NOTE]
> Beyond this implementation, the Application layer of the project was deployed on AWS EKS Auto Mode, Terraform-provisioned infrastructure, and full ArgoCD-driven GitOps CI/CD workflows → [(View Implementation)](https://github.com/sonuparit/terraform-gitops-pipeline).

[intro]*

## 📑 Table of Contents

- [Overview]()
- [Tech Stack]()
- [Implementation Roadmap]()
- [Project Architecture]()
- [Repository Structure]()
- [Project Navigation]()
- [Engineering Highlights]()
- [Screenshots]()
- [Quick Start]()
- [Future Improvements]()

## 📖 Overview

Reverse engineered and productionized a distributed microservices application using Docker, Kubernetes, Helm, Helmfile, and ArgoCD with multi-environment GitOps workflows.

Implemented end-to-end observability, automated deployments, reusable infrastructure templates, and production-grade monitoring using Prometheus, Grafana, and Loki.

## 🛠️ Tech Stack

## 🗺️ Implementation Roadmap

<p align="left">
  <img src="./overview.jpg" width="80%"/>
</p>

## 🏗️ Project Architecture

## 📂 Repository Structure

```text
.
├── README.md
├── LICENSE
├── overview.jpg
├── my-work
│   ├── 01-infrastructure
│   ├── 02-platform
│   ├── 03-observability
│   ├── 04-applications
│   ├── bootstrap
│   └── screenshots
└── src-code
    ├── cart
    ├── catalog
    ├── checkout
    ├── orders
    ├── ui
    ├── misc
    └── screenshots
```

## 🧭 Project Navigation

### 1. Understanding Phase (Reverse Engineered)

- [Source Code Understanding](https://github.com/sonuparit/retail-store-reverse-engineered/tree/main/src-code)
- [Architecture Understanding](https://github.com/sonuparit/retail-store-reverse-engineered/tree/main/my-work/04-applications/architecture)
- [Containerization (Docker)](https://github.com/sonuparit/retail-store-reverse-engineered/tree/main/my-work/04-applications/docker)
- [Docker Compose Orchestration](https://github.com/sonuparit/retail-store-reverse-engineered/tree/main/my-work/04-applications/docker-compose)

### 2. Implementation Phase (Kubernetes)

- [Individual Service Testing](https://github.com/sonuparit/retail-store-reverse-engineered/tree/main/my-work/04-applications/kubernetes/ind-svc-test)
  - [Carts](https://github.com/sonuparit/retail-store-reverse-engineered/tree/main/my-work/04-applications/kubernetes/ind-svc-test/cart-dynamodb-test)
  - [Catalog](https://github.com/sonuparit/retail-store-reverse-engineered/tree/main/my-work/04-applications/kubernetes/ind-svc-test/catalog-test)
  - [Checkout](https://github.com/sonuparit/retail-store-reverse-engineered/tree/main/my-work/04-applications/kubernetes/ind-svc-test/checkout-test)
  - [Orders](https://github.com/sonuparit/retail-store-reverse-engineered/tree/main/my-work/04-applications/kubernetes/ind-svc-test/orders-postgreSQL-test)
  - [UI](https://github.com/sonuparit/retail-store-reverse-engineered/tree/main/my-work/04-applications/kubernetes/ind-svc-test/ui-test)
- [Helm Templating](https://github.com/sonuparit/retail-store-reverse-engineered/tree/main/my-work/04-applications/kubernetes/helm-template)
- [Full App Deployment via Helmfile](https://github.com/sonuparit/retail-store-reverse-engineered/tree/main/my-work/04-applications/kubernetes/helmfile-deploy)
- [Multi-Environment GitOps via ArgoCD](https://github.com/sonuparit/retail-store-reverse-engineered/tree/main/my-work/04-applications/kubernetes/argocd-deploy)

### 3. Production phase

- [Monitoring & Observability](https://github.com/sonuparit/retail-store-reverse-engineered/tree/main/my-work/03-observability)
- [Production-Grade GitOps Workflow](https://github.com/sonuparit/retail-store-reverse-engineered/tree/main/my-work)

## ⚙️ Engineering Highlights

## 📸 Screenshots

## 📦 Deployment Guide

## ⭐ Future Improvements

## 🕵 Why I Chose This Project

### 🧗‍♂️ This project is intentionally outside my comfort zone

*I am primarily proficient in **`Python`** and **`JavaScript`**, and deploying applications using these technologies is something I can do with confidence. However, I wanted to challenge myself with something more complex and unfamiliar.*

**💡 That’s why I chose a different technology with microservices architecture.**

### 📌 At the time of starting this project

- *I had **`no prior experience with Java`***
- *The system consists of **`5 independent microservices`***
- *The architecture is significantly more complex than typical projects*

**🧩 Instead of avoiding this gap, I decided to use it as an opportunity to grow.**

---

## 🎯 Features

- GitOps-driven continuous delivery using ArgoCD with ApplicationSets for scalable multi-environment deployments (`dev`, `stage`, `prod`)
- Modular Kubernetes platform architecture using Helm, Helmfile, and Kustomize-based configuration management
- Layered separation of platform and application infrastructure for scalable orchestration and maintainability
- Dependency-aware deployment workflows with reconciliation, drift correction, and self-healing mechanisms
- Secure cloud-native secret management using External Secrets Operator, IAM roles, and IMDSv2-based credential-less authentication
- Principle of Least Privilege (PoLP), RBAC-aware segmentation, and hardened non-root container security practices
- Stateful and stateless workload engineering using PostgreSQL StatefulSets, DynamoDB integration, and persistent EBS-backed storage
- Environment-isolated storage, monitoring, logging, and telemetry workflows for operational separation and observability
- Kubernetes-native service discovery, networking, and production-grade runtime optimization
- Distributed systems troubleshooting across Kubernetes, IAM, storage, networking, CRDs, Helm templating, and init-container workflows
- Architecture reverse-engineering, dependency analysis, and infrastructure simplification for production-ready microservices platforms
- End-to-end validation of scalable, failure-resilient, cloud-native deployment architectures aligned with real-world DevOps practices

## 📊 Current Status

- ✅ Microservices containerized and orchestrated (**Docker → Kubernetes**)
- ✅ **Stateful + stateless** services implemented with production patterns
- ✅ Secure **cloud integrations** (IAM, Secrets Manager, IMDSv2, DynamoDB, EBS)
- 🚧 GitOps (**ArgoCD**) in progress...

## ⚙️ Key Engineering Work

### 1. 🏗️ App Architecture [(read here)](./my-work/architecture/)

- **Reverse-engineered** 5-service microservices architecture
- Mapped **service communication, dependencies, and API flows**
- Analyzed stateless, Kubernetes-oriented design (**tmpfs-based**)

### 2. 📦 Containerzation with Docker [(read here)](./my-work/docker/)

- **Reverse-engineered Dockerfiles** across all services
- Optimized base image (**AL2023-minimal, −190MB**)
- **Maintained compatibility** (dnf + glibc)
- Enforced **non-root** container execution

### 3. 🐳 Running app with docker-compose [(read here)](./my-work/docker-compose/)

- Reverse-engineered multi-service **Compose** setup
- Mapped **env variables** and **service** dependencies
- Built **unified setup** with shared network
- Validated system via **health checks & E2E testing**

### 4. ☸️ Kubernetes Deployment (in parts ↴) [(read more)](./my-work/kubernetes/)

#### 4.1 - Individual Microservice-level operational validation & enhancements [(read here)](./my-work/kubernetes/ind-svc-test/)

- **Carts service** [(read here)](./my-work/kubernetes/ind-svc-test/cart-dynamodb-test/)

  - Integrated **AWS DynamoDB** (replaced in-memory storage)
  - Enforced **production-safe design** (disabled auto table creation)
  - Applied **least-privilege** access (IAM + K8s secrets)
  - Eliminated **race conditions & infra drift**

- **Orders service** [(read here)](./my-work/kubernetes/ind-svc-test/orders-postgreSQL-test/)

  - Implemented **persistent PostgreSQL** (PV/PVC on AWS EBS)
  - Designed **stateful** workload (StatefulSet + storage)
  - Secured volume access (**fsGroup**, non-root)
  - Ensured **data durability** across restarts

- **Catalog service** [(read here)](./my-work/kubernetes/ind-svc-test/catalog-test/)

  - Removed **MariaDB** dependency (in-memory design)
  - Simplified service architecture
  - Decoupled DB from service via **source code analysis**

- **Checkout service** [(read here)](./my-work/kubernetes/ind-svc-test/checkout-test/)

  - Removed **Redis** dependency (stateless workflow)
  - **Simplified** service architecture
  - Derived minimal runtime config via **source code analysis**

- **UI service** [(read here)](./my-work/kubernetes/ind-svc-test/ui-test/)

  - Made service **environment-agnostic**
  - Decoupled **observability** from application logic

#### 4.2 - Full app deployment on Kubernetes

- **helmfile deployment** [(read here)](./my-work/kubernetes/helmfile-deploy/)

  - Designed modular **Helm charts with environment-based configs**
  - Implemented secure secrets flow (**AWS Secrets Manager + ESO**)
  - Enabled **credential-less** AWS access via IMDSv2 (IAM roles, no static keys)
  - Orchestrated **dependency-aware** deployments with Helmfile
  - Validated full-stack deployment via **service-level testing**
  - Debugged complex issues (**CRDs, IAM policies, init containers, templating**)

- **ArgoCD deployment** [(read here)](./my-work/kubernetes/argocd-deploy/)

  - Extended the Kubernetes deployment into a full **GitOps-based continuous delivery workflow**
  - Built **multi-environment deployments** (`dev`, `stage`, `prod`) using ArgoCD ApplicationSets
  - Separated **platform and application layers** for cleaner orchestration and scalability
  - Managed deployment ordering with **Sync Waves, Kustomize, and reconciliation-aware design**
  - Implemented **persistent multi-environment PostgreSQL storage** on external EBS-backed volumes
  - Solved complex operational issues involving **CRDs, Helm rendering, secret readiness, and storage isolation**

## ⚙️ Key Engineering Work

### 🏗️ Architecture & Reverse Engineering

- Reverse-engineered a distributed 5-service microservices application
- Analyzed service communication, runtime dependencies, and Kubernetes-oriented design
- Built deployment architecture from source code understanding

### 📦 Containerization & Local Orchestration

- Productionized Docker images across all services
- Optimized container footprint and enforced non-root security practices
- Built complete multi-service orchestration using Docker Compose

### ☸️ Kubernetes Platform Engineering

- Individually validated and productionized all microservices on Kubernetes
- Implemented persistent and stateless workload strategies based on application behavior
- Built reusable Helm-based deployment architecture with Helmfile orchestration

### 🚀 GitOps & Multi-Environment Delivery

- Designed multi-environment GitOps workflows using ArgoCD ApplicationSets
- Implemented environment-aware deployments across `dev`, `stage`, and `prod`
- Solved complex deployment, reconciliation, and dependency-ordering challenges

### 📊 Observability & Production Operations

- Implemented production-grade monitoring using Prometheus, Grafana, Loki, Alertmanager  and exporters
- Built reusable observability workflows for Kubernetes workloads
- Improved operational visibility, troubleshooting, and deployment reliability
