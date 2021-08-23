data "aws_vpc" "peer" {
  count = length(var.peer_vpcs_id)
  id    = var.peer_vpcs_id[count.index]
}

data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_route_tables" "peer" {
  count  = length(var.peer_vpcs_id)
  vpc_id = var.peer_vpcs_id[count.index]
}

data "aws_route_tables" "main" {
  vpc_id = var.vpc_id
}

locals {
  peer_routes = flatten([
    for route_table in data.aws_route_tables.peer : [
      for route_table_id in route_table.ids : {
        destination        = data.aws_vpc.main.cidr_block
        route_table_id     = route_table_id
        #peering_connection = [for p in aws_vpc_peering_connection.this : p.id if p.peer_vpc_id == route_table.id][0]
        peering_connection = [for p in aws_vpc_peering_connection.this : p.id if p.peer_vpc_id == route_table.vpc_id][0]
      }
    ]
  ])

  main_routes = flatten([
    for route_table_id in data.aws_route_tables.main.ids : [
      for peer_vpc in data.aws_vpc.peer : {
        destination        = peer_vpc.cidr_block
        route_table_id     = route_table_id
        peering_connection = [for p in aws_vpc_peering_connection.this : p.id if p.peer_vpc_id == peer_vpc.id][0]
      }
    ]
  ])
}



