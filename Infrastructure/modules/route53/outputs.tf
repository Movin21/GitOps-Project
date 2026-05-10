output "zone_id" {
  description = "Route 53 hosted zone ID — used by external-dns and ACM validation"
  value       = aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "Nameservers to configure at your domain registrar"
  value       = aws_route53_zone.main.name_servers
}
