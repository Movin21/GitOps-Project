output "bastion_public_ip" {
  description = "Public IP of the bastion host — use this to SSH in"
  value       = aws_instance.bastion.public_ip
}

output "bastion_security_group_id" {
  description = "Security group ID of the bastion host — granted access to EKS"
  value       = aws_security_group.bastion.id
}
