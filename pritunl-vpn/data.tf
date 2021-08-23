data "http" "client_ip" {
  url = "http://ifconfig.me"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}