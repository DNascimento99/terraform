variable "vpc_id" {
  description = "ID da VPC de origem"
  type        = string
}

variable "peer_vpc_id" {
  description = "ID da VPC de destino (peer)"
  type        = string
}

variable "auto_accept" {
  description = "Aceitação automática do peering"
  type        = bool
  default     = true
}

variable "peering_name" {
  description = "Nome para o peering"
  type        = string
}

variable "route_table_ids" {
  description = "IDs das tabelas de rotas da VPC de origem"
  type        = list(string)
}

variable "peer_route_table_ids" {
  description = "IDs das tabelas de rotas da VPC de destino"
  type        = list(string)
}

variable "destination_cidr_block" {
  description = "CIDR da VPC de destino para rotas da VPC de origem"
  type        = string
}

variable "source_cidr_block" {
  description = "CIDR da VPC de origem para rotas da VPC de destino"
  type        = string
}

variable "tags" {
  description = "Tags adicionais para os recursos"
  type        = map(string)
  default     = {}
}
