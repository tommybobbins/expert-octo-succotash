variable "use_efs" {
  type        = bool
  default     = true
  description = "Create EFS resource and use it for InfluxDB's data storage"
}

variable "aws_vpc" {
  type        = object({ id : string })
  description = "VPC to place ECS task and security groups into"
}

variable "aws_vpc_cidr" {
  type        = list(any)
  description = "VPC CIDR"
  default     = ["10.23.0.0/16"]
}

variable "aws_vpc_ipv6_cidr_block" {
  type        = list(any)
  description = "VPC IPV6 CIDR"
}

variable "aws_subnets" {
  type        = list(object({ id : string }))
  description = "VPC to place ECS task onto"
}

variable "access_ips" {
  type        = list(any)
  description = "IPs allowed to access the frontend service"
}

variable "aws_service_discovery_private_dns_namespace" {
  type        = object({ id : string })
  description = "Namespace to register Grafana service under"
}

# variable "aws_security_group" {
#   type        = object({ id : string })
#   description = "SG for the ECS task"
# }

variable "aws_ecs_cluster" {
  type        = object({ id : string })
  description = "ECS cluster to place Grafana task on"
}

variable "task_role" {
  type        = object({ arn : string })
  description = "Role to run ECS Grafana task under"
}

variable "execution_role" {
  type        = object({ arn : string })
  description = "Role to start ECS Grafana task from"
}

variable "cpu" {
  type        = number
  description = "vCPUs for ECS Grafana task"
}

variable "memory" {
  type        = number
  description = "Memory in MB for ECS Grafana task"
}

variable "auth_enabled" {
  type        = bool
  default     = true
  description = "Enables authentication"
}

variable "admin_user" {
  type        = string
  default     = "admin"
  description = "Username of the Grafana admin user"
}

variable "aws_secretsmanager_secret-admin_password" {
  type        = object({ arn : string })
  description = "Password of the Grafana admin user stored as Secrets Manager secret"
}

variable "rw_user" {
  type        = string
  default     = "rw"
  description = "Username of the Grafana RW user"
}

variable "aws_secretsmanager_secret-rw_user_password" {
  type        = object({ arn : string })
  description = "Password of the Grafana RW user stored as Secrets Manager secret"
}

variable "ro_user" {
  type        = string
  default     = "ro"
  description = "Username of the Grafana RO user"
}

variable "aws_secretsmanager_secret-ro_user_password" {
  type        = object({ arn : string })
  description = "Password of the Grafana RO user stored as Secrets Manager secret"
}

variable "name" {
  type        = string
  default     = "example"
  description = "Name used to build resource names"
}

variable "tags" {
  type        = map(any)
  description = "Tags assigned to every AWS resource"
}

variable "retention_in_days" {
  type        = number
  default     = 1
  description = "Retention period for the Cloudwatch-based ECS logs"
}

variable "image_name" {
  type        = string
  default     = "grafana"
  description = "Container image name to run"
}

variable "image_tag" {
  type        = string
  default     = "latest"
  description = "Container image version to run"
}

variable "container_port" {
  type        = string
  default     = "3000"
  description = "Container TCP port"
}

variable "ssl_cert_arn" {
  type        = string
  default     = ""
  description = "ACM arn"
}