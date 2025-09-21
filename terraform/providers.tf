# Required Terraform version and AWS provider configuration
terraform {
  required_version = ">1.11.0"
  required_providers {
    aws = {
       source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "di-terraform-states-767397903600"
    key = "aws-emr-with-apache-flink/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
  }
}


# AWS Provider  
provider "aws" {
  region = var.aws_region
}
