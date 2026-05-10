variable "cluster_name" {
  description = "EKS cluster name — passed to AWS Load Balancer Controller"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID — passed to AWS Load Balancer Controller"
  type        = string
}

variable "aws_region" {
  description = "AWS region for Load Balancer Controller and external-dns"
  type        = string
}

variable "lbc_role_arn" {
  description = "IRSA role ARN for the AWS Load Balancer Controller service account"
  type        = string
}

variable "external_dns_role_arn" {
  description = "IRSA role ARN for the external-dns service account"
  type        = string
}

variable "domain_name" {
  description = "Domain filter for external-dns (e.g. boutique.example.com)"
  type        = string
}
