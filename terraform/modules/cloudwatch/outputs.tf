output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

output "app_log_group_name" {
  value = aws_cloudwatch_log_group.app.name
}

output "k8s_log_group_name" {
  value = aws_cloudwatch_log_group.k8s.name
}