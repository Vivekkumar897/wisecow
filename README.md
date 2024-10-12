Dockerization
Clone the repository git clone https://github.com/nyrahul/wisecow

Write Dockerfile:

# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME Wisecow

# Run app.py when the container launches
CMD ["python", "app.py"]
Build the Docker image:

docker build -t wisecow-app .
Test the Docker image locally:

docker run -p 8080:80 wisecow-app
Kubernetes Deployment
Create Deployment YAML (wisecow-deployment.yaml):
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wisecow-deployment
  labels:
    app: wisecow
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wisecow
  template:
    metadata:
      labels:
        app: wisecow
    spec:
      containers:
      - name: wisecow
        image: <your-container-registry>/wisecow-app:latest
        ports:
        - containerPort: 80
Create Service YAML (wisecow-service.yaml):
apiVersion: v1
kind: Service
metadata:
  name: wisecow-service
spec:
  selector:
    app: wisecow
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: LoadBalancer
Apply the manifest files:
kubectl apply -f wisecow-deployment.yaml
kubectl apply -f wisecow-service.yaml
Continuous Integration and Deployment (CI/CD)
GitHub Actions Workflow:
Create .github/workflows/ci-cd.yml:
name: CI/CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v2
    - name: Login to Container Registry
      uses: docker/login-action@v1
      with:
        username: ${{ secrets.REGISTRY_USERNAME }}
        password: ${{ secrets.REGISTRY_PASSWORD }}
    - name: Build Docker image
      run: docker build -t <your-container-registry>/wisecow-app:latest .
    - name: Push Docker image
      run: docker push <your-container-registry>/wisecow-app:latest
    - name: Deploy to Kubernetes
      run: kubectl apply -f wisecow-deployment.yaml
      env:
        KUBECONFIG: ${{ secrets.KUBE_CONFIG_DATA }}
Configure Docker and Kubernetes secrets in the GitHub repository settings.
TLS Implementation
Generate TLS Certificates:
Use tools like Let's Encrypt to generate certificates.
Configure TLS in Kubernetes Ingress:
Create an Ingress resource for TLS termination.
Update wisecow-service.yaml to use NodePort or ClusterIP type.
Configure Ingress rules for secure communication.



### Problem StateMent N0.2 Solution

                                                                         solution for two objectives using Bash scripts.

                                                                     Objective 1: System Health Monitoring Script (Bash)


#!/bin/bash

# Thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=90

LOG_FILE="/var/log/sys_health.log"

# Get current usage stats
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
memory_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2 * 100.0}')
disk_usage=$(df / | grep / | awk '{print $5}' | sed 's/%//g')

# Log function
log_alert() {
    echo "$(date): $1" | tee -a $LOG_FILE
}

# Check CPU usage
if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
    log_alert "High CPU usage: ${cpu_usage}%"
fi

# Check memory usage
if (( $(echo "$memory_usage > $MEMORY_THRESHOLD" | bc -l) )); then
    log_alert "High Memory usage: ${memory_usage}%"
fi

# Check disk usage
if (( $disk_usage > $DISK_THRESHOLD )); then
    log_alert "Low disk space: ${disk_usage}% used"
fi

# Check number of running processes
process_count=$(ps aux | wc -l)
log_alert "Running processes: $process_count"

echo "System health check completed."


                                                                            Objective 2: Application Health Checker (Bash)
                                                                            
                                                                       

# Application URL
URL="http://example.com"

# Function to check the HTTP status code
check_app_status() {
    status_code=$(curl -o /dev/null -s -w "%{http_code}\n" $URL)
    
    if [ $status_code -eq 200 ]; then
        echo "$(date): Application is UP. Status code: $status_code"
    else
        echo "$(date): Application is DOWN or not responding. Status code: $status_code"
    fi
}

# Run the health check
check_app_status

## Expected Artifacts
1. Github repo containing the app with corresponding dockerfile, k8s manifest, any other artifacts needed.
2. Github repo with corresponding github action.
3. Github repo should be kept private and the access should be enabled for following github IDs: nyrahul, SujithKasireddy
