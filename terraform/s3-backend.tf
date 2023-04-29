terraform {
  backend "s3" {
    profile = "olu"
    bucket  = "backend-926381888057"
    key     = "terraform.tfstate"
    region  = "us-east-1"
  }
}