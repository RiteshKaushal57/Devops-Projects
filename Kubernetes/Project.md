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
ritesh@LAPTOP-BEPRR95P:~/three-tier-app/Devops-Projects/Kubernetes/three-tier-app/k8$ kubectl get all -n three-tier-app
NAME                           READY   STATUS    RESTARTS   AGE
pod/backend-6cd9fb56b-fvfcw    1/1     Running   0          35m
pod/frontend-956bcfbff-xlptr   1/1     Running   0          35m
pod/mongo-5c748dfffc-56724     1/1     Running   0          36m

NAME               TYPE           CLUSTER-IP       EXTERNAL-IP                                                            PORT(S)        AGE
service/backend    ClusterIP      10.100.68.252    <none>                                                                 5000/TCP       36m
service/frontend   LoadBalancer   10.100.143.144   a2adab12dad20453592dddfe7235f2d8-7149985.us-east-1.elb.amazonaws.com   80:32548/TCP   35m
service/mongo      ClusterIP      10.100.56.63     <none>                                                                 27017/TCP      36m

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/backend    1/1     1            1           36m
deployment.apps/frontend   1/1     1            1           35m
deployment.apps/mongo      1/1     1            1           36m

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/backend-6cd9fb56b    1         1         1       36m
replicaset.apps/frontend-956bcfbff   1         1         1       35m
replicaset.apps/mongo-5c748dfffc     1         1         1       36m
