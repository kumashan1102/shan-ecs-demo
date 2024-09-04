terraform {
  backend "s3" {
    bucket = "shan-terraform-backend-bucket"
    key    = "shanpoc/dev/tfstate"
    region = "us-east-1"
  }
}