# Overview
This repository contains a code Frontend and Backend and also there respective terraform code

## 📋 Objective
Deploy the frontend and backend to somewhere publicly accessible over the internet, using docker, terraform using jenkins pipeline


# Setup your environment

## ECR
---
ECR repository needs to be deployed, *backend* and *frontend*
  
## Jenkins 
---
1.  Jenkins is deployed on a  EC2 istance and also configured Route53 rules for Jenkins ``` http://jenkins.hicloudsolution.com:8080/job/ecs_deploy_job/```

2. Once Jenkins is installed. Plugins needs to be installed. Inside Manage Jenkins
    1. Git
    2. AWS
    3. Terraform

3.  Jenkinsfile is defined at the root of the repository. In which I have defined Stages for building and pushing Docker image to ECR. And then deploying the terraform code for VPC, ECS cluster and ECS Services
  
## Terraform
---
The repository contains the Terraform code for VPC, ECS Cluster and ECS Service. The code of terraform is inside the ``` terraform/``` folder

Jenkinsfile contain all the command to deploy the terraform code

## 📰 Usage
---

**How to create backendcservice:**

```
module "backend_task_definition" {
  source = "./backend"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  ecs_cluster_id    = module.ecs.ecs_cluster_arn
  backend_image_uri = var.backend_image_uri
  public_subnets    = module.vpc.public_subnets
  certificate_arn   = var.certificate_arn
  aws_region        = var.aws_region
}
```

**How to create frontend service:**

```
module "frontend_task_definition" {
  source = "./frontend"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  ecs_cluster_id     = module.ecs.ecs_cluster_arn
  frontend_image_uri = var.frontend_image_uri
  public_subnets     = module.vpc.public_subnets
  certificate_arn    = var.certificate_arn
  aws_region         = var.aws_region
}
```

## Deploy Terrform code from localhost

## Requirements
---

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Prerequisites
---

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)


## 📌 Deploy terraform command
---

1. Initialize the terraform code

```
terraform init -chdir=terraform
```

2. Deploy VPC and ECS Cluster Terraform code

```
terraform -chdir=terraform apply -auto-approve -target=module.vpc -target=module.ecs
```

3. Deploy Backend Service 

```
terraform -chdir=terraform apply -auto-approve -target=module.backend_task_definition
```

4. Deploy Frontend Service

```
terraform -chdir=terraform apply -auto-approve -target=module.frontend_task_definition
```

## 🌎 Useful links:
---

**Frontend_url:** 
  https://frontend.hicloudsolution.com/


**Backend_url:**
  https://backend.hicloudsolution.com/


## 📈 Diagram
---

No diagrams for this task.
