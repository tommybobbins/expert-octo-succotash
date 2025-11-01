variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.23.0.0/16"
}

variable "service_name" {
  description = "Service Name"
  type        = string
  default     = "efs-ecs"
}

variable "access_ips" {
  description = "IPs allowed to connect"
  type        = list(any)
  default     = ["1.2.3.4/32"]
}

variable "domain_name" {
  description = "Domain name for the service"
  type        = string

}