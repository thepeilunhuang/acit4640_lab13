provider "aws" {
  region = "us-west-2"
}
# create vpc
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16" # vpc ip range
  enable_dns_hostnames = true
}
# create internet gateway to connect to the internet for the vpc
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}
# create route table to route the traffic to the internet gateway
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # all ip addresses
    gateway_id = aws_internet_gateway.main.id
  }
}
# create public subnets
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}
# create private subnets
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
}
# associate the route table to the public subnet
resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.main.id
}
# associate the route table to the private subnet
resource "aws_route_table_association" "private_subnet" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.main.id
}
###################################################
#### create security group to allow ssh access ########
module "public_security_group" {
  source      = "./modules/sg"
  name        = "public_security_group"
  description = "Allow SSH and HTTP access from the internet and all traffic from VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    "ssh_internet" = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow SSH from the internet"
    },
    "http_internet" = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP from the internet"
    },
    "all_vpc" = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [module.vpc.vpc_cidr_block]
      description = "Allow all traffic from within the VPC"
    }
  }

  egress_rules = {
    "all_out" = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  }
}

###################################################
## create private security group to allow access to the private instances
module "private_security_group" {
  source      = "./modules/sg"
  name        = "private_security_group"
  description = "Allow SSH from the internet and all traffic from VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    "ssh_internet" = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow SSH from the internet"
    },
    "all_vpc" = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [module.vpc.vpc_cidr_block]
      description = "Allow all traffic from within the VPC"
    }
  }

  egress_rules = {
    "all_out" = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  }
}

###################################################
# create w01 web and  reverse proxy instances
module "w01" {
  source          = "./modules/ec2"
  ami             = "ami-03839f1dba75bb628"
  instance_type   = "t2.micro"
  subnet_id       = module.vpc.public_subnet_id
  security_groups = [module.security_groups.public_security_group]
  key_name        = module.ssh_key.ssh_key_name
  name            = "w01"
  user_data       = <<-EOF
                      #!/bin/bash
                      hostnamectl set-hostname w01
                    EOF
  additional_tags = {
    Server_Role = "web"
    Project     = "acit4640_lab13"
  }
}


# create b01 chat backend instance
module "b01" {
  source          = "./modules/ec2"
  ami             = "ami-03839f1dba75bb628"
  instance_type   = "t2.micro"
  subnet_id       = module.vpc.private_subnet_id
  security_groups = [module.security_groups.private_security_group]
  key_name        = module.ssh_key.ssh_key_name
  name            = "b01"
  user_data       = <<-EOF
                      #!/bin/bash
                      hostnamectl set-hostname b01
                    EOF
  additional_tags = {
    Server_Role = "backend"
    Project     = "acit4640_lab13"
  }
}

# DNS module
module "dns" {
  source              = "./modules/dns"
  zone_name           = "lab13.internal"
  vpc_id              = module.vpc.vpc_id
  domain_name_servers = ["AmazonProvidedDNS"]
  record_ttl          = 300

  instances = [
    {
      name       = "w01"
      private_ip = module.w01.private_ip
    },
    {
      name       = "b01"
      private_ip = module.b01.private_ip
    }
  ]
}

###################################################
# Configure the terraform backend to store the state file in an S3 bucket
terraform {
  backend "s3" {
    bucket  = "acit-4640-lab13-terraform-state"
    key     = "lab13/terraform.tfstate" # state file storage path
    region  = "us-west-2"               # AWS region
    encrypt = true
  }
}
# create S3 bucket to store the terraform state file
resource "aws_s3_bucket" "terraform_state" {
  bucket = "acit-4640-lab13-terraform-state"
  tags = {
    Name        = "terraform-state"
    Environment = "Lab13"
  }
}

resource "aws_s3_bucket_acl" "terraform_state_acl" {
  bucket = aws_s3_bucket.terraform_state.id
  acl    = "private"
}
###################################################
# create ssh key pair
module "ssh_key" {
  source       = "git::https://gitlab.com/acit_4640_library/tf_modules/aws_ssh_key_pair.git"
  ssh_key_name = "acit_4640_lab_13"
  output_dir   = path.root
}

module "connect_script" {
  source           = "git::https://gitlab.com/acit_4640_library/tf_modules/aws_ec2_connection_script.git"
  ec2_instances    = { "w01" = aws_instance.w01, "b01" = aws_instance.b01 }
  output_file_path = "${path.root}/connect_vars.sh"
  ssh_key_file     = module.ssh_key.priv_key_file
  ssh_user_name    = "ubuntu"
}
