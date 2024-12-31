resource "aws_eks_addon" "addons" {
  for_each = { for addon in var.addons : addon.name => addon }

  cluster_name  = var.cluster_name
  addon_name    = each.key
  addon_version = each.value.version

  resolve_conflicts_on_update = "OVERWRITE"
  lifecycle {
    ignore_changes = [addon_version]
  }
}