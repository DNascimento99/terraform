variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "public_subnets" {
  description = "Subnets usadas pelos Node Groups"
  type        = list(string)
}

variable "private_subnets" {
  description = "Subnets usadas pelos Node Groups"
  type        = list(string)
}

variable "instance" {
  description = "Tipo de instância dos nodes"
  type        = string
}

variable "min_size" {
  description = "Tamanho mínimo do Node Group"
  type        = number
}

variable "max_size" {
  description = "Tamanho máximo do Node Group"
  type        = number
}

variable "desired_size" {
  description = "Tamanho desejado do Node Group"
  type        = number
}

variable "node_groups" {
  description = "Configuração dos Node Groups"
  type = list(object({
    name                      = string
    instance                  = string
    min_size                  = number
    max_size                  = number
    desired_size              = number
    ec2_ssh_key               = string
  }))
}

variable "ec2_ssh_key" {
  description = "EC2 Key Pair name for SSH access to the worker nodes"
  type        = string
  default     = null
}

variable "source_security_group_ids" {
  description = "Set of Security Group IDs to allow SSH access to worker nodes"
  type        = list(string)
  default     = null
}

