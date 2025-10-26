# Route 53 for domain

data "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "grafana" {
  provider = aws.acm_provider
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "grafana"
  type    = "CNAME"
  records        = [module.ecs_efs.fqdn]
  ttl = 300

}

# Uncomment the below block if you are doing certificate validation using DNS instead of Email.
resource "aws_route53_record" "cert_validation" {
  provider = aws.acm_provider
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = data.aws_route53_zone.main.zone_id
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}
