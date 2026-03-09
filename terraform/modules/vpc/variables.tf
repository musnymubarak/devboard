variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "account_id" {
  type = string
}