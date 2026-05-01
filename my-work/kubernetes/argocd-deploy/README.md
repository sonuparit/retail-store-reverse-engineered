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