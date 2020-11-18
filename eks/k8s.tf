locals {
  map_roles = <<EOF
- rolearn: ${aws_iam_role.eks_worker.arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
- rolearn: ${aws_iam_role.cluster-admin.arn}
  username: adminuser:{{SessionName}}
  groups:
   - system:masters
EOF
}

provider "kubernetes" {
  host                   = aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
  version                = "~> 1.9"
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth-terraform"
    namespace = "kube-system"
  }

  data = {
    mapRoles = local.map_roles
    # mapUsers = yamlencode(var.map_users)
  }

  depends_on = [aws_eks_cluster.this]
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}
