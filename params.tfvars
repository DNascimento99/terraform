###############VPC#################
eks_vpc = {
  name            = "eks-vpc"
  cidr            = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  tags = {
    "Environment" = "eks"
  }
  eks_subnet_tags = {
    public = {
      "eks-public-subnet-us-east-1a" = "public"
      "eks-public-subnet-us-east-1b" = "public"
      "eks-public-subnet-us-east-1c" = "public"
    }
    private = {
      "eks-private-subnet-us-east-1a" = "private"
      "eks-private-subnet-us-east-1b" = "private"
      "eks-private-subnet-us-east-1c" = "private"
    }
  }
}

db_vpc = {
  name            = "db-vpc"
  cidr            = "10.1.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  private_subnets = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
  tags = {
    Environment = "db"
  }
  db_subnet_tags = {
    public = {
      "db-public-subnet-us-east-1a" = "public"
      "db-public-subnet-us-east-1b" = "public"
      "db-public-subnet-us-east-1c" = "public"
    }
    private = {
      "db-private-subnet-us-east-1a" = "private"
      "db-private-subnet-us-east-1b" = "private"
      "db-private-subnet-us-east-1c" = "private"
    }
  }
}

peering_name = "eks-to-db-peering"

###############SG#################

eks_security_groups = [
  {
    name        = "eks-sg"
    description = "Security group for EKS"
    ingress = [
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    tags = {
      Environment = "dev"
    }
  }
]

db_security_groups = [
  {
    name        = "db-sg"
    description = "Security group for DB"
    ingress = [
      {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["10.0.0.0/16"]
      },
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["10.1.0.0/16"]
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    tags = {
      Environment = "dev"
    }
  }
]

db_bastion_security_groups = [
  {
    name        = "db-bastion-sg"
    description = "Security group for bastion DB"
    ingress = [
      {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["10.1.0.0/16"]
      },
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    tags = {
      Environment = "dev"
    }
  }
]

###############EKS#################

cluster_name = "cluster-eks-teste"
region       = "us-east-1"
eks_version  = "1.30"

node_groups = [
  {
    name                      = "ng-1"
    instance                  = "t2.micro"
    min_size                  = 2
    max_size                  = 5
    desired_size              = 4
    ec2_ssh_key               = "key-pair-lab"
    source_security_group_ids = []
  },
  {
    name                      = "ng-2"
    instance                  = "t2.micro"
    min_size                  = 2
    max_size                  = 5
    desired_size              = 4
    ec2_ssh_key               = "key-pair-lab"
    source_security_group_ids = []
  }
]

aws_auth_map_roles = [
  {
    rolearn  = ""
    username = "admin"
    groups   = ["system:masters"]
  }
]

aws_auth_map_users = [
  {
    userarn  = ""
    username = "developer"
    groups   = ["developer-group"]
  }
]

addons = [
  {
    name    = "vpc-cni"
    version = "v1.19.2-eksbuild.1"
    config  = null
  },
  {
    name    = "kube-proxy"
    version = "v1.30.7-eksbuild.2"
    config  = null
  },
  {
    name    = "coredns"
    version = "v1.11.4-eksbuild.1"
    config  = null
  },
  {
    name    = "aws-ebs-csi-driver"
    version = "v1.38.1-eksbuild.1"
    config  = null
  }
]

###############EC2#################

instances_db = {
  instance-eks = {
    ami                         = "ami-01816d07b1128cd2d",
    instance_type               = "t2.micro",
    volume_size                 = 2200,
    volume_type                 = "gp3",
    iops                        = 100,
    key_name                    = "key-pair-lab",
    iam_instance_profile        = "ssm-instance",
    associate_public_ip_address = true,
  }
  instance-bd = {
    ami                         = "ami-01816d07b1128cd2d",
    instance_type               = "t2.micro",
    volume_size                 = 100,
    volume_type                 = "gp3",
    iops                        = 3000,
    key_name                    = "key-pair-lab",
    iam_instance_profile        = "ssm-instance",
    associate_public_ip_address = false
  }
}
instances_bastion = {
  "bastion-instance" = {
    ami                         = "ami-01816d07b1128cd2d"
    instance_type               = "t2.micro"
    volume_size                 = 100
    volume_type                 = "gp3"
    iops                        = 3000
    key_name                    = "key-pair-lab"
    iam_instance_profile        = "ssm-instance"
    associate_public_ip_address = true
  }
}