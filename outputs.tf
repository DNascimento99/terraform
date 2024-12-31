output "public_route_table_ids" {
  value = module.eks_vpc.public_route_table_ids
}

output "private_route_table_ids" {
  value = module.eks_vpc.private_route_table_ids
}
