variable "environment" {}
variable "aws_account" {}
variable "aws_region"  {}

variable "vpc_id" {}
variable "subnet_a" {}
variable "subnet_b" {}
variable "subnet_c" {}

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

resource "aws_lb_target_group" "default" {
  name = "repairs-api-lb-tg-${var.environment}"
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id
  target_type = "ip"

  deregistration_delay = 60

  health_check {
    path = "/healthcheck"
    port = 3000

    interval = 10
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_security_group" "lb" {
  name        = "repairs-api-lb-sg-${var.environment}"
  description = "Allow HTTP / HTTPS access to load balancer"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb" "default" {
  name = "repairs-api-lb-${var.environment}"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.lb.id]

  subnets = [
    data.aws_subnet.subnet_a.id,
    data.aws_subnet.subnet_b.id,
    data.aws_subnet.subnet_c.id
  ]

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.default.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.default.arn
    type             = "forward"
  }
}

output "name" {
  value = aws_lb.default.name
}

output "dns_name" {
  value = aws_lb.default.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.default.arn
}

output "target_group_name" {
  value = aws_lb_target_group.default.name
}
