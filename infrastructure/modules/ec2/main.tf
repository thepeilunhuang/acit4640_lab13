# create ec2 instance
resource "aws_instance" "ec2_instance" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_groups = var.security_groups
  key_name        = var.key_name

  tags = merge(
    {
      Name = var.name
    },
    var.additional_tags
  )

  user_data = var.user_data
}
