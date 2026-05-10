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
  description = "SSH: ssh -i eks-bastion-key.pem ec2-user@<ip>"
  value       = module.bastion.bastion_public_ip
}

output "nat_public_ip" {
  description = "NAT Gateway public IP — whitelist this on external APIs/services"
  value       = module.vpc.nat_public_ip
}

output "route53_name_servers" {
  description = "Add these NS records at your domain registrar"
  value       = module.route53.name_servers
}

output "route53_zone_id" {
  value = module.route53.zone_id
}
