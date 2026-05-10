terraform {
  required_providers {
    kubernetes = { source = "hashicorp/kubernetes" }
    helm       = { source = "hashicorp/helm" }
  }
}

# ── Namespaces ────────────────────────────────────────────────────────────────

resource "kubernetes_namespace_v1" "argocd" {
  metadata { name = "argocd" }
}

resource "kubernetes_namespace_v1" "monitoring" {
  metadata { name = "monitoring" }
}

# ── ArgoCD ────────────────────────────────────────────────────────────────────

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.7.0"

  create_namespace = false

  values = [yamlencode({
    server = {
      service = { type = "ClusterIP" }
    }
    configs = {
      params = { "server.insecure" = true }
    }
  })]
}

# ── AWS Load Balancer Controller ──────────────────────────────────────────────
# Creates ALBs from Kubernetes Ingress resources using IRSA for AWS API access

resource "helm_release" "aws_lbc" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.7.2"

  create_namespace = false

  values = [yamlencode({
    clusterName = var.cluster_name
    serviceAccount = {
      create = true
      name   = "aws-load-balancer-controller"
      annotations = {
        "eks.amazonaws.com/role-arn" = var.lbc_role_arn
      }
    }
    region = var.aws_region
    vpcId  = var.vpc_id
  })]

  depends_on = [helm_release.argocd]
}

# ── External DNS ──────────────────────────────────────────────────────────────
# Watches Ingress resources and creates/updates Route 53 records automatically

resource "helm_release" "external_dns" {
  name       = "external-dns"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = "1.14.3"

  create_namespace = false

  values = [yamlencode({
    provider = "aws"
    aws = {
      region = var.aws_region
    }
    domainFilters   = [var.domain_name]
    txtOwnerId      = var.cluster_name
    serviceAccount = {
      create = true
      name   = "external-dns"
      annotations = {
        "eks.amazonaws.com/role-arn" = var.external_dns_role_arn
      }
    }
    policy = "sync"
  })]

  depends_on = [helm_release.argocd]
}

# ── Kube Prometheus Stack ─────────────────────────────────────────────────────

resource "helm_release" "monitoring" {
  name       = "kube-prometheus-stack"
  namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "56.21.0"

  timeout          = 600
  create_namespace = false

  values = [yamlencode({
    grafana      = { service = { type = "ClusterIP" } }
    prometheus   = { service = { type = "ClusterIP" } }
    alertmanager = { service = { type = "ClusterIP" } }
  })]

  depends_on = [kubernetes_namespace_v1.monitoring]
}
