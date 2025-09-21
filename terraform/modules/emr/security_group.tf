# Master Security Group
resource "aws_security_group" "master_security_group" {
    name = "${var.project_name}-${var.environment}-master-security-group"
    description = "Security group for EMR cluster"
    vpc_id = var.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.allowed_cidrs
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    revoke_rules_on_delete = true

    tags = {
        Name = "${var.project_name}-${var.environment}-master-security-group"
        Project = var.project_name
        Environment = var.environment
        Service = "emr"
        Terraform = "true"
    }
}


# Core Security Group
resource "aws_security_group" "slave_security_group" {
    name = "${var.project_name}-${var.environment}-slave-security-group"
    description = "Security group for EMR core nodes"
    vpc_id = var.vpc_id

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        security_groups = [aws_security_group.master_security_group.id]
    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}-${var.environment}-slave-security-group"
        Project = var.project_name
        Environment = var.environment
        Service = "emr"
        Terraform = "true"
    }
}