# 🚀 DynamoDB Integration in Microservices (From Mock to Production)

## 📌 Overview

This section of project demonstrates the transition from in-memory mock storage to
a real AWS DynamoDB integration within a microservices-based retail
application.

The goal was to move closer to a production-ready architecture by
replacing simulated components with actual cloud services.

------------------------------------------------------------------------

## 🔧 Key Implementations

-   Replaced in-memory storage with **AWS DynamoDB**
-   Configured **IAM user** with appropriate DynamoDB permissions
-   Implemented secure access using **AWS Access Keys** (lab setup)
-   Analyzed service dependencies and database requirements

------------------------------------------------------------------------

## ⚠️ Challenges & Solutions

**Issue:**\
The application failed due to a missing DynamoDB index required by the
cart service.

**Solution:**\
- Investigated service logic and query patterns\
- Identified the required index structure\
- Designed and created the missing index

------------------------------------------------------------------------

## ✅ Outcome

-   Successfully integrated DynamoDB with the cart service\
-   Achieved a **fully functional, cloud-backed microservice**\
-   Improved system reliability and realism for production scenarios

------------------------------------------------------------------------

## 💡 Key Learning

This implementation highlights an important DevOps principle:

> Transitioning from mock environments to real cloud services is
> essential for building production-grade systems.

------------------------------------------------------------------------

## 🛠 Tech Stack

-   AWS DynamoDB\
-   IAM (Access Management)\
-   Microservices Architecture\
-   Docker / Containerized Services

------------------------------------------------------------------------

## 🚀 Next Steps

-   Implement **IRSA (IAM Roles for Service Accounts)** in Kubernetes
    (EKS)\
-   Enhance security by eliminating static credentials\
-   Move toward a fully cloud-native deployment
