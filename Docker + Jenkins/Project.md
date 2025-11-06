# Deploying two tier web app using Docker + Jenkins

## Project Architecture
          +---------------------------+
          |        Developer          |
          |   Pushes Code to GitHub   |
          +-------------+-------------+
                        |
                (Webhook Trigger)
                        |
                +-------v--------+
                |    Jenkins     |
                |  CI/CD Server  |
                +-------+--------+
                        |
          +-------------+-------------+
          |                           |
   Build Docker Image          Build Docker Image
   for Frontend (UI)           for Backend (DB/API)
          |                           |
          +-------------+-------------+
                        |
                Push to Docker Hub
                        |
          +-------------+-------------+
                        |
                Deploy Containers
         (Frontend + Backend on same host)
                        |
                +-------v-------+
                |   Web Users   |
                +---------------+


## Step 1: Launch an EC2 instance and connect to it
```
ssh -i ~/.ssh/AWSKeyPair.pem ubuntu@54.226.255.101
```

## Step 2: Update System Packages
```
sudo apt update && sudo apt upgrade -y
```

## Step 3: Install Docker and Docker Compose
```
*Remove old versions (optional)*
sudo apt remove docker docker-engine docker.io containerd runc -y

*Install prerequisites*
sudo apt install -y ca-certificates curl gnupg lsb-release

*Add Docker’s official GPG key*
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

*Add the Docker repository*
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

*Update package index*
sudo apt update

*Install Docker Engine and CLI*
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

**Verify it**
```
docker --version
docker compose version
```

## Step 4: Install & Run Jenkins using Docker

**Step 4.1 — Pull Jenkins image**
```
sudo docker pull jenkins/jenkins:lts
```

**Step 4.2 — Create Jenkins container**
```
sudo docker run -d \
  --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

**What it does:**

- **-d →** Runs in detached mode (in background)

- **--name jenkins →** Names the container jenkins

- **- -p 8080:8080 →** Jenkins web UI accessible via your EC2 Public IP on port 8080
(Example: http://<your-ec2-ip>:8080)

- **-p 50000:50000 →** Used for Jenkins agents (for later use)

- **-v jenkins_home:/var/jenkins_home →** Persists data even if the container restarts

- **-v /var/run/docker.sock:/var/run/docker.sock →** This allows Jenkins to use the host’s Docker engine.

**Step 4.3 — Get Jenkins initial password**
```
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

**Step 4.4 — Access Jenkins from browser**
```
http://<your-ec2-public-ip>:8080
```

## Step 5: Install Docker CLI inside Jenkins container

**Step 5.1 — Access Jenkins container shell**
```
sudo docker exec -u root -it jenkins bash
```

**Step 5.2 — Update package index**
```
apt update
```

**Step 5.3 — Install Docker CLI**
```
apt install -y docker.io
```
*Verify installation*
```
docker --version
```

**Step 5.4 — Access Jenkins from browser**
```
http://<your-ec2-public-ip>:8080
```
66b6c47ad470453e9279068914425430


## Step 6: Build the Two-Tier Web App Structure



## Step 7: Update System Packages