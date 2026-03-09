# Subnet group — RDS needs subnets in 2 AZs
resource "aws_db_subnet_group" "main" {
  name       = "${var.project}-db-subnet-group-${var.environment}"
  subnet_ids = [var.private_subnet_1_id, var.private_subnet_2_id]

  tags = { Name = "${var.project}-db-subnet-group-${var.environment}" }
}

# Parameter group — enables connection logging
resource "aws_db_parameter_group" "main" {
  name   = "${var.project}-db-params-${var.environment}"
  family = "postgres16"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  tags = { Name = "${var.project}-db-params-${var.environment}" }
}

# RDS PostgreSQL instance
resource "aws_db_instance" "main" {
  identifier        = "${var.project}-db-${var.environment}"
  engine            = "postgres"
  engine_version    = "16"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = "devboard"
  username = "devboard_admin"

  # AWS manages the master password in Secrets Manager automatically
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.main.name
  parameter_group_name   = aws_db_parameter_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]

  # Backup configuration
  backup_retention_period = 7
  backup_window           = "02:00-03:00"
  maintenance_window      = "Mon:03:00-Mon:04:00"

  # Protection against accidental deletion
  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.project}-db-final-snapshot-${var.environment}"

  tags = { Name = "${var.project}-db-${var.environment}" }

  lifecycle {
    prevent_destroy = true
  }
}