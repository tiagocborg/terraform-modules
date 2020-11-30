variable "instance_class" {
  type        = string
  description = "The instance class for the database."
  default     = "db.t2.micro"
}

variable "db_user" {
  type        = string
  description = "The db admin user."
}

variable "db_name" {
  type        = string
  description = "The db name."
}

variable "subnets" {
  type        = list(string)
  description = "The subnets to be used on the subnet group"
}

variable "engine" {
  type        = string
  description = "The database engine"
}

variable "engine_version" {
  type        = string
  description = "The engine version"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Skip final snapshot?"
  default     = false
}

variable "allocated_storage" {
  type        = number
  description = "The initial storage size"
  default     = 50
}

variable "storage_type" {
  type        = string
  description = "The initial storage type"
  default     = "gp2"
}

variable "publicly_accessible" {
  type        = bool
  description = "Should the instance be public accessible?"
  default     = false
}

variable "identifier" {
  type        = string
  description = "The instance identifier"
}

variable "common_tags" {
  description = "Common tags for the resources"
  type        = map
  default     = {}
}

variable "vpc_id" {
  type        = string
  description = "The vpc id"
}

variable "sg_rules" {
  type = list(object({
    type        = string
    from_port   = string
    to_port     = string
    protocol    = string
    description = string
    cidr_blocks = list(string)
  }))
}

variable "db_port" {
  type        = string
  description = "The connection port of the db instance"
}

variable "project_name" {
  description = "The base name of the project"
  type        = string
}

variable "security_group" {
  description = "A security group for the db instance"
  type        = string
  default     = ""
}

variable "create_sg" {
  description = "Should a security group for this module be created?"
  type        = bool
  default     = true
}

variable "parameter_group_name" {
  description = "Parameter group identificar"
  type        = string
}
