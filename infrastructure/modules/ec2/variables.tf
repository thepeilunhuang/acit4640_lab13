# AMI ID
variable "ami" {
  type        = string
  description = "The AMI ID for the EC2 instance"
}

# instance type
variable "instance_type" {
  type        = string
  description = "The type of EC2 instance (e.g., t2.micro)"
}

# subnet id
variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the instance will be deployed"
}

# security groups
variable "security_groups" {
  type        = list(string)
  description = "A list of security group IDs"
}

# ssh key name
variable "key_name" {
  type        = string
  description = "The name of the SSH key pair"
}

# instance name
variable "name" {
  type        = string
  description = "The name of the EC2 instance"
}

# additional tags
variable "additional_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to add to the EC2 instance"
}

# user data
variable "user_data" {
  type        = string
  default     = ""
  description = "The user data script to configure the instance on launch"
}
