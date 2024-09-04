terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.62.0"
      #version = var.tfversion
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}