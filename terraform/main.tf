# VPC Module
module "vpc" {
    source = "./modules/vpc"
    project_name = var.project_name
    environment = var.environment
    aws_region = var.aws_region
    vpc_cidr_block = var.vpc_cidr_block
}


# EMR Logs Bucket Module
module "emr_bucket" {
    source = "./modules/emr_bucket"
    project_name = var.project_name
    environment = var.environment
}


# EMR Module
module "emr" {
    source = "./modules/emr"
    project_name = var.project_name
    environment = var.environment
    vpc_id = module.vpc.vpc_id    
    public_subnet_ids = module.vpc.public_subnet_ids    
    emr_release_label = var.emr_release_label
    emr_applications = var.emr_applications
    emr_bucket_name = module.emr_bucket.emr_bucket_name
    main_instance_type = var.main_instance_type
    main_instance_count = var.main_instance_count
    core_instance_type = var.core_instance_type
    core_instance_count = var.core_instance_count
    core_instance_ebs_size = var.core_instance_ebs_size
    allowed_cidrs = var.allowed_cidrs
}