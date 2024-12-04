
output "zone_id" {
  value       = aws_route53_zone.private_zone.zone_id
  description = "The ID of the Route53 private hosted zone"
}


output "dhcp_options_id" {
  value       = aws_vpc_dhcp_options.dhcp_options.id
  description = "The ID of the DHCP options set"
}


output "dns_records" {
  value = [for record in aws_route53_record.dns_record : record.name]
  description = "The DNS records created in the Route53 zone"
}
