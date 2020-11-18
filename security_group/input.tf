variable "description" {}
variable "vpc_id" {}

variable "sg_rules" {
  type = list(object({
    type        = string
    from_port   = string
    to_port     = string
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "common_tags" {
  description = "Common tags for the resources"
  type        = map
  default     = {}
}

variable "project_name" {
  description = "The base name of the project"
  type        = string
}
