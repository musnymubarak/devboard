output "vpc_id" {
  value = module.vpc.vpc_id
}

output "control_plane_instance_id" {
  value = module.ec2.control_plane_instance_id
}

output "control_plane_private_ip" {
  value = module.ec2.control_plane_private_ip
}

output "worker_asg_name" {
  value = module.ec2.worker_asg_name
}

output "db_endpoint" {
  value     = module.rds.db_endpoint
  sensitive = true
}

output "db_secret_arn" {
  value = module.rds.db_secret_arn
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}

output "ecr_registry_url" {
  value = module.ecr.registry_url
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "cloudfront_domain" {
  value = module.cloudfront.distribution_domain_name
}

output "attachments_bucket_name" {
  value = module.s3.attachments_bucket_name
}

output "velero_bucket_name" {
  value = module.s3.velero_bucket_name
}

output "github_actions_role_arn" {
  value = module.iam.github_actions_role_arn
}

output "sns_topic_arn" {
  value = module.cloudwatch.sns_topic_arn
}