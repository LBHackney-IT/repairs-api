variable "environment" {}
variable "aws_account" {}
variable "aws_region"  {}

variable "vpc_id" {}
variable "subnet_a" {}
variable "subnet_b" {}
variable "subnet_c" {}

variable "target_group_arn" {}

data "aws_vpc" "default" {
  id = var.vpc_id
}

data "aws_subnet" "subnet_a" {
  id = var.subnet_a
}

data "aws_subnet" "subnet_b" {
  id = var.subnet_b
}

data "aws_subnet" "subnet_c" {
  id = var.subnet_c
}

resource "aws_ecs_cluster" "default" {
  name = "repairs-api-${var.environment}"
}

resource "aws_security_group" "web" {
  name        = "repairs-api-ecs-sg-web-${var.environment}"
  description = "Enable HTTP access to the cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"

    cidr_blocks = [
      data.aws_subnet.subnet_a.cidr_block,
      data.aws_subnet.subnet_b.cidr_block,
      data.aws_subnet.subnet_c.cidr_block
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_migrate" {
  name        = "repairs-api-ecs-sg-db-migrate-${var.environment}"
  description = "Enable outgoing access for the cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudwatch_log_group" "web" {
  name = "repairs-api-web-${var.environment}"
  retention_in_days = "30"
}

resource "aws_cloudwatch_log_group" "db_migrate" {
  name = "repairs-api-db-migrate-${var.environment}"
  retention_in_days = "30"
}

data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "ecs_task_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "ecs_task_execution_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]

    effect = "Allow"
  }

  statement {
    actions = [
      "ssm:GetParameters"
    ]

    resources = [
      "arn:aws:ssm:${var.aws_region}:${var.aws_account}:parameter/repairs-api/${var.environment}/*"
    ]

    effect = "Allow"
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name = "repairs-api-ecs-task-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

resource "aws_iam_role_policy" "ecs_task" {
  name = "repairs-api-ecs-task-policy-${var.environment}"
  role = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.ecs_task_policy.json
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "repairs-api-ecs-task-execution-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy" "ecs_task_execution" {
  name = "repairs-api-ecs-task-execution-policy-${var.environment}"
  role = aws_iam_role.ecs_task_execution_role.id
  policy = data.aws_iam_policy_document.ecs_task_execution_policy.json
}

data "template_file" "web" {
  template = file("${path.module}/tasks/web.tpl")

  vars = {
    environment = var.environment
    aws_region  = var.aws_region
    aws_account = var.aws_account
  }
}

resource "aws_ecs_task_definition" "web" {
  family                   = "repairs-api-web-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = data.template_file.web.rendered
}

data "template_file" "db_migrate" {
  template = file("${path.module}/tasks/db_migrate.tpl")

  vars = {
    environment = var.environment
    aws_region  = var.aws_region
    aws_account = var.aws_account
  }
}

resource "aws_ecs_task_definition" "db_migrate" {
  family                   = "repairs-api-db-migrate-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = data.template_file.db_migrate.rendered
}

data "aws_ecs_task_definition" "web" {
  task_definition = aws_ecs_task_definition.web.family
  depends_on = [aws_ecs_task_definition.web]
}

resource "aws_ecs_service" "web" {
  name = "repairs-api-web-${var.environment}"
  cluster = aws_ecs_cluster.default.id
  task_definition = "${aws_ecs_task_definition.web.family}:${max(aws_ecs_task_definition.web.revision, data.aws_ecs_task_definition.web.revision)}"
  launch_type = "FARGATE"
  desired_count = 2

  network_configuration {
    subnets = [
      data.aws_subnet.subnet_a.id,
      data.aws_subnet.subnet_b.id,
      data.aws_subnet.subnet_c.id
    ]
    security_groups = [aws_security_group.web.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name = "repairs-api"
    container_port = 3000
  }
}
