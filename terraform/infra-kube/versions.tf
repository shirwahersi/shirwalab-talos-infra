terraform {
  required_version = "~> 1.13.3"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.16.0"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.3"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
    routeros = {
      source  = "terraform-routeros/routeros"
      version = "1.88.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
  }
}