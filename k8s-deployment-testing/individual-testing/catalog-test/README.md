# 🚀 Catalog Service Solo Testing
*Implementation:* ***`In-Memory`** storage*

## 📑 Table of Contents

- **[Overview](#-overview)**
- **[Key Implementations](#-key-implementations)**
- **[Challenges & Solutions](#️-challenges--solutions)**
- **[Outcome](#-outcome)**
- **[Architectural Decision Record (ADR)](#️-architectural-decision-record--adr)**
- **[Key Learnings](#-key-learnings)**
- **[Next Steps](#-next-steps)**
- **[Extra Screenshots](#-extra-screenshots)**


## 📌 Overview

*While reverse engineering this retail microservices app, I **`focused on understanding service interactions, persistence strategies, and deployment across Docker and Kubernetes`**.*

*Instead of replicating everything blindly, I made **`selective architectural decisions`**—keeping implementations that added real learning value (**`DynamoDB for Cart, PostgreSQL for Orders`**) and removing redundant ones.*

*This approach helped me stay focused on orchestration, system behavior, and production-relevant trade-offs **`rather than repeating similar integrations`**.*

------------------------------------------------------------------------

## 🔧 Key Implementations

*Analyzed from top to bottom for env dependencies to **`decouple database from application`** to implement in-memory storage*

-   *Created all deployment resources.*

    ![alt text](screenshots/screenshot05.png)

-   *Implemented only **`which is required`***

    ![alt text](screenshots/screenshot10.png)

------------------------------------------------------------------------

## ⚠️ Challenges & Solutions

*Requirement for database was not obvious. So, I wanted to seperate out the database connection from application.*

***My approach:***

-   *Analyzed requirement from source code (**`config.go`**)*

    ![alt text](screenshots/screenshot04.png)

-   *Confirmed everywhere for **requirements for** **`in-memory storage`** implementation*

    ![alt text](screenshots/screenshot01.png)

    ![alt text](screenshots/screenshot03.png)

-   ***`Simulated the output`** to see the requirements*

    - *password (**`never blank`**). Although it looks blank*

        ![alt text](screenshots/screenshot09.png)

    - *endpoint (**`must be ""`**) for in-memory storage*

        ![alt text](screenshots/screenshot02.png)

-   *Implemented only **`which is required`**.*

    ![alt text](screenshots/screenshot10.png)

------------------------------------------------------------------------

## ✅ Outcome

***`Simplified the architecture while preserving learning depth where it mattered`**. This allowed faster iteration and better focus on system design, service interaction, and deployment strategies.*

*App working as intended:*

![alt text](screenshots/screenshot06.png)

------------------------------------------------------------------------

## 🏛️ Architectural Decision Record 📝 (ADR)

***Context:***

*The Catalog service originally relied on MariaDB for item storage. However, the project scope did not involve dynamic catalog management, and **`similar persistence patterns were already explored in other services`**.*

***Rationale:***

- *No requirement to actively manage or mutate catalog data*
- *Persistence patterns already implemented using DynamoDB (Cart) and PostgreSQL (Orders)*
- *Avoided duplicating the same database integration pattern*
- *Reduced unnecessary operational overhead*
- *Kept focus on Kubernetes orchestration and infrastructure automation*

### The Decision:
***`Removed MariaDB`** integration from the Catalog service.*

------------------------------------------------------------------------

## 💡 Key Learnings

- *Learned to **`validate systems incrementally`** — testing services in isolation before full orchestration improved reliability and debugging clarity*

- *Gianed hands-on experience in reverse engineering systems — **`an invaluable skill for translating legacy applications into scalable microservices architectures`**.*

- *Built practical experience in **`choosing the right persistence layer based on use case`**, instead of applying everything to everywhere*

- ***`Realized the importance of intentional architecture decisions`** — removing components that add complexity without adding learning or value.*

- *Strengthened my ability to think in terms of system design trade-offs, not just implementation*

------------------------------------------------------------------------

## 🚀 Next Steps

1. *Full app deployment on **`Kubernetes`***
2. *IaC Provisioning via **`Terraform`***
3. *Implement **`CI/CD`** pipeline*
4. *Add **`email notification`** system*
5. *Add monitoring (**`Prometheus + Grafana`**)*
6. *Full Automation via one command **`terraform apply`** on **`EKS`***


## 📸 Extra Screenshots

- *Creation of KinD Cluster for local development*

    ![alt text](screenshots/screenshot08.png)

- *Created all K8s resources and validated them*

    ![alt text](screenshots/screenshot07.png)

-   Result:

    ![alt text](screenshots/screenshot06.png)