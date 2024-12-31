
module "eks_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name                    = var.eks_vpc.name
  cidr                    = var.eks_vpc.cidr
  azs                     = var.eks_vpc.azs
  public_subnets          = var.eks_vpc.public_subnets
  private_subnets         = var.eks_vpc.private_subnets
  enable_nat_gateway      = true
  single_nat_gateway      = true
  enable_dns_support      = true
  public_subnet_tags      = var.eks_vpc.eks_subnet_tags.public
  map_public_ip_on_launch = true
  private_subnet_tags     = var.eks_vpc.eks_subnet_tags.private

  tags = var.eks_vpc.tags
}

module "db_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name                 = var.db_vpc.name
  cidr                 = var.db_vpc.cidr
  azs                  = var.db_vpc.azs
  public_subnets       = var.db_vpc.public_subnets
  private_subnets      = var.db_vpc.private_subnets
  enable_nat_gateway   = false
  enable_dns_support   = true
  enable_dns_hostnames = true

  public_subnet_tags  = var.db_vpc.db_subnet_tags.public
  private_subnet_tags = var.db_vpc.db_subnet_tags.private

  tags = var.db_vpc.tags
}

module "vpc_peering" {
  source = "./modules/vpc_peering"

  vpc_id                 = module.eks_vpc.vpc_id
  peer_vpc_id            = module.db_vpc.vpc_id
  route_table_ids        = concat(module.eks_vpc.public_route_table_ids, module.eks_vpc.private_route_table_ids)
  peer_route_table_ids   = concat(module.db_vpc.public_route_table_ids, module.db_vpc.private_route_table_ids)
  destination_cidr_block = var.db_vpc.cidr
  source_cidr_block      = var.eks_vpc.cidr
  peering_name           = var.peering_name
}

module "eks_security_groups" {
  source = "./modules/security_group"

  vpc_id          = module.eks_vpc.vpc_id
  security_groups = var.eks_security_groups
}

module "db_security_groups" {
  source = "./modules/security_group"

  vpc_id          = module.db_vpc.vpc_id
  security_groups = var.db_security_groups
}

module "db_bastion_security_groups" {
  source = "./modules/security_group"

  vpc_id          = module.db_vpc.vpc_id
  security_groups = var.db_bastion_security_groups
}

module "eks_cluster" {
  source = "./modules/eks"

  cluster_name       = var.cluster_name
  region             = var.region
  vpc_id             = module.eks_vpc.vpc_id
  public_subnets     = module.eks_vpc.public_subnets
  private_subnets    = module.eks_vpc.private_subnets
  eks_version        = var.eks_version
  node_groups        = var.node_groups
  aws_auth_map_roles = var.aws_auth_map_roles
  aws_auth_map_users = var.aws_auth_map_users
  depends_on         = [module.eks_vpc]
}

module "addons" {
  source       = "./modules/addons"
  addons       = var.addons
  cluster_name = var.cluster_name
  depends_on = [
    module.eks_vpc,
    module.node_groups
  ]
}
module "node_groups" {
  source = "./modules/node_groups"

  for_each = { for ng in var.node_groups : ng.name => ng }

  cluster_name              = var.cluster_name
  public_subnets            = module.eks_vpc.public_subnets
  private_subnets           = module.eks_vpc.private_subnets
  node_groups               = var.node_groups
  instance                  = each.value.instance
  min_size                  = each.value.min_size
  max_size                  = each.value.max_size
  desired_size              = each.value.desired_size
  ec2_ssh_key               = each.value.ec2_ssh_key
  source_security_group_ids = module.eks_security_groups.security_group_ids

  depends_on = [module.eks_cluster]
}

module "ec2_instances_bd" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 4.0"
  for_each                    = var.instances_db
  name                        = each.key
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  subnet_id                   = module.db_vpc.private_subnets[0]
  vpc_security_group_ids      = module.db_security_groups.security_group_ids
  key_name                    = each.value.key_name
  iam_instance_profile        = each.value.iam_instance_profile
  associate_public_ip_address = each.value.associate_public_ip_address

  root_block_device = [{
    volume_size = each.value.volume_size
    volume_type = each.value.volume_type
    iops        = each.value.iops
  }]
  tags = {
    Name = each.key
  }
  depends_on = [module.db_vpc]
}

module "ec2_instances_bastion" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 4.0"
  for_each                    = var.instances_bastion
  name                        = each.key
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  subnet_id                   = module.db_vpc.public_subnets[0]
  vpc_security_group_ids      = module.db_bastion_security_groups.security_group_ids
  key_name                    = each.value.key_name
  iam_instance_profile        = each.value.iam_instance_profile
  associate_public_ip_address = each.value.associate_public_ip_address

  root_block_device = [{
    volume_size = each.value.volume_size
    volume_type = each.value.volume_type
    iops        = each.value.iops
  }]
  tags = {
    Name = each.key
  }
  depends_on = [module.db_vpc]
}