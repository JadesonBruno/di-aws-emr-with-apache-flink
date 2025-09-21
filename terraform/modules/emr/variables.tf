# Global Variables
variable "project_name" {
    description = "The name of the project"
    type = string
}

variable "environment" {
    description = "The deployment environment (e.g., dev, staging, prod)"
    type = string
    default = "dev"

    validation {
        condition = contains(["dev", "staging", "prod"], var.environment)
        error_message = "Environment must be one of 'dev', 'staging', or 'prod'."
    }
}


# VPC Module Variables
variable "vpc_id" {
    description = "The ID of the VPC"
    type = string
}


# EMR Bucket Variables
variable "emr_bucket_name" {
    description = "The name of the S3 bucket for EMR"
    type = string
}


# EMR Module Variables
variable "emr_release_label" {
    description = "The EMR release label"
    type = string
    default = "emr-7.10.0"
}

variable "emr_applications" {
    description = "The EMR applications to install"
    type = list(string)
    default = ["flink", "hadoop", "hive", "zeppelin"]
}

variable "main_instance_type" {
    description = "The EC2 instance type for the EMR master node"
    type = string
    default = "m5.xlarge"
}

variable "main_instance_count" {
    description = "The number of EC2 instances for the EMR master node"
    type = number
    default = 1
}

variable "core_instance_type" {
    description = "The EC2 instance type for the EMR core nodes"
    type = string
    default = "m5.xlarge"
}

variable "core_instance_count" {
    description = "The number of EC2 instances for the EMR core nodes"
    type = number
    default = 2
}

variable "core_instance_ebs_size" {
    description = "The EBS volume size (in GB) for each core node"
    type = number
    default = 80
}

variable "public_subnet_ids" {
    description = "List of public subnet IDs"
    type = list(string)
}

variable "allowed_cidrs" {
    description = "List of CIDR blocks allowed to access the EMR cluster"
    type = list(string)
}
