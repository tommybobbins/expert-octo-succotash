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

resource "aws_iam_role_policy_attachment" "task_ssm_ro" {
  role       = aws_iam_role.grafana_execution.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "grafana_ssm_ro" {
  role = aws_iam_role.grafana.name
  # policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  policy_arn = aws_iam_policy.grafana_config.arn
}

data "aws_iam_policy_document" "grafana_config" {
  statement {
    actions = [
      "ssm:DescribeParameters",
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "ssm:GetParameters",
    ]
    resources = [aws_ssm_parameter.grafana_config.arn]
  }
}

resource "aws_iam_policy" "grafana_config" {
  name   = "grafana_retrieve_from_ssm"
  policy = data.aws_iam_policy_document.grafana_config.json
}

