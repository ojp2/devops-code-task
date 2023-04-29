module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = var.vpc_name
  cidr   = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 3.1.0"

  name               = format("%v-%v", var.project_name, var.environment)
  container_insights = true

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE"
      weight            = "1"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}


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