output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_certificate" {
  value = base64decode(aws_eks_cluster.this.certificate_authority.0.data)
}

# output "eks_worker_role" {
#   value = aws_iam_role.eks_worker.arn
# }

# output "eks_cluster_admin_role" {
#   value = aws_iam_role.cluster-admin.name
# }

