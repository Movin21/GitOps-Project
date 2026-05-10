variable "vpc_name" {
  description = "Name tag for the VPC and derived resources"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones (must match length of subnet CIDR lists)"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets — one per AZ (bastion, NAT, ALB)"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets — one per AZ (EKS nodes, pods)"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS cluster name used for subnet discovery tags"
  type        = string
}
