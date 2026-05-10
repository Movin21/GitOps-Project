module "vpc" {
  source = "./modules/vpc"

  vpc_name             = var.vpc_name
  cidr_block           = var.vpc_cidr
  availability_zones   = [for s in var.public_subnets : s.availability_zone]
  public_subnet_cidrs  = [for s in var.public_subnets : s.cidr_block]
  private_subnet_cidrs = [for s in var.private_subnets : s.cidr_block]
  cluster_name         = var.cluster_name
}

module "bastion" {
  source = "./modules/bastion"

  cluster_name     = var.cluster_name
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.vpc.public_subnet_ids[0]
  key_name         = var.key_name
  allowed_ssh_cidr = var.allowed_ssh_cidr

  depends_on = [module.vpc]
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  vpc_id          = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  instance_types = var.instance_types
  min_size       = var.min_size
  desired_size   = var.desired_size
  max_size       = var.max_size
  disk_size      = var.disk_size

  bastion_security_group_id = module.bastion.bastion_security_group_id
  key_name                  = var.key_name
  domain_name               = var.domain_name

  depends_on = [module.vpc, module.bastion]
}

module "ecr" {
  source = "./modules/ecr"

  repositories = var.repositories
}

module "route53" {
  source = "./modules/route53"

  domain_name = var.domain_name
}

# ── Kubernetes / Helm providers ───────────────────────────────────────────────
# NOTE: These providers reach the EKS private API endpoint.
# Run: terraform apply -target=module.vpc -target=module.bastion -target=module.eks -target=module.ecr
# Then SSH to the bastion, run aws eks update-kubeconfig, and apply from there
# for the argocd module which uses these providers.

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  alias = "eks"
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

module "argocd" {
  source = "./modules/argocd"

  providers = {
    kubernetes = kubernetes.eks
    helm       = helm.eks
  }

  cluster_name          = var.cluster_name
  vpc_id                = module.vpc.vpc_id
  aws_region            = var.region
  lbc_role_arn          = module.eks.lbc_role_arn
  external_dns_role_arn = module.eks.external_dns_role_arn
  domain_name           = var.domain_name

  depends_on = [module.eks]
}
