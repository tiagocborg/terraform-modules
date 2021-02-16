output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}

output "cluster_certificate" {
  value = base64decode(aws_eks_cluster.this.certificate_authority.0.data)
}

output "oidc" {
  description = "The OIDC provider attributes for IAM Role for ServiceAccount"
  value = zipmap(
    ["url", "arn"],
    [local.oidc["url"], local.oidc["arn"]]
  )
}