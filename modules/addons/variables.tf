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
variable "cluster_name" {
  type = string
}