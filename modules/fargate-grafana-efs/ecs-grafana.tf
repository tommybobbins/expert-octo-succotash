data "aws_region" "current" {}

resource "aws_ecs_task_definition" "grafana-efs" {
  count  = var.use_efs ? 1 : 0
  family = "${var.name}-${terraform.workspace}-grafana"
  container_definitions = templatefile("${path.module}/task-definitions/grafana-efs.tpl",
    {
      image              = "${var.image_name}${var.image_tag}" # Remember to ad the colon to the image_tag 
      cpu                = var.cpu
      memory             = var.memory
      container_port     = var.container_port
      auth_enabled       = var.auth_enabled
      db_name            = var.name
      admin_username     = var.admin_user
      admin_password-arn = var.aws_secretsmanager_secret-admin_password.arn
      rw_username        = var.rw_user
      rw_password-arn    = var.aws_secretsmanager_secret-rw_user_password.arn
      ro_username        = var.ro_user
      ro_password-arn    = var.aws_secretsmanager_secret-ro_user_password.arn
      region             = data.aws_region.current.id
      log_group          = aws_cloudwatch_log_group.grafana.name

    }
  )

  task_role_arn      = var.task_role.arn
  execution_role_arn = var.execution_role.arn

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

  volume {
    name = "grafana-storage"

    efs_volume_configuration {
      file_system_id = aws_efs_file_system.grafana[0].id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.grafana.id
        iam             = "DISABLED"
      }
    }
  }

  tags = var.tags
}

resource "aws_ecs_service" "grafana" {
  name             = "${var.name}-${terraform.workspace}-grafana"
  cluster          = var.aws_ecs_cluster.id
  task_definition  = aws_ecs_task_definition.grafana-efs[0].arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0" #This should be latest but that defaults to 1.3 right now

  network_configuration {
    security_groups = [aws_security_group.grafana_access_sg_task.id]
    # This needs to be set to true if running in a public subnet, if private, will route via NAT GW
    assign_public_ip = true
    subnets          = var.aws_subnets.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = var.name
    container_port   = var.container_port
  }



  service_registries {
    registry_arn = aws_service_discovery_service.grafana.arn
  }

  tags           = var.tags
  propagate_tags = "TASK_DEFINITION"
}
