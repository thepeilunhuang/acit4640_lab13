# create Route53 private hosted zone
resource "aws_route53_zone" "private_zone" {
  name = var.zone_name # recive zone name as variable
  vpc {
    vpc_id = var.vpc_id # recive vpc id as variable
  }
}

# create dhcp options
resource "aws_vpc_dhcp_options" "dhcp_options" {
  domain_name         = var.zone_name # use zone name as domain name
  domain_name_servers = var.domain_name_servers
}

# associate dhcp options with vpc
resource "aws_vpc_dhcp_options_association" "dhcp_association" {
  vpc_id          = var.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_options.id
}

# create dns record
resource "aws_route53_record" "dns_record" {
  count   = length(var.instances)
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "${var.instances[count.index].name}.${var.zone_name}"
  type    = "A"
  ttl     = var.record_ttl
  records = [var.instances[count.index].private_ip]
}
