pipeline {
  agent any
  
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    
    stage('Build Backend Image') {
      environment {
        ECR_REGISTRY = '926381888057.dkr.ecr.us-east-1.amazonaws.com'
        ECR_REPOSITORY = 'backend'
        IMAGE_TAG = "latest"
      }
      
      steps {
        sh "docker build -t \${ECR_REGISTRY}/\${ECR_REPOSITORY}:\${IMAGE_TAG} backend/"
      }
    }
    
    stage('Push Backend Image') {
      environment {
        AWS_REGION = 'us-east-1'
        ECR_REGISTRY = '926381888057.dkr.ecr.us-east-1.amazonaws.com'
        ECR_REPOSITORY = 'backend'
        IMAGE_TAG = "latest"
      }
      
      steps {
        withCredentials([awsEcr(credentialsId: 'aws-cred', region: AWS_REGION)]) {
          sh "aws ecr get-login-password --region \${AWS_REGION} | docker login --username AWS --password-stdin \${ECR_REGISTRY}"
          sh "docker push \${ECR_REGISTRY}/\${ECR_REPOSITORY}:\${IMAGE_TAG}"
        }
      }
    }
    
    stage('Build Frontend Image') {
      environment {
        ECR_REGISTRY = '926381888057.dkr.ecr.us-east-1.amazonaws.com'
        ECR_REPOSITORY = 'frontend'
        IMAGE_TAG = "latest"
      }
      
      steps {
        sh "docker build -t \${ECR_REGISTRY}/\${ECR_REPOSITORY}:\${IMAGE_TAG} frontend/"
      }
    }
    
    stage('Push Frontend Image') {
      environment {
        AWS_REGION = 'us-east-1'
        ECR_REGISTRY = '926381888057.dkr.ecr.us-east-1.amazonaws.com'
        ECR_REPOSITORY = 'frontend'
        IMAGE_TAG = "latest"
      }
      
      steps {
        withCredentials([awsEcr(credentialsId: 'aws-cred', region: AWS_REGION)]) {
          sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
          sh "docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
        }
      }
    }
    
    stage('Deploy VPC and ECS Cluster') {
      withCredentials([awsEcr(credentialsId: 'aws-cred', region: AWS_REGION)]) {
        sh "terraform  -chdir=terraform apply -target=module.vpc -target=module.ecs"

      }
    }

    stage('Deploy Backend Service') {
      withCredentials([awsEcr(credentialsId: 'aws-cred', region: AWS_REGION)]) {
        sh "terraform  -chdir=terraform apply -target=module.backend_task_definition"
      }
      
    }

    stage('Deploy Fronted Service') {
      withCredentials([awsEcr(credentialsId: 'aws-cred', region: AWS_REGION)]) {
        sh "terraform  -chdir=terraform apply -target=module.frontend_task_definition"
      }
      
    }
  }
}