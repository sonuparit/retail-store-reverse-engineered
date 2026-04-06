# 🏗️ Architectural Understanding:

This project is a retail store application built using a microservices architecture (5 services). I reverse-engineered the system to gain a deep understanding of service communication, dependencies, and Kubernetes-oriented design patterns.

## 📑 Table of contents:
1. **[Overview](#-overview)**
2. **[What I Discovered](#-what-i-discovered)**
3. **[App Architecture](#-app-architecture)**
4. **[Why this design?](#-why-this-design)**
5. **[Why This Project Matters](#-why-this-project-matters)**
6. **[Next Steps](#-next-steps)**

## 📌 Overview:
This app is not my work - I'm just reverse engineering it to better understand microservices, kubernetes and cloud
**Developed a deep understanding of the system by analyzing:**

- *Application source code*
- *Environment variables and configurations*
- *Service dependencies*
- *API communication patterns*

**This helped me map the end-to-end flow of the application and understand how microservices interact within a Kubernetes-style environment.**

## 🧠 What I Discovered:

**Architecture Insights:**

- *This application is a microservices-based demo system designed to replicate real-world Kubernetes behavior.*

**Key observations:**

- *Simulates database interactions without relying on persistent storage*
- *Uses in-memory storage (tmpfs), making services effectively stateless*
- *No Persistent Volumes (PV) or Persistent Volume Claims (PVC) are used*
- *Service communication is handled via structured API calls and headers*
- *Supports optional integration with external databases if needed*

## 🏗️ App Architecture (Original):

![alt text](screenshots/architecture.png)

| Component            | Language |  Description                            |
| -------------------- | -------- | --------------------------------------- |
| UI                   | Java     | Store user interface                    |
| Catalog              | Go       | Product catalog API                     |
| Cart                 | Java     | User shopping carts API                 |
| Orders               | Java     | User orders API                         |
| Checkout             | Node     | API to orchestrate the checkout process |


### 💡 Why this design?

**This architecture is intentionally designed to:**

- *Simplify deployment and setup*
- *Eliminate state management complexity*
- *Focus on service interaction and orchestration*
- *Enable easy experimentation in Kubernetes environments*

### 💡 Why This Project Matters

**This project demonstrates my ability to:**

- *Analyze and understand complex distributed systems*
- *Reverse-engineer real-world architectures*
- *Identify design trade-offs (stateless vs persistent systems)*
- *Work with microservices in a Kubernetes-oriented setup*

### 📌 Conclusion:

**The application is intentionally designed to be stateless, prioritizing:**

- *Portability*
- *Simplicity*
- *Kubernetes behavior simulation*

**over long-term data persistence.**

---

## 🔧 Next Steps
1. *Deep dive into **`Dockerfile optimization`** → [Docker Analysis](../docker/README.md)*
2. *Refactor setup for production-ready Docker Compose*
3. *Implement Kubernetes deployments*
4. *Provision infrastructure using Terraform (IaC)*
5. *Build a CI/CD pipeline*
6. *Add email notification system*
7. *Integrate monitoring (Prometheus + Grafana)*
8. *Full Automation via one command **`terraform apply`***

---

![Note] This is not my original application. I reverse-engineered it to build a deeper understanding of microservices, Kubernetes, and cloud-native architectures.