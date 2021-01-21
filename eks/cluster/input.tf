variable "project_name" {
  description = "The base name of the project"
  type        = string
}

variable "cluster_subnets" {
  description = "The subnets for the master node"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "region" {
  description = "The aws region"
  type        = string
}


variable "common_tags" {
  description = "Common tags for the resources"
  type        = map(any)
  default     = {}
}

variable "security_groups" {
  description = "Master security group"
  type        = list(string)
}

variable "iam_role" {
  description = "Master iam role"
  type        = string
}
