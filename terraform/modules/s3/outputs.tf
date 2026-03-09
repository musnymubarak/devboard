output "attachments_bucket_name" {
  value = aws_s3_bucket.attachments.bucket
}

output "attachments_bucket_arn" {
  value = aws_s3_bucket.attachments.arn
}

output "velero_bucket_name" {
  value = aws_s3_bucket.velero.bucket
}

output "velero_bucket_arn" {
  value = aws_s3_bucket.velero.arn
}