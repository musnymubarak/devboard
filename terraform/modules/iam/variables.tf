variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "account_id" {
  type = string
}

variable "region" {
  type = string
}

variable "attachments_bucket_arn" {
  type = string
}

variable "velero_bucket_arn" {
  type = string
}

variable "jwt_access_secret_arn" {
  type = string
}

variable "jwt_refresh_secret_arn" {
  type = string
}

variable "redis_password_secret_arn" {
  type = string
}

variable "rabbitmq_password_secret_arn" {
  type = string
}

variable "db_secret_arn" {
  type = string
}