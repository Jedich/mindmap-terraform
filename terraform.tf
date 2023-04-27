terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }
  
  required_version = ">= 1.1"

  backend "s3" {
    bucket         = "mindmap-go-tfstate"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "state_lock"
  }
}
