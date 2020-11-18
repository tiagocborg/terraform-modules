output "application_subnets" {
  value = aws_subnet.application.*.id
}

output "edge_subnets" {
  value = aws_subnet.edge.*.id
}

output "dmz_subnets" {
  value = aws_subnet.edge.*.id
}

output "data_subnets" {
  value = aws_subnet.edge.*.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}
