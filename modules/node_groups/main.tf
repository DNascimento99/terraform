resource "aws_eks_node_group" "this" {
  for_each        = { for ng in var.node_groups : ng.name => ng }
  cluster_name    = var.cluster_name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = concat(var.public_subnets, var.private_subnets)
  remote_access {
    ec2_ssh_key               = var.ec2_ssh_key
    source_security_group_ids = var.source_security_group_ids
  }
  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }
  instance_types = [each.value.instance]
}

resource "aws_iam_role" "node_role" {

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "node_group_policy" {
  for_each   = toset(["AmazonEKSWorkerNodePolicy", "AmazonEC2ContainerRegistryPullOnly", "AmazonEKS_CNI_Policy"])
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
}

