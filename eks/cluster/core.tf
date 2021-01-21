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
    security_group_ids      = var.security_groups
    endpoint_private_access = "true"
    endpoint_public_access  = "true"
  }
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.this.identity.0.oidc.0.issuer
}

data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity.0.oidc.0.issuer
}

data "aws_caller_identity" "current" {}
