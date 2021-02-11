output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_certificate" {
  value = base64decode(aws_eks_cluster.this.certificate_authority.0.data)
}

output "eks_worker_role" {
  value = aws_iam_role.eks_worker.name
}

output "eks_cluster_admin_role" {
  value = aws_iam_role.cluster-admin.name
}

output "eks_cluster_admin_group" {
  value = aws_iam_group.eks-admin.name
}

output "oidc" {
  description = "The OIDC provider attributes for IAM Role for ServiceAccount"
  value = zipmap(
    ["url", "arn"],
    [local.oidc["url"], local.oidc["arn"]]
  )
}

output "eks_node_sg" {
  value = aws_security_group.eks_node.id
}
