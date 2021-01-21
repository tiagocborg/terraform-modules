variable "project_name" {
  description = "The base name of the project"
  type        = string
}

variable "workers_subnets" {
  description = "The subnets for the workers nodes"
  type        = list(string)
}

variable "instance_types" {
  description = "The worker instance type"
  type        = list(string)
}

variable "image_id" {
  description = "The worker image id"
  type        = string
}

variable "capacity_type" {
  description = "Type of capacity"
  default     = "ON_DEMAND"
  type        = string
}

variable "common_tags" {
  description = "Common tags for the resources"
  type        = map(any)
  default     = {}
}

variable "scaling_config" {
  description = "Number of instances for the asg"
  type        = map(number)
  default = {
    desired = 1
    min     = 2
    max     = 2
  }
}

variable "labels" {
  description = "Labels for the worker nodes"
  type        = map(string)
  default     = {}
}

variable "security_groups" {
  description = "Master security group"
  type        = list(string)
}

variable "cluster_name" {
  description = "The cluster name"
  type        = string
}

variable "worker_group_name" {
  description = "The worker group name"
  type        = string
}

variable "worker_role" {
  description = "The IAM role for the instances"
  type        = string
}

variable "kubelet_extra_args" {
  description = "Kubelet extra args"
  type        = string
  default     = ""
}

variable "spot_price" {
  description = "Minimum price for spots"
  type        = string
  default     = ""
}
