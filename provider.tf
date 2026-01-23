terraform {

  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">= 2.9.0"
    }
  }
  #Para o desafio comentei o backend, para produção deve ser criado um bucket S3 
  #antes da implementação
  # backend "s3" {
  #   bucket  = "desafio-cloudscript"
  #   key     = "state/terraform.tfstate"
  #   region  = "us-east-1"
  #   encrypt = true
  #   use_lockfile = true
  # }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      owner      = "hicktan"
      managed-by = "terraform"
      projetct   = "desafio-cloudscript"
    }
  }
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

