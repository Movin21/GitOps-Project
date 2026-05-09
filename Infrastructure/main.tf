module "vpc" {
  source = "./modules/vpc"

  vpc_name           = var.vpc_name
  cidr_block         = var.vpc_cidr
  subnet_cidrs       = [for s in var.subnets : s.cidr_block]
  availability_zones = [for s in var.subnets : s.availability_zone]
  cluster_name       = var.cluster_name
}

module "bastion" {
  source = "./modules/bastion"

  cluster_name     = var.cluster_name
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.vpc.subnet_ids[0]
  key_name         = var.key_name
  allowed_ssh_cidr = var.allowed_ssh_cidr

  depends_on = [module.vpc]
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.subnet_ids

  instance_types = var.instance_types
  min_size       = var.min_size
  desired_size   = var.desired_size
  max_size       = var.max_size
  disk_size      = var.disk_size

  bastion_security_group_id = module.bastion.bastion_security_group_id
  key_name                  = var.key_name

  depends_on = [module.vpc, module.bastion]
}

module "ecr" {
  source = "./modules/ecr"

  repositories = var.repositories
}

# NOTE: The kubernetes and helm providers below reach the EKS API.
# With a private endpoint, these only work when Terraform is run from
# within the VPC (e.g. from the bastion). Run the initial ArgoCD
# bootstrap from the bastion after the cluster is up:
#   aws eks update-kubeconfig --region <region> --name <cluster>
#   helm install argo-cd ...

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

  depends_on = [module.eks]
}
