# security group name
variable "name" {
  type        = string
  description = "The name of the security group"
}

# description
variable "description" {
  type        = string
  description = "A description of the security group"
}

# VPC ID
variable "vpc_id" {
  type        = string
  description = "The VPC ID where the security group will be created"
}

# tags
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to apply to the security group"
}

# Ingress rules
variable "ingress_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default     = {}
  description = "A map of ingress rules to apply to the security group"
}

# Egress rules
variable "egress_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default     = {}
  description = "A map of egress rules to apply to the security group"
}
