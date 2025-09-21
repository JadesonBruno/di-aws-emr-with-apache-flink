output "emr_ssh_key_pem" {
    value = module.emr.emr_ssh_key_pem
    sensitive = true
}

# EMR Cluster Master Public DNS
output "emr_master_address" {
  value = aws_emr_cluster.emr_cluster.master_public_dns
}
