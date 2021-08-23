locals {
  common_tags = var.common_tags
}

locals {
  eks-node-userdata = <<USERDATA
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
rm -rf /etc/cron.d/ssmstart
set -ex
B64_CLUSTER_CA=${data.aws_eks_cluster.this.certificate_authority.0.data}
API_SERVER_URL=${data.aws_eks_cluster.this.endpoint}
K8S_CLUSTER_DNS_IP=172.20.0.10
/etc/eks/bootstrap.sh ${var.cluster_name} --use-max-pods '${var.use_max_pods ? "true" : "false"}' --b64-cluster-ca $B64_CLUSTER_CA --apiserver-endpoint $API_SERVER_URL --dns-cluster-ip $K8S_CLUSTER_DNS_IP

--==MYBOUNDARY==--
USERDATA
}

resource "aws_launch_template" "this" {
  image_id               = var.image_id
  vpc_security_group_ids = var.security_groups
  user_data              = base64encode(local.eks-node-userdata)
  name                   = var.worker_group_name
  key_name               = var.key_name
  tag_specifications {
    resource_type = "instance"

    tags = merge(
      {
        Name = var.worker_group_name
      },
      local.common_tags
    )
  }

  dynamic "block_device_mappings" {
    for_each = var.volume_size[*]

    content {
      device_name = "/dev/xvda"

      ebs {
        volume_size           = block_device_mappings.value
        volume_type           = "gp2"
        delete_on_termination = true
      }
    }
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = var.worker_group_name
  node_role_arn   = var.worker_role
  subnet_ids      = var.workers_subnets
  labels          = var.labels
  capacity_type   = var.capacity_type
  instance_types  = var.instance_types

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }

  scaling_config {
    desired_size = lookup(var.scaling_config, "desired")
    min_size     = lookup(var.scaling_config, "min")
    max_size     = lookup(var.scaling_config, "max")
  }

  # lifecycle {
  #   create_before_destroy = true
  # }

}
data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}
