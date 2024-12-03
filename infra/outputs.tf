output "vpc_id" {
  value = module.vpc.vpc_id
}

output "sn_1" {
  value = module.vpc.sn_1_id

}

output "gw_1" {
  value = module.vpc.gw_1_id
}

output "rt_1" {
  value = module.vpc.rt_1_id
}

output "sg_1" {
  value = module.sg.sg_1_id
}

output "ec2_instance_id" {
  value = module.ec2.ec2_instance_id
}

output "ec2_instance_public_ip" {
  value = module.ec2.ec2_instance_public_ip
}

output "ec2_instance_public_dns" {
  value = module.ec2.ec2_instance_public_dns
}
