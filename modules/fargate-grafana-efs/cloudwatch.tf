resource "aws_cloudwatch_log_group" "grafana" {
  name              = "/aws/ecs/${var.name}/grafana"
  retention_in_days = var.retention_in_days
}