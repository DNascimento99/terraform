output "vpc_peering_connection_id" {
  description = "ID da conexão de VPC Peering"
  value       = aws_vpc_peering_connection.this.id
}

output "route_table_ids" {
  value = [for route in aws_route.this : route.route_table_id]
}
