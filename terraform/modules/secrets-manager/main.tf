# JWT Access Token Secret
resource "aws_secretsmanager_secret" "jwt_access" {
  name                    = "${var.project}/jwt-access-secret"
  description             = "JWT access token signing secret"
  recovery_window_in_days = 7

  tags = { Name = "${var.project}-jwt-access-${var.environment}" }
}

resource "aws_secretsmanager_secret_version" "jwt_access" {
  secret_id     = aws_secretsmanager_secret.jwt_access.id
  secret_string = random_password.jwt_access.result
}

resource "random_password" "jwt_access" {
  length  = 64
  special = false
}

# JWT Refresh Token Secret
resource "aws_secretsmanager_secret" "jwt_refresh" {
  name                    = "${var.project}/jwt-refresh-secret"
  description             = "JWT refresh token signing secret"
  recovery_window_in_days = 7

  tags = { Name = "${var.project}-jwt-refresh-${var.environment}" }
}

resource "aws_secretsmanager_secret_version" "jwt_refresh" {
  secret_id     = aws_secretsmanager_secret.jwt_refresh.id
  secret_string = random_password.jwt_refresh.result
}

resource "random_password" "jwt_refresh" {
  length  = 64
  special = false
}

# Redis Password
resource "aws_secretsmanager_secret" "redis_password" {
  name                    = "${var.project}/redis-password"
  description             = "Redis authentication password"
  recovery_window_in_days = 7

  tags = { Name = "${var.project}-redis-password-${var.environment}" }
}

resource "aws_secretsmanager_secret_version" "redis_password" {
  secret_id     = aws_secretsmanager_secret.redis_password.id
  secret_string = random_password.redis_password.result
}

resource "random_password" "redis_password" {
  length  = 32
  special = false
}

# RabbitMQ Password
resource "aws_secretsmanager_secret" "rabbitmq_password" {
  name                    = "${var.project}/rabbitmq-password"
  description             = "RabbitMQ authentication password"
  recovery_window_in_days = 7

  tags = { Name = "${var.project}-rabbitmq-password-${var.environment}" }
}

resource "aws_secretsmanager_secret_version" "rabbitmq_password" {
  secret_id     = aws_secretsmanager_secret.rabbitmq_password.id
  secret_string = random_password.rabbitmq_password.result
}

resource "random_password" "rabbitmq_password" {
  length  = 32
  special = false
}