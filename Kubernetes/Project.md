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