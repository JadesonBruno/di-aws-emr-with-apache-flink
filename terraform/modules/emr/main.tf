# EMR Cluster Resource
resource "aws_emr_cluster" "emr_cluster" {
    name = "${var.project_name}-${var.environment}-emr-cluster"
    release_label = var.emr_release_label
    applications = var.emr_applications
    service_role = aws_iam_role.emr_service_role.arn
    log_uri = "s3://${var.emr_bucket_name}/logs/"

    auto_termination_policy {
        idle_timeout = 3600  // Auto-terminate after 1 hour of inactivity
    }

    configurations = jsonencode(
        [
            {
                "Classification" = "flink-conf",
                "Properties" = {
                    "parallelism.default" = "4",
                    "taskmanager.numberOfTaskSlots" = "2",
                    "taskmanager.memory.process.size" = "2G",
                    "jobmanager.memory.process.size" = "1G",
                    "execution.checkpointing.interval" = "180000",
                    "execution.checkpointing.mode" = "EXACTLY_ONCE"
                }
            }
        ]
    )

    master_instance_group {
        instance_type = var.main_instance_type
        instance_count = var.main_instance_count
    }

    core_instance_group {
        instance_type = var.core_instance_type
        instance_count = var.core_instance_count
        ebs_config {
            size = var.core_instance_ebs_size
            type = "gp2"
            volumes_per_instance = 1
        }
    }

    ec2_attributes {
        key_name = aws_key_pair.emr_ssh_key.key_name
        subnet_id = var.public_subnet_ids[0]
        instance_profile = aws_iam_instance_profile.emr_instance_profile.arn
        emr_managed_master_security_group = aws_security_group.master_security_group.id
        emr_managed_slave_security_group = aws_security_group.slave_security_group.id
    }

    step = [ 
        {
            name = "wordcount"
            action_on_failure = "TERMINATE_CLUSTER"
            hadoop_jar_step = {
                jar = "command-runner.jar"
                args = [
                    "flink",
                    "run",
                    "-m",
                    "yarn-cluster",
                    "/usr/lib/flink/examples/streaming/WordCount.jar",
                    "--input",
                    "s3a://${var.emr_bucket_name}/data/inputs/words.txt",
                    "--output",
                    "s3://${var.emr_bucket_name}/data/outputs/wordcount/"
                ]
            }
        }
    ]

    lifecycle {
        ignore_changes = [step]  // Ignore changes to steps to prevent recreation of the cluster
    }

    tags = {
        "Name" = "${var.project_name}-${var.environment}-emr-cluster"
        "Project" = var.project_name
        "Environment" = var.environment
        "Service" = "emr"
        "Terraform" = "true"
    }
}
