variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets — bastion, NAT gateway, internet-facing ALB"
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
}

variable "private_subnets" {
  description = "Private subnets — EKS worker nodes and application pods"
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "node_group_name" {
  description = "EKS node group name"
  type        = string
}

variable "instance_types" {
  description = "EC2 instance types for worker nodes"
  type        = list(string)
}

variable "capacity_type" {
  description = "ON_DEMAND or SPOT"
  type        = string
}

variable "desired_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "disk_size" {
  type = number
}

variable "repositories" {
  description = "ECR repository names (one per microservice)"
  type        = list(string)
}

variable "key_name" {
  description = "AWS key pair name for bastion and node SSH access"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR permitted to SSH into the bastion (your IP — curl ifconfig.me)"
  type        = string
}

variable "domain_name" {
  description = "Root domain for Route 53 hosted zone and external-dns (e.g. boutique.example.com)"
  type        = string
}
