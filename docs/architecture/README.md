# 🏗️ App Architecture (Original):

![alt text](screenshots/architecture.png)

## 🧠 What I discovered:

### 🏗️ Architecture Understanding:
This application is a microservices-based demo system built to showcase real-world Kubernetes patterns and behaviors.

**Key observations:**
- The application simulates database usage but does not depend on actual persistent storage
- Data is written to in-memory storage (tmpfs), making all services effectively stateless
- No Persistent Volumes (PV) or Persistent Volume Claims (PVC) are used

### 💡 Why this design?

**This is intentional and serves a clear purpose:**
- Simplifies deployment
- Eliminates state management complexity
- Keeps the focus on service interaction and orchestration within Kubernetes

### 🔐 Security Considerations

**The application also follows strong container security practices:**
- Read-only root filesystem
- Restricted writable paths (e.g., /tmp)
- Reduced container attack surface

    > **This is not a limitation**\
    > **This is intentional architecture design**

### 📌 Conclusion:

The application is designed to be stateless for demonstration purposes. It prioritizes portability, simplicity, and Kubernetes behavior over data durability.

---

![Note] This app is not my work - I'm just reverse engineering it to better understand microservices, kubernetes and cloud