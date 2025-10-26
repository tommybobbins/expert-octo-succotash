data "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ECS_trust" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "grafana_execution" {
  name               = "Example-${var.service_name}-grafana_execution"
  assume_role_policy = data.aws_iam_policy_document.ECS_trust.json
  tags               = local.common_tags
}

resource "aws_iam_role_policy_attachment" "grafana_execution-attach-AmazonECSTaskExecutionRolePolicy" {
  role       = aws_iam_role.grafana_execution.name
  policy_arn = data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn
}

resource "aws_iam_role" "grafana" {
  name               = "ecs-${var.service_name}-grafana"
  assume_role_policy = data.aws_iam_policy_document.ECS_trust.json
  tags               = local.common_tags
}

