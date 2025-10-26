resource "aws_efs_file_system" "grafana" {
  count     = var.use_efs ? 1 : 0
  encrypted = true
  tags = merge(var.tags, {
    Name = "${var.name}-${terraform.workspace}-grafana"
  })
}

resource "aws_efs_mount_target" "grafana" {
  count = var.use_efs ? length(var.aws_subnets) : 0

  file_system_id  = aws_efs_file_system.grafana[0].id
  subnet_id       = var.aws_subnets[count.index].id
  security_groups = [aws_security_group.efs_grafana_access.id]
  ip_address_type = "DUAL_STACK"
}