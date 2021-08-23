resource "aws_vpc_peering_connection" "this" {
  count       = length(var.peer_vpcs_id)
  vpc_id      = var.vpc_id
  peer_vpc_id = var.peer_vpcs_id[count.index]
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "peer_routes" {
  count = length(local.peer_routes)

  route_table_id            = local.peer_routes[count.index].route_table_id
  destination_cidr_block    = local.peer_routes[count.index].destination
  vpc_peering_connection_id = local.peer_routes[count.index].peering_connection
  depends_on                = [aws_vpc_peering_connection.this]
}

resource "aws_route" "main_routes" {
  count = length(local.main_routes)

  route_table_id            = local.main_routes[count.index].route_table_id
  destination_cidr_block    = local.main_routes[count.index].destination
  vpc_peering_connection_id = local.main_routes[count.index].peering_connection
  depends_on                = [aws_vpc_peering_connection.this, var.vpc_id]
}

