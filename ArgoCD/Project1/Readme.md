## Create the argocd namespace
We deploy Argo CD in a dedicated namespace to isolate GitOps control-plane components from application workloads, enabling safer operations, clearer RBAC boundaries, and easier maintenance.
```
kubectl create namespace argocd
```

## Install Argo CD using the official manifest
```
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
These pods will be created:  
**1. argocd-application-controller**   
**It is the brain of Argo CD.** It continously compares Git (desired state) ↔ Kubernetes (live state). Decides what needs to be created, updated, or deleted. Performs the actual sync operations.     

**2. argocd-applicationset-controller**    
**Mass application creator.** It automatically generates multiple Argo CD Applications.  
One template → 50 microservices → 50 Argo CD apps

**3. argocd-dex-server**   
**Authentication service.** It handles login & identity.

**4. argocd-notifications-controller**     
**Messenger.** It sends notifications when Sync succeeds or fails, App goes out of sync, Health degrades.

**5. argocd-redis-69bfd4888d**          
**Cache & state helper.** It caches application state, Stores comparison results, Improves performance.

**6. argocd-repo-server-878f94c**           
**Git reader & manifest generator.** IT pulls Git repositories.

**7. argocd-server**     
**UI & API.** It hosts: Web UI, REST API and accepts user actions: Sync, Rollback, App creation.

```
User → argocd-server (UI/API)
              ↓
       argocd-application-controller
              ↓
        Kubernetes API Server
              ↑
       argocd-repo-server ← Git
```
- Redis speeds this up
- Dex secures access
- Notifications inform humans

## Create your Argo CD Application
An Application in Argo CD is a configuration that tells Argo CD which application to deploy, where to get it from, and where to run it.

It connects a Git repository containing Kubernetes YAML files to a specific Kubernetes cluster and namespace, and instructs Argo CD on how and when to deploy and keep the application in sync.
## Access Argo CD UI
```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
**Open browser:**
```
https://localhost:8080
```
**Get initial admin password:**  
```
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d && echo
```