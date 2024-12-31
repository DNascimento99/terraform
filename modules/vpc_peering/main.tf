resource "aws_vpc_peering_connection" "this" {
  vpc_id      = var.vpc_id
  peer_vpc_id = var.peer_vpc_id
  auto_accept = var.auto_accept

  tags = merge(
    {
      Name = var.peering_name
    },
    var.tags
  )
}

resource "aws_route" "this" {
  for_each = { for idx, rt_id in var.route_table_ids : idx => rt_id }

  route_table_id            = each.value
  destination_cidr_block    = var.destination_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

resource "aws_route" "peer_routes" {
  for_each = { for idx, rt_id in var.peer_route_table_ids : idx => rt_id }

  route_table_id            = each.value
  destination_cidr_block    = var.source_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}