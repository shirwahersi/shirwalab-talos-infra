terraform {
  required_version = "~> 1.11.3"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.93.0"
    }
    libvirt = {
      source  = "multani/libvirt"
      version = "0.6.3-1+4"
    }
  }
}