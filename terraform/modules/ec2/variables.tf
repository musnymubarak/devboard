variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "private_subnet_1_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "k8s_nodes_sg_id" {
  type = string
}

variable "iam_instance_profile_name" {
  type = string
}