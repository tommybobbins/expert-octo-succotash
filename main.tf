resource "aws_service_discovery_private_dns_namespace" "ecs" {
  name = "ecs.local"
  vpc  = module.vpc.vpc_id
}

locals {
  common_tags = {
    project   = "expert-octo-succotash"
    env       = "prd"
    ManagedBy = "terraform"
  }

  admin_user = "admin"
  rw_user    = "rw_user"
  ro_user    = "ro_user"
}

resource "aws_ecs_cluster" "_" {
  name = var.service_name
}

module "ecs_efs" {
  source = "./modules/fargate-grafana-efs"

  name                                        = "ecs-efs"
  aws_service_discovery_private_dns_namespace = aws_service_discovery_private_dns_namespace.ecs

  aws_ecs_cluster = aws_ecs_cluster._
  cpu             = 512
  memory          = 2048

  execution_role = aws_iam_role.grafana_execution
  task_role      = aws_iam_role.grafana
  image_name     = "public.ecr.aws/ubuntu/grafana"
  image_tag      = "12.0-24.04"

  admin_user                                 = local.admin_user
  aws_secretsmanager_secret-admin_password   = { "arn" : "foo" }
  rw_user                                    = local.rw_user
  aws_secretsmanager_secret-rw_user_password = { "arn" : "bar" }
  ro_user                                    = local.ro_user
  aws_secretsmanager_secret-ro_user_password = { "arn" : "bart" }

  aws_vpc                 = { "id" : module.vpc.vpc_id }
  aws_subnets             = module.vpc.public_subnet_objects
  aws_vpc_cidr            = [module.vpc.vpc_cidr_block]
  aws_vpc_ipv6_cidr_block = [module.vpc.vpc_ipv6_cidr_block]
  access_ips              = var.access_ips
  ssl_cert_arn            = aws_acm_certificate.ssl_certificate.arn
  tags                    = local.common_tags
}