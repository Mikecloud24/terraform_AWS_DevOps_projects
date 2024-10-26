
Here’s a detailed step-by-step guide to deploy a 3-tier microservices application on an Azure Kubernetes Service (AKS) cluster using Azure DevOps to automate the process.

Prerequisites
Azure Subscription: Ensure you have an active Azure subscription.

Azure CLI: Install the Azure CLI.

Azure DevOps Account: Set up an Azure DevOps account.

Docker: Install Docker to build container images.

Kubernetes CLI (kubectl): Install kubectl to interact with your AKS cluster.


Step 1: Create an AKS Cluster

 1. Create Resource Group:
az group create --name myResourceGroup --location eastus

 2. Create AKS Cluster
az aks create --resource-group myResourceGroup --name myAKSCluster --node-count 3 --enable-addons monitoring --generate-ssh-keys

 3. Get AKS Credentials:
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster


Step 2: Set Up Azure Container Registry (ACR)

 1. Create ACR:
az acr create --resource-group myResourceGroup --name myACR --sku Basic

 2. Login to ACR:
az acr login --name myACR



NOTE: DEPLOY TO AKS

Step 3: Build and Push Docker Images

 1. Build Docker Images:

docker build -t myACR.azurecr.io/frontend:latest ./frontend
docker build -t myACR.azurecr.io/backend:latest ./backend

 2. Push Docker Images to ACR:

docker push myACR.azurecr.io/frontend:latest
docker push myACR.azurecr.io/backend:latest


NOTE: Apply the Kubernetes manifests using the following commands:

kubectl apply -f mongodb-deployment.yaml
kubectl apply -f mongodb-service.yaml

kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml

kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml




Step 4: Create Kubernetes Manifests
Create deployment and service YAML files for each tier (frontend, backend, database).

frontend-deployment.yaml:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: myACR.azurecr.io/frontend:latest
        ports:
        - containerPort: 80


frontend-service.yaml:

apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  selector:
    app: frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer



backend-deploynent.yaml:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: myACR.azurecr.io/backend:latest
        ports:
        - containerPort: 3000


backend-service.yaml:

apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  selector:
    app: backend
  ports:
    - protocol: TCP
      port: 3000
      targetPort: 3000



Database Service (MongoDB)

Create a mongodb-deployment.yaml file for MongoDB deployment:


apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongodb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
      - name: mongodb
        image: mongodb:4.4
        ports:
        - containerPort: 27017


create a mongodb-service.yaml file:

apiVersion: v1
kind: Service
metadata:
  name: mongo
spec:
  selector:
    app: mongo
  ports:
    - protocol: TCP
      port: 27017
      targetPort: 27017



Step 5: Set Up Azure DevOps Pipeline

1. Create a New Project in Azure DevOps.
2. Create Repositories for frontend, backend, and database code.
3. Create a Build Pipeline:
     .Navigate to Pipelines > Create Pipeline.
     .Select your repository and configure the pipeline using YAML.

----azure-pipelines.yml:

trigger:
- main

pool:
  Image: 'default'

steps:
- task: Docker@2
  inputs:
    containerRegistry: 'myACR'
    repository: 'myACR.azurecr.io/frontend'
    command: 'buildAndPush'
    Dockerfile: '**/frontend/Dockerfile'
    tags: 'latest'

- task: Docker@2
  inputs:
    containerRegistry: 'myACR'
    repository: 'myACR.azurecr.io/backend'
    command: 'buildAndPush'
    Dockerfile: '**/backend/Dockerfile'
    tags: 'latest'




4.Create a Release Pipeline:
    .Navigate to Pipelines > Releases > New pipeline.
    .Add an artifact from the build pipeline.
    .Add a stage to deploy to AKS.

Deploy to AKS:

. Add a task to deploy using kubectl:

- task: Kubernetes@1
  inputs:
    connectionType: 'Azure Resource Manager'
    azureSubscription: 'your-azure-subscription'
    azureResourceGroup: 'myResourceGroup'
    kubernetesCluster: 'myAKSCluster'
    namespace: 'default'
    command: 'apply'
    useConfigurationFile: true
    configuration: '$(System.DefaultWorkingDirectory)/_your-build-pipeline-name/drop/*.yaml'


Step 6: Deploy and Monitor

Trigger the Pipeline: Commit code to the repository to trigger the build and release pipelines.

Monitor Deployment: Use Azure Monitor and Azure DevOps to monitor the deployment and application performance



1. Frontend Service (React) JavaScript


//frontend/src/App.js
import React from 'react';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>Welcome to the 3-Tier Microservices Application</h1>
      </header>
    </div>
  );
}

export default App;





2. Backend Service (Node.js/Express) javaScript


// backend/server.js
const express = require('express');
const app = express();
const port = 3000;

app.get('/api', (req, res) => {
  res.send('Hello from the backend!');
});

app.listen(port, () => {
  console.log(`Backend service listening at http://localhost:${port}`);
});
