variable "aws_region" {
  description = "AWS region to deploy infrastructure to"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment to deploy resources to"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "my-project"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "my-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones to use for the VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnets" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

variable "backend_image_uri" {
  description = "URI of the backend Docker image to use"
  type        = string
  default     = "926381888057.dkr.ecr.us-east-1.amazonaws.com/backend:latest"
}

variable "frontend_image_uri" {
  description = "URI of the frontend Docker image to use"
  type        = string
  default     = "926381888057.dkr.ecr.us-east-1.amazonaws.com/frontend:latest"
}

variable "certificate_arn" {
  description = "ACM certificate ARN"
  type        = string
  default     = "arn:aws:acm:us-east-1:926381888057:certificate/dbbc7353-4c1f-4aa1-bed9-be1c67f39cc2"
}
