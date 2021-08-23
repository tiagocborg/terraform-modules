variable "allow_ssh_from_my_ip" {
  description = "If must be a rule to allow SSH from client IP to the VPN instance"
  type = bool
  default = false
}

variable "aws_key_name" {
  description = "SSH keypair name for the VPN instance"
}

variable "aws_key_path" {
  description = "SSH keypair name for the VPN instance"
}

variable "vpc_id" {
  description = "Which VPC VPN server will be created in"
}

variable "public_subnet_id" {
  description = "One of the public subnet id for the VPN instance"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI ID"
  type        = string
  default     = "ami-0535dfe71f7948013"
}

variable "instance_type" {
  description = "Instance type for VPN Box"
  type        = string
  default     = "t2.micro"
}

variable "whitelist" {
  description = "[List] Office IP CIDRs for HTTPS"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "resource_name_prefix" {
  description = "All the resources will be prefixed with the value of this variable"
  default     = "pritunl"
}

variable "internal_cidrs" {
  description = "[List] IP CIDRs to whitelist in the pritunl's security group"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}
