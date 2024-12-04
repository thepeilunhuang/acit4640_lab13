# output instance id
output "instance_id" {
  value       = aws_instance.ec2_instance.id
  description = "The ID of the EC2 instance"
}

# output private ip address
output "private_ip" {
  value       = aws_instance.ec2_instance.private_ip
  description = "The private IP address of the EC2 instance"
}

# output instance name
output "name" {
  value       = aws_instance.ec2_instance.tags["Name"]
  description = "The name of the EC2 instance"
}
