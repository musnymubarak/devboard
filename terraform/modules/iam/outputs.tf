output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_node.name
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}

output "cluster_autoscaler_role_arn" {
  value = aws_iam_role.cluster_autoscaler.arn
}

output "velero_role_arn" {
  value = aws_iam_role.velero.arn
}

output "eso_role_arn" {
  value = aws_iam_role.eso.arn
}

output "task_service_role_arn" {
  value = aws_iam_role.task_service.arn
}