# Generate an SSH key pair for EMR cluster access
resource "tls_private_key" "tls_emr_ssh_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}


# Create an AWS key pair
resource "aws_key_pair" "emr_ssh_key" {
    key_name   = "emr_ssh_key"
    public_key = tls_private_key.tls_emr_ssh_key.public_key_openssh

    tags = {
      Name = "emr_ssh_key"
      Project = var.project_name
      Environment = var.environment
      Service = "emr"
      Terraform = "true"
    }
}


# Save the private key to a file with restricted permissions
resource "local_file" "ssh_private_key" {
    content  = tls_private_key.tls_emr_ssh_key.private_key_openssh
    filename = "${path.module}/keys/emr_ssh_key.pem"
    file_permission = "0400"
}


# Save the public key to a file
resource "local_file" "ssh_public_key" {
    content  = tls_private_key.tls_emr_ssh_key.public_key_openssh
    filename = "${path.module}/keys/emr_ssh_key.pub"
    file_permission = "0400"
}
