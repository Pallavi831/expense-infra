terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
  backend "s3" {
    bucket         = "rushika-remote-state-dev"
    key            = "expense-vpc"
    region         = "us-east-1"
    dynamodb_table = "rushika-remote-state-dev"
    
 }

}
    

provider "aws" {
  # Configuration options
  region = "us-east-1"
}