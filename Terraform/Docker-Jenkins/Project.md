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

## Step 3:Install Git, Docker, and Docker Compose
```
sudo apt install git docker.io docker-compose-v2 -y
```

## Step 4: Start and Enable Docker

```
sudo systemctl start docker
sudo systemctl enable docker
```

## Step 5: Add User to Docker Group (to run docker without sudo)

```
sudo usermod -aG docker $USER
```

## Step 6: Install Java (OpenJDK 17)
```
sudo apt install openjdk-17-jdk -y
```

## Step 7: Add Jenkins Repository and Install
```
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install -y openjdk-17-jdk
sudo apt install -y jenkins
```

## Step 8: Start and Enable Jenkins Service
```
sudo systemctl start jenkins
sudo systemctl enable jenkins
```
05835ca2fe094a5aa53b08abf0c5fd5b

## Step 7: Jenkins Setup
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
## Step 7: Grant Jenkins Docker Permissions
```
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```