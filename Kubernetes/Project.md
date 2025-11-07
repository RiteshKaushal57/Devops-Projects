
# 🧩 PROJECT: 3-Tier E-Commerce App on **AWS EKS (Fargate)** with **Jenkins CI/CD**, **ECR**, **Helm**, and **SonarQube**

---

## 🌐 **1. Project Overview**

You’ll build and deploy a full-stack **E-Commerce Web App** consisting of 3 tiers:

| Tier         | Technology        | Description                                                        |
| ------------ | ----------------- | ------------------------------------------------------------------ |
| **Frontend** | React + Nginx     | Built React app served via Nginx container                         |
| **Backend**  | Node.js + Express | REST API for users/products/orders                                 |
| **Database** | MongoDB Atlas     | Managed MongoDB (since Fargate doesn’t support persistent DB pods) |

All containers will be deployed on **AWS EKS (Fargate)** using **Helm**,
and automated via **Jenkins CI/CD pipeline** that also includes **SonarQube code quality analysis**.

---

## ⚙️ **2. Complete Tech Stack**

| Category         | Tool / Service             | Purpose                                               |
| ---------------- | -------------------------- | ----------------------------------------------------- |
| Cloud            | **AWS**                    | Hosting (EKS, ECR, IAM, CloudWatch)                   |
| Compute          | **AWS EKS Fargate**        | Serverless Kubernetes for app                         |
| Containerization | **Docker**                 | Build images for all tiers                            |
| Registry         | **AWS ECR**                | Store Docker images                                   |
| Deployment       | **Helm**                   | Simplify Kubernetes deployments                       |
| CI/CD            | **Jenkins**                | Automate build → test → deploy                        |
| Code Quality     | **SonarQube**              | Static code analysis integrated into Jenkins pipeline |
| Database         | **MongoDB Atlas**          | Cloud-hosted MongoDB                                  |
| Networking       | **Ingress + LoadBalancer** | External access to frontend                           |
| Version Control  | **GitHub**                 | Source code + pipeline trigger                        |

---

## 🏗️ **3. High-Level Architecture Diagram**

```
                     ┌────────────────────────┐
                     │        Developer        │
                     │ (Push code to GitHub)   │
                     └────────────┬────────────┘
                                  │
                        GitHub Webhook Trigger
                                  │
                     ┌────────────▼────────────┐
                     │        Jenkins          │
                     │ CI/CD Pipeline          │
                     ├──────────┬──────────────┤
                     │          │               │
          ┌──────────▼──┐  ┌────▼─────┐   ┌────▼────┐
          │ SonarQube   │  │ Docker   │   │ AWS ECR │
          │ (Code Scan) │  │ Build    │   │ Push    │
          └─────────────┘  └────┬─────┘   └────┬────┘
                                 │              │
                      ┌──────────▼──────────────▼──────────┐
                      │         AWS EKS (Fargate)          │
                      │                                    │
                      │ + Frontend Pod (React + Nginx)     │
                      │ + Backend Pod (Node.js API)        │
                      │ + MongoDB Atlas (external)         │
                      └────────────────────────────────────┘
```

---

## 🪜 **4. Step-by-Step Roadmap**

---

### **Phase 1 – Application Development (Local Setup)**

**Goal:** Build and test all 3 tiers locally before containerization.

1. **Frontend (React + Nginx):**

   * Create a simple React app with pages like “Home”, “Products”, and “Cart”.
   * After build (`npm run build`), Nginx will serve static files.

2. **Backend (Node.js + Express):**

   * Build API routes:
     `/api/products`, `/api/users`, `/api/orders`
   * Connect backend to MongoDB Atlas using Mongoose.
   * Test locally with Postman.

3. **Database:**

   * Use **MongoDB Atlas cluster** and whitelist your IP or EKS VPC CIDR.

---

### **Phase 2 – Containerization with Docker**

**Goal:** Run the full app locally as containers.

1. Create **Dockerfiles**:

   * `frontend/Dockerfile`
   * `backend/Dockerfile`
2. Test locally:

   ```bash
   docker build -t frontend:latest ./frontend
   docker build -t backend:latest ./backend
   docker run -p 3000:80 frontend
   docker run -p 5000:5000 backend
   ```

---

### **Phase 3 – AWS Setup**

**Goal:** Set up all cloud services required for deployment.

1. **ECR:**

   * Create 2 repositories (`frontend`, `backend`)
   * Login and push Docker images

     ```bash
     aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin <ECR_URL>
     docker tag backend:latest <ECR_URL>/backend:latest
     docker push <ECR_URL>/backend:latest
     ```
2. **EKS Cluster (Fargate-based):**

   * Create cluster:

     ```bash
     eksctl create cluster --name ecommerce-cluster --region ap-south-1 --fargate
     ```
   * Create namespace for your app:

     ```bash
     kubectl create namespace ecommerce-app
     ```
   * Create Fargate profile:

     ```bash
     eksctl create fargateprofile \
       --cluster ecommerce-cluster \
       --region ap-south-1 \
       --name ecommerce-fargate \
       --namespace ecommerce-app
     ```

