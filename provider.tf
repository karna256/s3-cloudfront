terraform {

  backend "local" {
    path = "./localstate.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=5.43.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Creator = "Ankit"
      Name    = "Ankit-default"
      Project = "Training"
    }
  }
}