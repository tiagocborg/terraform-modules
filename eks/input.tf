variable "project_name" {
  description = "The base name of the project"
  type        = string
}

variable "cluster_subnets" {
  description = "The subnets for the master node"
  type        = list(string)
}

variable "workers_subnets" {
  description = "The subnets for the workers nodes"
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

variable "create_master_role" {
  description = "Should the role for the master node be created?"
  type        = bool
  default     = true
}

variable "create_registry" {
  description = "Should the ecr registry be created?"
  type        = bool
  default     = true
}

variable "instance_types" {
  description = "The worker instance types"
  type        = list
}

variable "image_id" {
  description = "The worker image id"
  type        = string
}

variable "common_tags" {
  description = "Common tags for the resources"
  type        = map
  default     = {}
}

variable "scaling_config" {
  description = "Number of instances for the asg"
  type        = map
  default = {
    desired = 2
    min     = 2
    max     = 3
  }
}
