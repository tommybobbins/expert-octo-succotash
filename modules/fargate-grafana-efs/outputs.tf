output "registry" {
  value = aws_service_discovery_service.grafana
}

output "cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.grafana
}


output "fqdn" {
  value = aws_lb.ecs_alb.dns_name
}

