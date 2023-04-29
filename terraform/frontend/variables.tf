variable "aws_region" {
  description = "AWS region to deploy infrastructure to"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment to deploy resources to"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "frontend_image_uri" {
  description = "URI of the frontend Docker image to use"
  type        = string
}

variable "memory" {
  description = "Required memory for the ECS task in Mib"
  type        = number
  default     = 1024
}

variable "cpu" {
  description = "Required CPU units for the ECS tasks"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "ECS service desired count"
  type        = number
  default     = 2
}

variable "public_subnets" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "ecs_cluster_id" {
  description = "ecs cluster id"
  type        = string
}

variable "health_check_grace_period_seconds" {
  description = "health check grace period seconds"
  type        = string
  default     = 60
}

variable "certificate_arn" {
  description = "ACM certificate ARN"
  type        = string
}

variable "domain_name" {
  description = "Domain Name"
  type        = string
  default     = "hicloudsolution.com"
}

variable "frontend_domain" {
  description = "backend domain name"
  type        = string
  default     = "frontend.hicloudsolution.com"
}

variable "retention_in_days" {
  description = "Cloudwatch logs retention period in days"
  type        = number
  default     = 180
}
