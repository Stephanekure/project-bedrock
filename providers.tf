terraform {
  required_version = ">= 1.11.0"
  
  backend "s3" {
    bucket       = "bedrock-terraform-state-stephan-12345"
    key          = "prod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true 
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" 

  default_tags {
    tags = {
      Project = "tinyuka-2025-capstone"
    }
  }
}