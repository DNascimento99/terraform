terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Certifique-se de estar na versão mais recente
    }
  }
  required_version = ">= 1.3.0" # Atualize para a versão mais recente do Terraform
}

provider "aws" {
  region = "us-east-1"
}