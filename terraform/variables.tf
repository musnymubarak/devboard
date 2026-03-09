variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "project" {
  type    = string
  default = "devboard"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "alert_email" {
  type        = string
  description = "Email address for CloudWatch alarm notifications"
}