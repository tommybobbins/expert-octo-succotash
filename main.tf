module "grafana_ecs" {
  source                         = "./modules/terraform-grafana"
  aws_region                     = "eu-west-2"
  service_name                   = var.service_name
  platform_version               = "1.4.0"
  image                          = "public.ecr.aws/ubuntu/grafana"
  image_version                  = "12-24.04"
  container_port                 = 3000
  cpu                            = 512
  memory                         = 2048
  desired_number_of_tasks        = 1
  allow_inbound_from_cidr_blocks = ["89.22.197.125/32"]
  vpc_id                         = module.vpc.vpc_id
  private_subnet_ids             = module.vpc.private_subnets
  public_subnet_ids              = module.vpc.public_subnets
  ssl_cert_arn                   = aws_acm_certificate.ssl_certificate.arn
}
