output "arn" {
  description = "The ARN of IAM Role"
  value       = aws_iam_role.ec2_iam_role.arn
}

output "unique_id" {
  description = "The ARN Unique ID of IAM Role"
  value       = aws_iam_role.ec2_iam_role.unique_id
}

output "profile_name" {
  description = "The Instance Profile Name"
  value       = aws_iam_instance_profile.iam_instance_profile.name
}