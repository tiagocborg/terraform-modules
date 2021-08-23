variable "policies" {
    description = "The policies to attach to the role"
    type = list
    default = []
 
}

variable "role_name"{
    description = "The name of the IAM Role"
    type = string
    default = ""
}

