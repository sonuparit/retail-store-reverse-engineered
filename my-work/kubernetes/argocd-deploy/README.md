# 🚀 ArgoCD-Based Deployment on K8s
work under progress...

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

work under progress...


My implementation:

I separated platform and application layers and enforced deployment order using sync waves to ensure CRDs and secret providers are available before application sync.

Solved three major hurdles that often trip up platform engineers:

1. The Metadata Size Limit: By using ServerSideApply=true, you bypassed the 262KB annotation limit that causes large CRDs to fail during a standard kubectl apply.

2. The Race Condition: By using Sync Waves (assigning -1 to the ESO Application and 5 to the ClusterSecretStore), you ensured the controller and its webhooks were ready before the store tried to validate itself.

3. The Validation Loop: By adding SkipDryRunOnMissingResource=true to your Root App, you allowed the parent to ignore the "Unknown Resource" errors during the initial sync of the ClusterSecretStore.  

## 🚧 Challenges and Solutions

### 1. ArgoCD Not Detecting Helm Chart (`Chart.yaml` not found)

**Problem:**
ArgoCD failed with an error indicating that `Chart.yaml` was missing, even though charts existed inside a subdirectory.

**Root Cause:**
ArgoCD does **not search recursively** for Helm charts. It expects `Chart.yaml` to be present **exactly at the path defined in `spec.source.path`**.

**Solution:**
Instead of pointing to a parent directory, dynamically point to each chart using the `chartPath` variable.

```yaml
path: my-work/kubernetes/argocd-deploy/apps/{{chartPath}}
```

**Key Learning:**

> ArgoCD behaves like: `cd <path> && helm template .` — the chart must exist exactly at that location.

---

### 2. Incorrect Relative Path for Helm `valueFiles`

**Problem:**
Helm values file was not found during ArgoCD sync.

**Root Cause:**
`valueFiles` paths are resolved **relative to the chart directory**, not the repo root.

**Solution:**
Adjusted the relative path based on directory depth:

```yaml
helm:
  valueFiles:
    - ../../../envs/{{env}}/{{name}}.yaml
```

**Key Learning:**

> Always calculate paths from the chart directory, not from the repository root.

---

### 3. Helm Processing `.bak` Files in `templates/`

**Problem:**
A backup file (`hook-job.yaml.bak`) inside the `templates/` directory was still being applied.

**Root Cause:**
Helm processes **all files inside `templates/`**, regardless of file extension.

**Solution:**
Move unused or backup files outside the `templates/` directory or prefix with `_`:

```plaintext
templates/
  external-secret.yaml

_disabled/
  hook-job.yaml.bak
```

**Key Learning:**

> Helm ignores location, not file extensions — everything inside `templates/` is rendered.

---

### 4. Helm Template Code Executed Inside YAML Comments

**Problem:**
A commented line still caused a Helm template error:

```yaml
# name: {{ include "orders.secretName" . }}
```

**Error:**

```
no template "orders.secretName" associated with template "gotpl"
```

**Root Cause:**
Helm processes `{{ }}` expressions **before YAML parsing**, so YAML comments do not prevent execution.

**Solution:**
Use Helm-style comments:

```yaml
{{/* name: {{ include "orders.secretName" . }} */}}
```

**Key Learning:**

> YAML comments (`#`) do not disable Helm templates — use `{{/* */}}` instead.

---

### 5. Namespace Confusion in ArgoCD

**Problem:**
Confusion between multiple `namespace` fields in the ApplicationSet.

**Root Cause:**
Two different namespaces serve different purposes:

* `metadata.namespace` → where ArgoCD stores the Application
* `spec.destination.namespace` → where Kubernetes deploys the app

**Solution:**
Ensure all deployments use:

```yaml
destination:
  namespace: '{{namespace}}'
```

**Key Learning:**

> ArgoCD’s namespace ≠ Application namespace.

---

### 6. External Secrets Not Ready Before App Deployment

**Problem:**
Applications failed because Kubernetes Secrets were not yet created by External Secrets Operator.

**Root Cause:**
ArgoCD sync waves ensure **order**, but not **readiness**.

**Solution:**
Implemented a Helm hook Job to wait until the `ExternalSecret` becomes ready:

```yaml
until kubectl get externalsecret {{ .Values.externalSecret.name }} \
  -n {{ .Release.Namespace }} \
  -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' \
  | grep True; do
  sleep 5
done
```

**Key Learning:**

> Sync order ≠ resource readiness — always handle async dependencies explicitly.

