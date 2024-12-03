module "vpc" {
  source       = "./modules/terraform_vpc_simple"
  project_name = var.project_name
  vpc_cidr     = "172.16.1.0/24"
  subnet_cidr  = "172.16.1.0/25"
  home_net     = "75.157.34.0/24"
  aws_region   = "us-west-2"
}

module "sg"{
  source = "./modules/terraform_security_group"
  sg_name = "mod_demo_sg"
  sg_description = "Allows ssh, web, and port 5000 ingress access and all egress"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      description = "ssh access from home"
      ip_protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_ipv4 = var.home_net
      rule_name = "ssh_access_home"
    },
    {
      description = "ssh access from bcit"
      ip_protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_ipv4 = var.bcit_net
      rule_name = "ssh_access_bcit"
    },
    {
      description = "web access from home"
      ip_protocol = "tcp"
      from_port = 80
      to_port = 80
      cidr_ipv4 = var.home_net
      rule_name = "web_access_home"
    },
    {
      description = "web access from bcit"
      ip_protocol = "tcp"
      from_port = 80
      to_port = 80
      cidr_ipv4 = var.bcit_net
      rule_name = "web_access_bcit"
    },
    {
      description = "port 5000 access from home"
      ip_protocol = "tcp"
      from_port = 5000 
      to_port = 5000 
      cidr_ipv4 = var.home_net
      rule_name = "port_5000_access_home"
    },
    {
      description = "port 5000 access from bcit"
      ip_protocol = "tcp"
      from_port = 5000 
      to_port = 5000 
      cidr_ipv4 = var.bcit_net
      rule_name = "port_5000_access"
    }
   ]
  egress_rules = [ 
    {
      description = "allow all egress traffic"
      ip_protocol = "-1"
      from_port = 0
      to_port = 0
      cidr_ipv4 = "0.0.0.0/0"
      rule_name = "allow_all_egress"
    }
   ]
}

## ----------------------------------------------------------------------------
## SETUP SSH KEY PAIR: LOCAL FILE AND AWS KEY PAIR
## ----------------------------------------------------------------------------

module "ssh_key" {
  source       = "git::https://gitlab.com/acit_4640_library/tf_modules/aws_ssh_key_pair.git"
  ssh_key_name = "acit_4640_lab_13_tf_backend"
  output_dir   = path.root
}

module "ec2" {
  source = "./modules/terraform_ec2_simple"
  project_name = var.project_name
  aws_region = var.aws_region
  ami_id = var.ami_id
  subnet_id = module.vpc.sn_1_id
  security_group_id = module.sg.sg_1_id
  ssh_key_name = module.ssh_key.ssh_key_name
}
