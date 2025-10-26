resource "aws_security_group" "efs_grafana_access" {
  name        = "${var.name}-EFS-grafana-access"
  description = "Allow access to the Grafana EFS"
  vpc_id      = var.aws_vpc.id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    security_groups = [
      aws_security_group.grafana_access_sg_task.id
    ]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-grafana-access"
  })
}

resource "aws_security_group" "grafana_access_sg_task" {
  name        = "${var.name}-grafana"
  description = "Allow access to Grafana"
  vpc_id      = var.aws_vpc.id

  # ingress {
  #   from_port = 8086
  #   to_port   = 8086
  #   protocol  = "tcp"
  #   cidr_blocks = var.vpc_cidr
  # }

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = var.access_ips
  }

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = var.aws_vpc_cidr
    ipv6_cidr_blocks = var.aws_vpc_ipv6_cidr_block
  }

  tags = merge(var.tags, {
    Name = "${var.name}-grafana_access"
  })
}