# Private Key Output
output "emr_ssh_key_pem" {
    value = tls_private_key.tls_emr_ssh_key.private_key_openssh
    description = "The PEM file for the EMR SSH key"
    sensitive = true
}

# EMR Cluster Master Public DNS
output "master_public_dns" {
  value = aws_emr_cluster.emr_cluster.master_public_dns
  description = "The public DNS of the EMR cluster master node"
}