---

### 7. Verifying Secrets Correctly (Beyond Existence)

**Problem:**
Needed to confirm secrets were correctly fetched from AWS Secrets Manager.

**Solution:**
Validated at multiple levels:

* Check ExternalSecret status:

  ```bash
  kubectl get externalsecret -n <namespace>
  ```
* Decode secret values:

  ```bash
  kubectl get secret <name> -o jsonpath='{.data.key}' | base64 -d
  ```
* Test inside a running Pod using `envFrom`

**Key Learning:**

> Always verify secrets end-to-end — creation alone is not enough.

---

## 🧠 Overall Takeaways

* ArgoCD enforces **desired state**, not execution logic
* Helm rendering happens **before YAML parsing**
* File placement and path resolution are **critical in GitOps**
* External systems (like AWS Secrets Manager) introduce **asynchronous behavior**
* Proper debugging requires validating **each layer independently**

---


Headline: Stop fighting Kubernetes’ eventual consistency! 🛑 🏗️

We’ve all been there: You’re deploying an app that depends on a Secret. But that Secret is managed by External Secrets Operator (ESO).

The race condition begins:

The App starts.

The Secret doesn't exist yet (ESO is still reconciling).

The App enters CrashLoopBackOff.

How do you fix the "Dependency Gap"? I’ve been looking at 4 ways to handle this in a GitOps/ArgoCD world:

1. The "Scripted" Way (Helm Hooks + RBAC) 🛠️
Using a Helm pre-install Job to run a "check" script.

The Catch: It’s complex. You need extra ServiceAccounts and Roles just to "wait." It feels like fighting the cluster instead of using it.

2. The "GitOps" Way (ArgoCD Health Checks) 🔄
Teaching ArgoCD what a "Healthy" ExternalSecret looks like via Lua scripts in the argocd-cm ConfigMap. Combine this with Sync Waves.

The Catch: Great for visibility in the UI, but requires admin access to the ArgoCD installation.

3. The "Bulletproof" Way (Init Containers) 🛡️
Adding a tiny busybox initContainer that loops until a secret file is mounted.

The Catch: Zero RBAC required! It ensures the app only starts when the data is physically there. Simple and effective.

4. The "Native" Way (Reconciliation) 🧘
Doing... nothing. Let the Pod crash and restart. Kubernetes is self-healing; eventually, the secret appears, and the app stabilizes.

The Catch: It looks "messy" in the logs, but it’s exactly how K8s was designed to work.

The Verdict?
If you want a clean UI, go ArgoCD Health Checks.
If you want a robust, portable app, go Init Containers.
If you want to keep it simple, embrace the CrashLoop.
If you want a strong dependency go with helm hook job - but be careful


Deployed **multi-environment Kubernetes (dev + stage)** on a single kind cluster… with persistent storage that actually survives cluster recreation 🚀

Most tutorials stop at “it works”.
I wanted to understand what happens when the cluster dies.

So I built this 👇

---

🔹 **Setup**

* kind cluster running on EC2
* External EBS volume mounted on the host
* Mounted inside kind nodes using `extraMounts`
* StatefulSet (PostgreSQL) with PVC
* Custom “dynamic provisioning” using hostPath

---

🔹 **Key challenge**

Running multiple environments with persistence:

* dev
* stage
* prod

All on the **same cluster**, same disk.

---

🔹 **Solution**

Instead of relying only on defaults, I designed **per-environment volume isolation**:

```
/mnt/postgre-data/
  ├── orders-dev
  ├── orders-stage
  └── orders-prod
```

Each environment:

* Own PV
* Own PVC
* Own directory on EBS

---

🔹 **Important lessons**

👉 Storage isolation must happen at **volume level**, not inside the app (PGDATA)
👉 Kubernetes doesn’t manage your data — it only mounts it
👉 Cluster lifecycle ≠ data lifecycle

---

🔹 **Result**

* Multiple environments running simultaneously ✅
* No storage conflicts ✅
* Data persists even after cluster teardown ✅

---

🔹 **Why this matters**

This setup helped me truly understand how persistence works before moving to cloud-native setups like EKS + EBS CSI.

It’s basically:

👉 Manual dynamic provisioning → stepping stone to real cloud storage

---

Curious how others handle multi-env persistence in local clusters?

Do you simulate cloud behavior locally, or jump straight to managed services?

Let’s discuss 👇

#Kubernetes #DevOps #GitOps #StatefulSets #CloudNative #ArgoCD #AWS #LearningInPublic
