
variable "zone_name" {
  type        = string
  description = "The name of the Route53 private hosted zone"
}


variable "vpc_id" {
  type        = string
  description = "The ID of the VPC associated with the Route53 zone"
}


variable "domain_name_servers" {
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
  description = "List of DNS servers for the DHCP options set"
}


variable "record_ttl" {
  type        = number
  default     = 300
  description = "The TTL (Time to Live) for the DNS records"
}


variable "instances" {
  type = list(object({
    name       = string
    private_ip = string
  }))
  description = "A list of instances with name and private IP to create DNS records"
}
