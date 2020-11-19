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

data "aws_ssm_parameter" "db_username" {
  name = "/repairs-api/${var.environment}/DB_USERNAME"
}

data "aws_ssm_parameter" "db_password" {
  name = "/repairs-api/${var.environment}/DB_PASSWORD"
}

resource "aws_db_subnet_group" "database" {
  name = "repairs-api-db-subnet-group-${var.environment}"

  subnet_ids = [
    data.aws_subnet.subnet_a.id,
    data.aws_subnet.subnet_b.id,
    data.aws_subnet.subnet_c.id
  ]

  tags = {
    Environment = var.environment
  }
}

resource "aws_security_group" "database" {
  name = "repairs-api-database-sg-${var.environment}"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = [
      data.aws_subnet.subnet_a.cidr_block,
      data.aws_subnet.subnet_b.cidr_block,
      data.aws_subnet.subnet_c.cidr_block
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

variable "instance_class" { default = "db.t3.small" }
variable "multi_az" { default = false }
variable "allocated_storage" { default = 100 }
variable "max_allocated_storage" { default = 1000 }
variable "storage_encrypted" { default = true }
variable "storage_type" { default = "gp2" }
variable "iops" { default = 0 }
variable "backup_retention" { default = 7 }
variable "backup_window" { default = "04:05-04:35" }
variable "maintenance_window" { default = "thu:03:15-thu:03:45" }
variable "monitoring_interval" { default = 0 }
variable "performance_insights_enabled" { default = true }
variable "iam_database_authentication_enabled" { default = false }
variable "enabled_cloudwatch_logs_exports" { default = [] }

resource "aws_db_instance" "database" {
  identifier = "repairs-api-db-${var.environment}"

  engine         = "postgres"
  engine_version = "12.4"
  instance_class = var.instance_class
  multi_az       = var.multi_az

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = var.storage_encrypted
  storage_type          = var.storage_type
  iops                  = var.iops

  db_subnet_group_name    = aws_db_subnet_group.database.id
  vpc_security_group_ids  = [aws_security_group.database.id]

  username = data.aws_ssm_parameter.db_username.value
  password = data.aws_ssm_parameter.db_password.value

  backup_retention_period = var.backup_retention
  backup_window           = var.backup_window
  copy_tags_to_snapshot   = true
  skip_final_snapshot     = true

  maintenance_window  = var.maintenance_window
  deletion_protection = true

  monitoring_interval                 = var.monitoring_interval
  performance_insights_enabled        = var.performance_insights_enabled
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports

  publicly_accessible = false

  apply_immediately = true

  tags = {
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "database_url" {
  name        = "/repairs-api/${var.environment}/DATABASE_URL"
  type        = "SecureString"
  value       = "postgres://${data.aws_ssm_parameter.db_username.value}:${data.aws_ssm_parameter.db_password.value}@${aws_db_instance.database.endpoint}/repairs-api"

  tags = {
    Environment = var.environment
  }
}
