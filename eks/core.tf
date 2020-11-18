locals {
  common_tags = var.common_tags
}

resource "aws_eks_cluster" "this" {
  name     = "eks-${var.project_name}"
  role_arn = aws_iam_role.eks_master.arn

  tags = merge(
    {
      Name = "eks-${var.project_name}-${var.region}-master"
    },
    local.common_tags
  )

  vpc_config {
    subnet_ids              = var.cluster_subnets
    security_group_ids      = [aws_security_group.eks_master.id]
    endpoint_private_access = "true"
    endpoint_public_access  = "true"
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy
  ]
}

locals {
  eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.this.endpoint}' --b64-cluster-ca '${aws_eks_cluster.this.certificate_authority.0.data}' 'eks-${var.project_name}'
USERDATA
}

resource "aws_launch_template" "this" {
  image_id      = var.image_id
  instance_type = var.instance_type
  # key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.eks_node.id]
  user_data              = base64encode(local.eks-node-userdata)

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project_name}-workers"
  node_role_arn   = aws_iam_role.eks_worker.arn
  subnet_ids      = var.workers_subnets

  scaling_config {
    desired_size = 3
    min_size     = 3
    max_size     = 6
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-worker-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-worker-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-worker-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.alb-work-node,
    aws_iam_role_policy_attachment.eks-worker-CloudWatchAgentServerPolicy,
    aws_iam_instance_profile.node,

  ]
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.this.identity.0.oidc.0.issuer
}

data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity.0.oidc.0.issuer
}
