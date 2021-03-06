# Helm Provider
provider "helm" {}

# Helm Chart Stable Repo
data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

variable "nginx_ingress_enabled" {
  description = "Bool to enable nginx ingress"
  type        = bool
  default     = true
}

# Deploy Helm Chart
resource "helm_release" "nginx_ingress" {
  count            = var.nginx_ingress_enabled ? 1 : 0
  name             = "nginx-ingress"
  chart            = "stable/nginx-ingress"
  repository       = data.helm_repository.stable.metadata[0].name
  create_namespace = "true"
  namespace        = "kube-system"
  values           = [file("${path.module}/nginx_ingress.yaml")]
  wait             = true
  force_update     = true

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }
}
