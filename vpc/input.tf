variable "cidr_block" {
  description = "The cidr block for the vpc"
  type        = string
}


variable "edge_subnet_cidr" {
  description = "The range for the edge subnets"
  type        = list(any)
  default     = []
}

variable "data_subnet_cidr" {
  description = "The range for the data subnets"
  type        = list(any)
  default     = []
}

variable "dmz_subnet_cidr" {
  description = "The range for the dnz subnets"
  type        = list(any)
  default     = []
}

variable "application_subnet_cidr" {
  description = "The range for the application subnets"
  type        = list(any)
  default     = []
}

variable "edge_subnet_tags" {
  description = "Unique tags for edge subnets"
  type        = map(any)
  default     = {}
}

variable "application_subnet_tags" {
  description = "Unique tags for application subnets"
  type        = map(any)
  default     = {}
}

variable "data_subnet_tags" {
  description = "Unique tags for data subnets"
  type        = map(any)
  default     = {}
}

variable "common_tags" {
  description = "Common tags for the resources"
  type        = map(any)
  default     = {}
}

variable "enable_dns_hostnames" {
  description = "Should dns hostnames be enabled by default?"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should dns support be enabled by default?"
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Should flow logs be enabled by default?"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "If NAT Gateways should be deployed"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Single NAT Gateway"
  type        = bool
  default     = false
}

variable "instance_tenancy" {
  description = "What is the default VPC tenancy?"
  type        = string
  default     = "default"
}

variable "project_name" {
  description = "The base name of the project"
  type        = string
}

variable "env_name" {
  description = "The env name"
  type        = string
}

variable "region" {
  description = "The aws region"
  type        = string
}
