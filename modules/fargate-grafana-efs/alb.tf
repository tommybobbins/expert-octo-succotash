
# Security group for the ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.name}-alb-sg"
  description = "Allow traffic to the ALB created for the ${var.name} service"
  vpc_id      = var.aws_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.access_ips
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.access_ips
  }

  egress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks      = var.aws_vpc_cidr
    ipv6_cidr_blocks = var.aws_vpc_ipv6_cidr_block
  }
}



# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE LB TARGET GROUP TO WHICH THE SERVICE ABOVE WILL ATTACH
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_target_group" "target_group" {
  name                 = var.name
  port                 = var.container_port
  protocol             = var.alb_target_group_protocol
  target_type          = "ip"
  vpc_id               = var.aws_vpc.id
  deregistration_delay = var.alb_target_group_deregistration_delay

  health_check {
    enabled             = true
    interval            = var.health_check_interval
    path                = var.health_check_path
    port                = var.container_port
    protocol            = var.health_check_protocol
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    matcher             = var.health_check_matcher
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE APPLICATION LOAD BALANCER FOR THE ECS SERVICE
# ---------------------------------------------------------------------------------------------------------------------

# Define a S3 bucket for the ALB logs
resource "aws_s3_bucket" "alb_logs" {
  bucket_prefix = "${var.name}-alb-logs"
}

resource "aws_s3_bucket_versioning" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id
  policy = data.aws_iam_policy_document.alb_logs.json
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "alb_logs" {
  statement {
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.alb_logs.bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]
    actions = ["s3:PutObject"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.id}:root"]
    }
  }

  statement {
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.alb_logs.bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]
    actions = ["s3:PutObject"]
    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.alb_logs.bucket}",
    ]
    actions = ["s3:GetBucketAcl"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

# Create the actual ALB
resource "aws_lb" "ecs_alb" {
  name                             = "${var.name}-alb"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = ["${aws_security_group.alb_sg.id}"]
  subnets                          = var.aws_subnets.*.id
  enable_cross_zone_load_balancing = true
  enable_http2                     = true

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.bucket
    enabled = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CONFIGURE THE HTTP(S) LISTENERS
# These will accept the HTTP(S) requests and forward them to the proper target groups
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
