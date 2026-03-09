# RDS PostgreSQL instance
resource "aws_db_instance" "main" {
  identifier        = "${var.project}-db-${var.environment}"
  engine            = "postgres"
  engine_version    = "16"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  copy_tags_to_snapshot      = true
  auto_minor_version_upgrade = true
  iam_database_authentication_enabled = true
  monitoring_interval        = 60
  monitoring_role_arn        = aws_iam_role.rds_enhanced_monitoring.arn
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  db_name  = "devboard"
  username = "devboard_admin"

  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.main.name
  parameter_group_name   = aws_db_parameter_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]

  backup_retention_period = 7
  backup_window           = "02:00-03:00"
  maintenance_window      = "Mon:03:00-Mon:04:00"

  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.project}-db-final-snapshot-${var.environment}"

  tags = {
    Name = "${var.project}-db-${var.environment}"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# IAM role for enhanced monitoring
resource "aws_iam_role" "rds_enhanced_monitoring" {
  name = "${var.project}-rds-monitoring-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach policy
resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}