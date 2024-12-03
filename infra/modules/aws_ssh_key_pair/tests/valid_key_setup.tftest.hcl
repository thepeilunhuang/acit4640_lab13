# These are the equivalent of unit tests for the module 
# As a result they use command = plan
run "valid_public_key_file" {
  variables {
    key_name = "test_key"  
  }
  command = plan
  assert {
    condition = data.local_file.ssh_pub_key.filename == "./test_key.pem.pub"
    error_message = "The public key file is not in the expected location"
  }
}

run "valid_aws_key_pair" {
  variables {
    key_name = "test_key"  
  }
  command = plan
  assert {
    condition = aws_key_pair.ssh_key_pair.key_name == "test_key"
    error_message = "An AWS key pair with the name test_key does not exist"
  }
}