variable "eks_vpc" {
  type = object({
    name            = string
    cidr            = string
    azs             = list(string)
    public_subnets  = list(string)
    private_subnets = list(string)
    eks_subnet_tags = object({
      public  = map(string)
      private = map(string)
    })
    tags = map(string)
  })
}


variable "db_vpc" {
  type = object({
    name            = string
    cidr            = string
    azs             = list(string)
    public_subnets  = list(string)
    private_subnets = list(string)
    tags            = map(string)
    db_subnet_tags = object({
      public  = map(string)
      private = map(string)
    })
  })
}

variable "peering_name" {
  type = string
}

variable "eks_security_groups" {
  type = list(object({
    name        = string
    description = string
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    tags = map(string)
  }))
}

variable "db_security_groups" {
  type = list(object({
    name        = string
    description = string
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    tags = map(string)
  }))
}

variable "db_bastion_security_groups" {
  type = list(object({
    name        = string
    description = string
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    tags = map(string)
  }))
}

variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "region" {
  description = "Região AWS"
  type        = string
}


variable "eks_version" {
  description = "Versão do EKS"
  type        = string
}

variable "addons" {
  description = "Lista de addons para o cluster EKS"
  type = list(
    object({
      name    = string
      version = string
      config  = any
    })
  )
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
    source_security_group_ids = optional(list(string), [])
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

variable "instances_db" {
  description = "Map of instances configurations"
}

variable "instances_bastion" {
  type = map(object({
    ami                         = string
    instance_type               = string
    key_name                    = string
    iam_instance_profile        = string
    associate_public_ip_address = bool
    volume_size                 = number
    volume_type                 = string
    iops                        = number
  }))
}