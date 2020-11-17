# output "web_sg" {
#   value = aws_security_group.http.id
# }

# output "rds_sg" {
#   value = aws_security_group.rds.id
# }

# output "app_sg" {
#   value = aws_security_group.app.id
# }

# output "private_subnets" {
#   value = aws_subnet.private.*.id
# }

# output "public_subnets" {
#   value = aws_subnet.public.*.id
# }

output "application_subnets" {
  value = aws_subnet.application.*.id
}

output "edge_subnets" {
  value = aws_subnet.edge.*.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}
