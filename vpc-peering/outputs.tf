output "peer_vpcs_route_tables" {
  value = data.aws_route_tables.peer
}

output "main_vpcs_route_tables" {
  value = data.aws_route_tables.main
}

output "peer_routes" {
  value = local.peer_routes
}

output "main_routes" {
  value = local.main_routes
}