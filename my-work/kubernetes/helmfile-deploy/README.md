# 🚀 Helmfile-Based Deployment on K8s

## 📑 Table of Contents

1. **[Overview](#-overview)**
2. **[Project Structure with Helmfile](#️-project-structure-with-helmfile)**
3. **[What this Project Demonstrates](#-what-this-project-demonstrates)**
4. **[My Implementations](#️-my-implementations)**
5. **[Challenges & Debugging](#-challenges--debugging)**
6. **[What I Learned](#-what-i-learned)**
7. **[Limitations of helmfile](#️-limitations-of-helmfile)**
8. **[How to Run](#️-how-to-run)**
9. **[What's Next](#-whats-next)**
10. **[Final thoughts](#-final-thoughts)**

## 📖 Overview

*This project demonstrates **`deploying a reverse-engineered retail microservices application on Kubernetes using Helm and Helmfile`**.*

*The goal was to move from raw Kubernetes manifests to a more **`structured,
scalable, and production-like deployment approach`**.*

------------------------------------------------------------------------

## 🏗️ Project Structure with Helmfile

- *External Secrets Operator-CRD **`eso-crd.yaml`***
- *Centralized **`helmfile.yaml`** to orchestrate deployments*
- *kind config for **`KinD cluster`***
- *Individual **`Helm charts`** for each microservice*
- *Environment specific deployment with **`values`***
```
repo*
├── eso-crd.yaml
├── helmfile.yaml.gotmpl
├── kind-config.yml
├── charts
│   ├── carts
│   ├── catalog
│   ├── checkout
│   ├── orders
│   ├── secret-configs
│   └── ui
└── values
    ├── eks-prod.yml
    └── kind-ec2.yml
```

------------------------------------------------------------------------

## 🎯 What This Project Demonstrates

-   *Transition from raw YAML → **`Helm-based deployments`***
-   *Multi-service orchestration using Helmfile*
-   ***`Dependency-aware deployments`***
-   ***`Secure secret management using AWS Secrets Manager + Kubernetes`***
-   *Real-world DevOps workflow simulation*

------------------------------------------------------------------------

## ⚙️ My Implementations

### ⚓ Helm Chart Design for Each Service:

- *Designed and created dedicated Helm charts for each microservice (carts, catalog, checkout, orders, UI).*

    ![alt text](screenshots/screenshot08.png)

- *Implemented consistent and meaningful naming conventions*

    ![alt text](screenshots/screenshot09.png)

- ***`Built a smart auto-generated password mechanism`** for the catalog service to avoid hardcoded credentials.*

    ![alt text](screenshots/screenshot10.png)

- ***`Developed a custom secret-configs Helm chart from scratch`** to manage centralized secret definitions*

    ![alt text](screenshots/screenshot11.png)

### 🛡️ AWS IMDSv2 for DynamoDB access

*To provide the Carts Service with secure, credential-less access to DynamoDB, I leveraged **`AWS Instance Metadata Service v2 (IMDSv2)`**. This approach eliminates the need for hardcoded **`AWS_ACCESS_KEY_ID`** or long-lived secrets, significantly reducing the attack surface.*

- **`Identity-Based Access:`**\
    *The EC2 Node is assigned an IAM Role with a scoped policy allowing dynamodb:GetItem and dynamodb:Query on the Items table.*

    ![alt text](screenshots/screenshot30.png)

- **`The Challenge:`**\
    *By default, IMDSv2 responses have a Time-to-Live (TTL/Hop Limit) of 2. In a containerized environment, the packet must travel from the Node to the Docker Bridge and finally to the Pod.*

- **`The Solution:`**\
    *I tuned the http-put-response-hop-limit to 3. This ensures the metadata response can successfully traverse the virtual bridge to reach the application container while maintaining the security boundary.*

    ![alt text](screenshots/screenshot32.png)

**Impact:**

1. ***`Zero-Secret Management:`** No AWS keys are stored in the codebase or K8s Secrets.*

2. ***`Production Readiness:`** Adheres to AWS security best practices by enforcing IMDSv2-only access.*

### 🔐 Secure Secrets Integration

- ***`Integrated AWS Secrets Manager`** for external secret storage*

    ![alt text](screenshots/screenshot04.png)

- ***`Used External Secrets Operator (ESO)`** to sync secrets into Kubernetes*

    ![alt text](screenshots/screenshot12.png)

- *Ensured secrets were dynamically injected into pods without hardcoding*

    ![alt text](screenshots/screenshot03.png)

### 🧪 Incremental Validation Strategy

- ***`Followed a tiered testing approach`** to ensure each component was functional and stable independently*

    ![alt text](screenshots/screenshot02.png)

- ***`Performed isolated, service-by-service validation`** of each Helm chart before full system deployment*

    ![alt text](screenshots/screenshot27.png)

- *This helped in:*
    - **`Identifying and debugging issues at the service level`**
    - ***`Avoiding compounded errors`** during full-stack deployment*
    - ***`Improving deployment confidence and reliability`***

### ✅ Result:

- ***`Eliminated risk of secret exposure in codebase`** and moving to identity-based and externalized secret management.*

- ***`Built a production-grade deployment workflow`** with modular Helm charts and isolated validation, improving reliability and debugging efficiency.*

- ***`Achieved secure, scalable architecture`** by integrating AWS-native services (IMDSv2, Secrets Manager) with Kubernetes best practices.*

- ***`Improved system maintainability`** through consistent naming, reusable configurations, and centralized secret handling.*

------------------------------------------------------------------------

## 🧩 Challenges & Debugging

### 🏷️ Resource Naming Confusion

- *helm chart used identical names across Services, Deployments, and ConfigMaps, which caused ambiguity and debugging difficulty*

    ![alt text](screenshots/screenshot13.png)

- ***`Faced issues identifying correct service endpoints, especially for database connectivity`***

    ![alt text](screenshots/screenshot05.png)

- ***`Refactored all resource names using meaningful, context-aware conventions`***

    ![alt text](screenshots/screenshot14.png)

**✅ Result:**

- ***`Improved clarity`** across the system*
- ***`Faster debugging`** and easier traceability*

### 🧭 Chart Navigation Complexity

- *Navigating between values.yaml → templates → configs → _helpers.tpl across multiple charts became difficult*

    ![alt text](screenshots/screenshot07.png)

- *Understanding value flow and template rendering required careful tracing*

**✅ Insight:**

- *Learned how Helm templating layers interact*
- *Improved ability to debug and reason about chart structure*

### ⚠️ `kubectl apply` vs `kubectl create` (CRD Issue)

- Initially used kubectl apply for installing ESO-CRDs, which caused inconsistent and failed deployments

    ![alt text](screenshots/screenshot19.png)

**👉 Why it failed:**

- *apply expects an existing resource state to patch/update*
- *CRDs (especially from operators) often require clean, first-time creation*
- *CRDs are huge and K8s, kubectl apply stores the entire configuration in an annotation, and **`CRDs often exceed the 262KB limit for annotations`**, hence they fail*

**✅ Fix:**

- ***`Switched to kubectl create for CRD installation`** before deploying dependent resources*

    ![alt text](screenshots/screenshot20.png)

**👉 Why create worked:**

- ***`kubectl create or kubectl apply --server-side bypasses limit of 262KB limit for annotations`***
- *kubectl create ensures a fresh, atomic creation of CRDs*
- *CRDs are meant to be installed once and managed by the operator afterward*


### 🚧 Init Container Blocking Orders Service
- Orders service failed to start due to init container never completing

    ![alt text](screenshots/screenshot09.png)

- Root cause: used application service port instead of database service port in readiness check

    ![alt text](screenshots/screenshot19.png)


**✅ Fix:**

- *Corrected the target service endpoint for database connectivity*

**💡 Lesson:**

- *Small configuration mistakes in dependencies can block entire service startup*

### 🧬 Go Template Whitespace Issue
- *Misuse of **"`-`"** (whitespace trimming) in Helm templates caused invalid YAML rendering*

    ![alt text](screenshots/screenshot20.png)

- *This resulted in deployment failures*

    ![alt text](screenshots/screenshot01.png)

**👉 Example problem:**

- **{{`-` ... }}** *removes spaces, which can break YAML structure*

**✅ Fix:**

- *Avoided aggressive whitespace trimming except where necessary (e.g., _helpers.tpl)*

**💡 Lesson:**

- ***`YAML`** is highly sensitive to formatting — template control must be used carefully*

### 🛡️ DynamoDB Fine-Grained Permissions (PoLP)

- *Implementing the Principle of Least Privilege (PoLP), initially granting broad access which compromised security best practices*

- *Faced repeated **`"AccessDeniedException"`** errors despite having Query and Scan permissions enabled*

    ![alt text](screenshots/screenshot36.png)

- *Discovered that DynamoDB Global Secondary Indexes (GSIs) are treated as distinct resources and **`require explicit ARN definitions`***

    ![alt text](screenshots/screenshot37.png)

**✅ Fix:**

- *Refined the IAM policy to target specific Table and Index ARNs rather than using wildcards on all resources*

------------------------------------------------------------------------

## 📚 What I Learned

**Helm beyond basics:**
- *designing reusable charts, managing naming conventions, and understanding template flow across values.yaml, templates, and _helpers.tpl*

**Deployment vs runtime dependencies:**
- Helmfile handles ordering, but service communication issues must be solved at runtime

**Incremental validation mindset:**
- testing services in isolation significantly reduces debugging complexity in distributed systems

**Cloud Security & Container Networking:**
- Leveraging IMDSv2 with IAM Roles, I learned that in containerized environments like KinD, tuning network hop limits is critical to ensuring metadata can successfully traverse the virtual bridge to reach the Pod.

**Secrets management in production:**
- integrating AWS Secrets Manager with ESO eliminates hardcoded secrets and improves security posture

**Principle of Least Privilege (PoLP) in action:**
- PoLP is iterative — it often requires debugging specific resource paths that aren't immediately obvious, like sub-resource ARNs for indexes

**Kubernetes debugging skills:**
- identifying issues across services, init containers, and configurations through systematic troubleshooting

**CRD lifecycle awareness:**
- knowing when to use kubectl create vs apply for reliable operator-based resource installation

**Attention to detail matters:**
- small mistakes (ports, naming, whitespace in templates) can break entire deployments

------------------------------------------------------------------------

## ⚠️ Limitations of Helmfile

**No Continuous Reconciliation**
- *Helmfile is not a true GitOps tool — **`it does not continuously monitor and enforce cluster state`***
- ***`Requires manual execution`** (`helmfile sync`) to apply changes*

**Limited Drift Detection**
- *Cannot automatically detect or correct configuration drift in the cluster*
- *Changes made outside Helmfile (manual edits) can go unnoticed*

**Operational, Not Declarative**
- *Focuses on executing deployments rather than maintaining a desired state*
- *Lacks self-healing capabilities compared to GitOps tools like Argo CD*

**Dependency Handling is Deployment-Time Only**
- ***`needs`** manages ordering during deployment*
- ***`Does not handle runtime service dependencies or failures`***

**Scalability Challenges in Larger Systems**
- *Managing multiple environments and complex configurations can become difficult*
- *Requires additional structure and discipline to stay maintainable*

**No Native UI or Observability**
- *No built-in dashboard to visualize application state or deployment status*
- ***`Debugging relies heavily on CLI and logs`***

### 💡 Key Takeaway

- *Helmfile is powerful for structured multi-service deployments, but for production-grade, continuously reconciled systems, a **`GitOps approach (e.g., Argo CD) is more suitable`**.*

------------------------------------------------------------------------

## ▶️ How to Run

### Prerequisites

**Infra**
1. ***`EC2 instance`** (minimum t2.midium)*
2. ***`EBS volume`** attached to EC2 and mounted for orders service*

    ![alt text](screenshots/screenshot17.png)

3. ***`Dynamodb`** for carts service with:*

    ![alt text](screenshots/screenshot33.png)

    ```
    table: Item   |  index: idx_global_cutomerId
       id: id     |    key: customerId
    ```

4. ***`AWS Sercrets Manager`** with secrets:*

    ![alt text](screenshots/screenshot04.png)

5. ***`IAM role for EC2`** with permissions:*

    ![alt text](screenshots/screenshot30.png)

    - dynamodb read and write access
    - secrets manager read access

    ![alt text](screenshots/screenshot37.png)

6. ***`Metadata response hop limit`** for EC2 set to: `3`*

    ![alt text](screenshots/screenshot32.png)

**Tools**
1. Docker installed and running
2. kubectl
3. helm
4. helmfile
5. Kind

**Steps**
1. Create KinD Cluster with these configs

    ```bash
    kind create cluster --name retail --config kind-config.yml
    ```

    ![alt text](screenshots/screenshot38.png)

2. Install eso-crd.yaml (**`kubectl create`**)

    ```bash
    kubectl create -f eso-crd.yaml
    ```

    ![alt text](screenshots/screenshot20.png)

3. Run helmfile

    ```
    helmfile -e kind apply
    ```

    ![alt text](screenshots/screenshot21.png)

    - ***`wait for 2-3 mins`** to create all the releases*

4. Port-forward to access UI

    ```
    kubectl port-forward svc/test-ui-service -n retail-app 8080:8080 --address=0.0.0.0
    ```
5. Open the port 8080 on EC2 instance
6. View the app

    ```
    <public-ip>:<8080>
    ```
    ![alt text](screenshots/screenshot23.png)

7. Check the serviceability of all micro-services in "/topology"

    ![alt text](screenshots/screenshot25.png)

8. Complete a buying process

    ![alt text](screenshots/screenshot24.png)

9. Add item to cart, and check at AWS console for persistence of items

    ![alt text](screenshots/screenshot39.png)
    

------------------------------------------------------------------------

## 🔭 What’s Next

Moving forward, this setup will be transitioned to ArgoCD:

1. *Add **`deployment via ArgoCD`** [(read here)](../kubernetes/)*
2. *Implement **`CI/CD`** pipeline*
3. *Add **`email notification`** system*
4. *IaC using **`Terraform`***
5. *Add monitoring (**`Prometheus + Grafana`**)*
6. *Full Automation via one command **`terraform apply`***

------------------------------------------------------------------------

## 💭 Final Thoughts

***This project reflects my transition from writing standalone Kubernetes manifests to designing structured, scalable, and production-oriented deployments using Helm and Helmfile.***

*Beyond implementation, it helped me develop a deeper understanding of:*

- ***How microservices interact in real-world systems***
- ***The difference between deployment-time and runtime concerns***
- ***The importance of debugging, naming, and system clarity in distributed environments***
- ***It also highlighted the limitations of traditional deployment approaches, which led me to explore GitOps-based workflows for better reliability and maintainability.***

**This project marks a step forward in building production-grade systems with clarity, confidence, and engineering discipline.**