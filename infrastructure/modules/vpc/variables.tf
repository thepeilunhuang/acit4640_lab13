# VPC
variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Enable DNS hostnames for the VPC"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Enable DNS support for the VPC"
}

# public subnet configuration
variable "public_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "A list of public subnets with CIDR blocks and availability zones"
}

# private subnet configuration
variable "private_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "A list of private subnets with CIDR blocks and availability zones"
}

# tags
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to apply to resources"
}
