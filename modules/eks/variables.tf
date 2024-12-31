variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "region" {
  description = "Região AWS"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o cluster será criado"
  type        = string
}

variable "public_subnets" {
  description = "Lista de subnets públicas para o cluster"
  type        = list(string)
}

variable "private_subnets" {
  description = "Lista de subnets privadas para o cluster"
  type        = list(string)
}

variable "eks_version" {
  description = "Versão do EKS"
  type        = string
}

variable "node_groups" {
  description = "Configuração dos Node Groups"
  type = list(object({
    name         = string
    instance     = string
    min_size     = number
    max_size     = number
    desired_size = number
  }))
}

variable "aws_auth_map_roles" {
  description = "Mapeamento de roles para o AWS Auth"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}

variable "aws_auth_map_users" {
  description = "Mapeamento de usuários para o AWS Auth"
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}
