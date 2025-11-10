## Phase 2: Setup EKS Cluster (with Fargate Support)
**Step 1: Create EKS Cluster**  
```
eksctl create cluster \
  --name three-tier-cluster \
  --region us-east-1 \
  --fargate
```

**Step 2: Create Fargate Profile**  
```
eksctl create fargateprofile \
  --cluster three-tier-cluster \
  --name three-tier-profile \
  --namespace three-tier-app
```

**Step 3: Create Kubernetes Namespace (matches Fargate profile)**
```
kubectl create namespace three-tier-app
```

**Step 4: Set Context to that Namespace**
```
kubectl config set-context --current --namespace=three-tier-app
```

**Step 4: Create Kubernetes Manifests (YAML files)**
three-tier-app/
├── k8s/
│   ├── mongo.yaml
│   ├── backend.yaml
│   ├── frontend.yaml
│   ├── ingress.yaml (optional, later for domain)

**Step 4: Deploy Each One**
```
kubectl apply -f k8s/mongo.yaml
kubectl apply -f k8s/backend.yaml
kubectl apply -f k8s/frontend.yaml
```
*check deployment status*  
```
kubectl get all -n three-tier-app
```
