output "jwt_access_secret_arn" {
  value = aws_secretsmanager_secret.jwt_access.arn
}

output "jwt_refresh_secret_arn" {
  value = aws_secretsmanager_secret.jwt_refresh.arn
}

output "redis_password_secret_arn" {
  value = aws_secretsmanager_secret.redis_password.arn
}

output "rabbitmq_password_secret_arn" {
  value = aws_secretsmanager_secret.rabbitmq_password.arn
}