terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
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
