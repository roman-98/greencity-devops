terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }

  }

backend "remote" {
		hostname = "app.terraform.io"
		organization = "GreenCity"

		workspaces {
			name = "greencity-aws"
		}
	}
}

/*
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
provider "kubernetes" {
  cluster_ca_certificate = base64decode(module.eks.kubeconfig-certificate-authority-data)
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token

}
*/

provider "aws" {
  region = "eu-west-3"
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "abhi-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 5
  special = false
}