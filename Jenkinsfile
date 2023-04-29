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
        withAWS(credentials: "aws-cred") {
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
        withAWS(credentials: "aws-cred") {
          sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
          sh "docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
        }
      }
    }
    
    stage('Deploy VPC, ECS Cluster and Services') {
      steps {
        withAWS(credentials: "aws-cred") {
          sh """
            terraform init
            echo "Deploying VPC and ECS cluster"
            terraform  -chdir=terraform apply -auto-approve -target=module.vpc -target=module.ecs

            echo "Deploying ECS Service Backend"
            terraform  -chdir=terraform apply -auto-approve -target=module.backend_task_definition

            echo "Deploying ECS Service Frontend"
            terraform  -chdir=terraform apply -auto-approve -target=module.frontend_task_definition

          """
        }
      }
      
    }
  }
}
