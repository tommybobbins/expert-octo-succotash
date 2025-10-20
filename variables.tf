
variable "common_tags" {
  description = "Common tags you want applied to all components."
  default = {
    Project   = "aws-autopatching-terraform",
    ManagedBy = "Terraform"
  }
}


variable "prefix" {
  default = "dev1"
}

variable "project" {
  default = "ecs-grafana"
}

variable "cloudwatch_log_retention" {
  description = "How long cloudwatch logs for SSM Patching are retained"
  default     = 7
}

variable "vpc_cidr" {
  description = "CIDR for EKS cluster"
  default     = "10.23.0.0/16"
}

variable "aws_region" {
  description = "AWS Region"
  default     = "eu-west-2"
}

locals {

  vpc_cidr = var.vpc_cidr
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    "ManagedBy" = "terraform"
  }
}


variable "service_name" {
  description = "Service name"
  type        = string
  default     = "grafana-ecs"
}

variable "domain_name" {
  description = "Grafana DNS name"
  type        = string
}