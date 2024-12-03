variable "sg_name" {
    description = "the name of the security group"
    type = string
}

variable "sg_description" {
    description = "the description of the security group"
    type = string
}

variable "project_name" {
    description = "the project that the sg belongs to, used to tag AWS resources" 
    type = string
}

variable "vpc_id" {
    description = "the id of the vpc"
    type = string
}

variable "ingress_rules" {
    description = "the ingress rules for the security group in the form of a list of maps"
    type = list(map(string))
}

variable "egress_rules" {
    description = "the egress rules for the security group in the form of a list of maps"
    type = list(map(string))
}
