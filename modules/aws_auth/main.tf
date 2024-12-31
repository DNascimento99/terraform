resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = jsonencode(var.aws_auth_map_roles)
    mapUsers = jsonencode(var.aws_auth_map_users)
  }
}