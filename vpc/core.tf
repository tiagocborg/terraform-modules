locals {
  common_tags             = var.common_tags
  edge_subnet_tags        = merge(local.common_tags, var.edge_subnet_tags)
  application_subnet_tags = merge(local.common_tags, var.application_subnet_tags)
}


################
# VPC Resource #
################
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  instance_tenancy     = var.instance_tenancy

  tags = merge(
    {
      Name = "vpc-${var.project_name}-${var.region}-common"
    },
    local.common_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

####################
# Internet Gateway #
####################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = "igw-${var.project_name}-${var.region}-common"
    },
    local.common_tags
  )
  lifecycle {
    create_before_destroy = true
  }
}

#############################
# ELASTIC IPS & NAT GATEWAY #
#############################
resource "aws_eip" "this" {
  count = length(var.edge_subnet_cidr)
  vpc   = true

  tags = merge(
    {
      Name = "eip-${var.project_name}-${var.region}-common"
    },
    local.common_tags
  )
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "this" {
  count         = length(var.edge_subnet_cidr)
  allocation_id = element(aws_eip.this.*.id, count.index)
  subnet_id     = element(aws_subnet.edge.*.id, count.index)
  depends_on    = [aws_internet_gateway.this]
  tags = merge(
    {
      Name = "nat-${var.project_name}-${var.region}-common"
    },
    local.common_tags
  )
  lifecycle {
    create_before_destroy = true
  }
}

##################
# SUBNETS # EDGE #
##################
resource "aws_subnet" "edge" {
  count             = length(var.edge_subnet_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.edge_subnet_cidr, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    {
      Name = "sbn-${var.project_name}-${var.region}-edge"
    },
    local.edge_subnet_tags
  )
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "edge" {
  count  = length(var.edge_subnet_cidr) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = "rt-${var.project_name}-${var.region}-edge"
    },
    local.edge_subnet_tags
  )
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "igw" {
  count = length(var.edge_subnet_cidr) > 0 ? 1 : 0

  route_table_id         = aws_route_table.edge.0.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "edge" {
  count          = length(var.edge_subnet_cidr)
  route_table_id = aws_route_table.edge.0.id
  subnet_id      = element(aws_subnet.edge.*.id, count.index)
  lifecycle {
    create_before_destroy = true
  }
}

#########################
# SUBNETS # APPLICATION #
#########################
resource "aws_subnet" "application" {
  count             = length(var.application_subnet_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.application_subnet_cidr, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]


  tags = merge(
    {
      Name = "sbn-${var.project_name}-${var.region}-application"
    },
    local.application_subnet_tags
  )
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "application" {
  count  = length(var.application_subnet_cidr)
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = "rt-${var.project_name}-${var.region}-application"
    },
    local.common_tags
  )
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "application" {
  count                  = length(var.application_subnet_cidr)
  route_table_id         = element(aws_route_table.application.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this.*.id, count.index)

  timeouts {
    create = "5m"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "application" {
  count          = length(var.application_subnet_cidr)
  subnet_id      = element(aws_subnet.application.*.id, count.index)
  route_table_id = element(aws_route_table.application.*.id, count.index)
  lifecycle {
    create_before_destroy = true
  }
}

##################
# SUBNETS # DATA #
##################
resource "aws_subnet" "data" {
  count             = length(var.data_subnet_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.data_subnet_cidr, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    {
      Name = "sbn-${var.project_name}-${var.region}-data"
    },
    local.common_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "data" {
  count  = length(var.data_subnet_cidr) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = "rt-${var.project_name}-${var.region}-data"
    },
    local.common_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "data" {
  count          = length(var.data_subnet_cidr)
  subnet_id      = element(aws_subnet.data.*.id, count.index)
  route_table_id = aws_route_table.data.0.id

  lifecycle {
    create_before_destroy = true
  }
}

#################
# SUBNETS # DMZ #
#################
resource "aws_subnet" "dmz" {
  count             = length(var.dmz_subnet_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.dmz_subnet_cidr, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]


  tags = merge(
    {
      Name = "sbn-${var.project_name}-${var.region}-dmz"
    },
    local.common_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "dmz" {
  count  = length(var.dmz_subnet_cidr)
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = "rt-${var.project_name}-${var.region}-dmz"
    },
    local.common_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "dmz" {
  count                  = length(var.dmz_subnet_cidr)
  route_table_id         = element(aws_route_table.dmz.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this.*.id, count.index)

  timeouts {
    create = "5m"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "dmz" {
  count          = length(var.dmz_subnet_cidr)
  subnet_id      = element(aws_subnet.dmz.*.id, count.index)
  route_table_id = element(aws_route_table.dmz.*.id, count.index)

  lifecycle {
    create_before_destroy = true
  }
}

################
# VPC ENDPOINT #
################
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = concat(
    aws_route_table.data.*.id,
    aws_route_table.dmz.*.id,
    aws_route_table.edge.*.id,
    aws_route_table.application.*.id
  )
  tags = merge(
    {
      Name = "vpc-${var.project_name}-${var.region}-endpoint"
    },
    local.common_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}
