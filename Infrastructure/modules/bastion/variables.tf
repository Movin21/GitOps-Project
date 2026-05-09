variable "cluster_name" {
  description = "Cluster name used for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the bastion host will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "Public subnet ID for the bastion host"
  type        = string
}

variable "key_name" {
  description = "Name of the AWS key pair for SSH access to the bastion host"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the bastion host (e.g. your office IP: 203.0.113.0/32)"
  type        = string
}
