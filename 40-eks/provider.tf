terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.95.0"
    }
  }
  backend "s3" {
    bucket         = "rushika-remote-state-dev"
    key            = "expense-eks" # you should have unique keys with in the bucket, same key should not be used in other repo
    region         = "us-east-1"
    dynamodb_table = "rushika-remote-state-dev"
 }

}
    

provider "aws" {
  # Configuration options
  region = "us-east-1"
}