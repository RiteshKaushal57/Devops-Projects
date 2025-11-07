Pull code form Github > Docker > ECR > Kubernetes > Ingress > Load Blanacer

## Step 1: Create EC2 instance and connect to it
```
 ssh -i ~/.ssh/AWSKeyPair.pem ubuntu@18.208.189.4
```

## Step 2: Update System Packages
```
sudo apt-get update
sudo apt install docker.io
sudo chown $USER /var/run/docker.sock
docker ps
```

## Step 3: Install AWS CLI
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin --update
aws configure
```

## Step 4: Create ECR and build and push images there

## Step 5: Install kubectl
```curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```

## Step 6: Install eksctl
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

## Step 7: Setup EKS Cluster
```
eksctl create cluster --name three-tier-cluster --region us-west-2 --node-type t2.medium --nodes-min 2 --nodes-max 2
aws eks update-kubeconfig --region us-west-2 --name three-tier-cluster
kubectl get nodes
```