output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "ecr_urls" {
  value = module.ecr.repository_urls
}

output "bastion_public_ip" {
  description = "SSH to this IP to access the EKS cluster: ssh -i <key>.pem ec2-user@<ip>"
  value       = module.bastion.bastion_public_ip
}
