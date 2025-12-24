## Step 1: Create a dedicated folder in your Git repo
## Step 2: Create values.yaml
## Step 3: Add content to the values.yaml
```
replicaCount: 2

service:
  type: ClusterIP
  port: 80

image:
  registry: docker.io
  repository: bitnami/nginx
  tag: latest
```
