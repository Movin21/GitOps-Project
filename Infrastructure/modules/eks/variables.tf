variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster is deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS control plane ENIs and worker nodes"
  type        = list(string)
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
  default     = "ON_DEMAND"
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
  description = "Root volume size in GiB for worker nodes"
  type        = number
  default     = 20
}

variable "bastion_security_group_id" {
  description = "Bastion SG — granted HTTPS to EKS API and SSH to nodes"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair for SSH access to nodes via bastion"
  type        = string
}

variable "domain_name" {
  description = "Domain name used for external-dns Route 53 filtering"
  type        = string
}