---

### **Phase 4 – Kubernetes Deployment (with Helm)**

**Goal:** Deploy your containers using Helm on Fargate.

1. Folder structure:

   ```
   helm/
     ├── Chart.yaml
     ├── values.yaml
     ├── templates/
           ├── frontend-deployment.yaml
           ├── backend-deployment.yaml
           ├── services.yaml
           ├── ingress.yaml
   ```

2. Add ConfigMaps & Secrets:

   * Store environment variables (DB URL, API endpoints).

3. Deploy with Helm:

   ```bash
   helm install ecommerce ./helm --namespace ecommerce-app
   ```

4. Verify:

   ```bash
   kubectl get pods -n ecommerce-app
   kubectl get svc -n ecommerce-app
   ```

---

### **Phase 5 – Jenkins CI/CD Pipeline (with SonarQube)**

**Goal:** Automate everything — from build to deployment with code analysis.

#### Jenkins Pipeline Flow:

1. Checkout code from GitHub
2. Run SonarQube code quality scan
3. Build Docker images
4. Push to ECR
5. Deploy to EKS via Helm

#### Jenkinsfile:

```groovy
pipeline {
    agent any

    environment {
        ECR_REGISTRY = "<your_ecr_url>"
        REGION = "ap-south-1"
        SONAR_HOST_URL = "http://<sonarqube-url>"
        SONAR_TOKEN = credentials('sonarqube-token')
        APP_NAME = "ecommerce"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/ritesh/ecommerce-k8s.git'
            }
        }

        stage('Code Quality - SonarQube') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'sonar-scanner -Dsonar.projectKey=ecommerce -Dsonar.sources=./backend'
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                sh 'docker build -t $ECR_REGISTRY/$APP_NAME-frontend:latest ./frontend'
                sh 'docker build -t $ECR_REGISTRY/$APP_NAME-backend:latest ./backend'
            }
        }

        stage('Push to ECR') {
            steps {
                sh 'aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_REGISTRY'
                sh 'docker push $ECR_REGISTRY/$APP_NAME-frontend:latest'
                sh 'docker push $ECR_REGISTRY/$APP_NAME-backend:latest'
            }
        }

        stage('Deploy to EKS via Helm') {
            steps {
                sh 'helm upgrade --install ecommerce ./helm --namespace ecommerce-app'
            }
        }
    }
}
```

#### Jenkins Configuration:

* Add plugins: **SonarQube**, **Pipeline**, **Kubernetes CLI**, **AWS CLI**.
* Add credentials:

  * `aws-access-key` / `aws-secret-key`
  * `sonarqube-token`
  * `kubeconfig`

---

### **Phase 6 – SonarQube Setup**

**Goal:** Ensure code quality checks before every deployment.

1. Install SonarQube (locally or EC2).
2. Configure webhook between Jenkins and SonarQube.
3. Generate SonarQube token.
4. Add it to Jenkins credentials as `sonarqube-token`.

---

### **Phase 7 – Verification & Testing**

* Access frontend via LoadBalancer URL.
* Check backend API responses.
* Validate DB connection to MongoDB Atlas.
* Review SonarQube dashboard for code quality metrics.

---

## 🧾 **Final Deliverables**

| Deliverable             | Description                         |
| ----------------------- | ----------------------------------- |
| 🖥️ Source Code         | Frontend + Backend with Dockerfiles |
| ⚙️ Jenkinsfile          | Full CI/CD pipeline                 |
| 🐳 Docker Images        | Stored in AWS ECR                   |
| ☸️ Helm Chart           | Deploys app to Fargate              |
| 🧠 SonarQube Report     | Code quality scan                   |
| 📊 Architecture Diagram | Deployment flow                     |
| 📘 README.md            | Setup instructions + explanation    |

---

## 💼 **Resume Summary Example**

> **Serverless 3-Tier E-Commerce App on AWS EKS (Fargate)**
>
> * Built and deployed a 3-tier e-commerce application using **React**, **Node.js**, and **MongoDB Atlas** on **AWS EKS Fargate**.
> * Implemented an automated **CI/CD pipeline** using **Jenkins**, integrating **SonarQube** for static code analysis and **AWS ECR** for container image storage.
> * Used **Helm charts** for simplified Kubernetes deployments on Fargate and externalized configuration using **ConfigMaps** and **Secrets**.
> * Designed production-grade serverless architecture, improving deployment speed and scalability while ensuring high code quality.

---

Would you like me to now create a **visual architecture diagram** (showing Jenkins → SonarQube → ECR → EKS Fargate → MongoDB Atlas flow) so you can include it in your project documentation and portfolio?
