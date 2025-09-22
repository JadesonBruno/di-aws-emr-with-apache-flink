# IAM Role for EMR Cluster
resource "aws_iam_role" "emr_service_role" {
    name = "${var.project_name}-${var.environment}-emr-service-role"
    description = "EMR Role for emr service"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Effect = "Allow"
            Principal = {
            Service = "elasticmapreduce.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        },
        ]
    })

    tags = {
        Name = "${var.project_name}-${var.environment}-emr-service-role"
        Project = var.project_name
        Environment = var.environment
        Service = "emr"
        Terraform = "true"
    }
}


# IAM Role Policy Attachment for EMR Cluster
resource "aws_iam_role_policy_attachment" "emr_service_policy_attachment" {
    role = aws_iam_role.emr_service_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}


# IAM Role for EMR EC2 Instances
resource "aws_iam_role" "emr_profile_role" {
    name = "${var.project_name}-${var.environment}-emr-profile-role"
    description = "EMR Role for emr profile"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Effect = "Allow"
            Principal = {
            Service = "ec2.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        },
        ]
    })
}


# IAM Role Policy Attachment for EMR EC2 Instances
resource "aws_iam_role_policy_attachment" "emr_profile_policy_attachment" {
    role = aws_iam_role.emr_profile_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}


# IAM Instance Profile for EMR EC2 Instances
resource "aws_iam_instance_profile" "emr_instance_profile" {
    name = "${var.project_name}-${var.environment}-emr-instance-profile"
    role = aws_iam_role.emr_profile_role.name
}
