# -----------------------------------------------------------------------------
# Setup ssh keys 
# -----------------------------------------------------------------------------
# generate local ssh key pair 
resource "terraform_data" "ssh_key_pair" {
  # https://developer.hashicorp.com/terraform/language/resources/terraform-data

  # this stores the path to the private key 
  input = "${path.root}/${var.key_name}.pem"

  provisioner "local-exec" {
    # https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec
    command = "ssh-keygen -C \"${var.key_name}\" -f \"${path.root}/${var.key_name}.pem\" -m pem -t ed25519 -N \"\""

    # https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax#creation-time-provisioners
    # Only create the key pair when the resource is created by executing the local command
    when = create
  }

  provisioner "local-exec" {
    # glob expressions don't work - need to delete each file individually
    # self.outuput is the value of the input in the resoursce block
    command = "rm -f \"${self.output}\" \"${self.output}.pub\""

    # https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax#destroy-time-provisioners
    # Make sure to delete the key pair when the resource is destroyed by 
    # executing the local command
    when = destroy

  }
}

# -----------------------------------------------------------------------------
# Get local ssh key pair file
# -----------------------------------------------------------------------------
# get the public key from a local file which is assumed to be in the same
# directory as the terraform file
data "local_file" "ssh_pub_key" {
  # https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file
  # https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info
  filename = "${path.root}/${var.key_name}.pem.pub"

  # depends_on is used to ensure that the local key is reading the local file 
  # only when it exists
  depends_on = [terraform_data.ssh_key_pair]
}

# -----------------------------------------------------------------------------
# Create aws key from local key file
# -----------------------------------------------------------------------------
# the resource below assumes that we have created a local key pair but
# haven't imported it to aws yet. from the docs: 
# "currently this resource requires an existing user-supplied key pair. 
# this key pair's public key will be registered with aws to allow logging-in to
# ec2 instances." 
resource "aws_key_pair" "main" {
  # https://registry.terraform.io/providers/-/aws/latest/docs/resources/key_pair
  key_name   = var.key_name
  public_key = data.local_file.ssh_pub_key.content

  # depends_on is used to ensure that the local public key has been created 
  # before the key is "imported" to AWS
  # https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on
  depends_on = [terraform_data.ssh_key_pair]
}