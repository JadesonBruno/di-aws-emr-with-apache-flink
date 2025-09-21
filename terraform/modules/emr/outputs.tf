# Private Key Output
output "emr_ssh_key_pem" {
    value = tls_private_key.tls_emr_ssh_key.private_key_openssh
    sensitive = true
}

# EMR Cluster Master Public DNS
output "emr_master_address" {
  value = aws_emr_cluster.emr_cluster.master_public_dns
}
