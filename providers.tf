terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.1"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = var.common_tags
  }
}

provider "aws" {
  alias  = "acm_provider"
  region = "us-east-1"
  default_tags {
    tags = var.common_tags
  }
}