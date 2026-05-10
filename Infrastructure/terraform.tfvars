region   = "us-east-1"
vpc_name = "EKS-Demo-VPC"
vpc_cidr = "10.1.0.0/16"

# Public subnets — bastion, NAT gateway, internet-facing ALB
public_subnets = [
  { name = "public-1", cidr_block = "10.1.1.0/24", availability_zone = "us-east-1a" },
  { name = "public-2", cidr_block = "10.1.2.0/24", availability_zone = "us-east-1b" },
  { name = "public-3", cidr_block = "10.1.3.0/24", availability_zone = "us-east-1c" }
]

# Private subnets — EKS worker nodes, application pods (no direct internet inbound)
private_subnets = [
  { name = "private-1", cidr_block = "10.1.10.0/24", availability_zone = "us-east-1a" },
  { name = "private-2", cidr_block = "10.1.11.0/24", availability_zone = "us-east-1b" },
  { name = "private-3", cidr_block = "10.1.12.0/24", availability_zone = "us-east-1c" }
]

cluster_name    = "eks-cluster"
node_group_name = "eks-node-group"

instance_types = ["m7i-flex.large"]
capacity_type  = "ON_DEMAND"

desired_size = 1
min_size     = 1
max_size     = 2
disk_size    = 30

repositories = [
  "frontend",
  "gateway",
  "auth",
  "order-service",
  "orders",
  "product-service",
  "user-service"
]

# Create this key pair in AWS Console (EC2 → Key Pairs) before applying
key_name = "eks-bastion-key"

# Replace with your IP: curl ifconfig.me
allowed_ssh_cidr = "0.0.0.0/0"

# Replace with your actual domain name
domain_name = "boutique.example.com"
