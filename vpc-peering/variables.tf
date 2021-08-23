variable "vpc_id" {
  description = "Main VPC. The ID of the vpc which will be peered with the others"
  type = string
}

variable "peer_vpcs_id" {
  description = "List of the vpcs to the peered with the main vpc"
  type = list(string)
}
