output "emr_ssh_key_pem" {
    value = module.emr.emr_ssh_key_pem
    sensitive = true
}

# EMR Cluster Master Public DNS
output "master_public_dns" {
  value = module.emr.master_public_dns
}
