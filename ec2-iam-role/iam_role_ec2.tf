#Instance Role
resource "aws_iam_role" "ec2_iam_role" {
  name = "${var.role_name}-role-ec2"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  /* tags = {
    Name = "test-policy"
    createdBy = "rtp"
    Owner = "DevSecOps"
    Project = "test-terraform"
    environment = "test"
  } */
}

#Instance Profile
resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "${var.role_name}-profile"
  role = aws_iam_role.ec2_iam_role.id
}

#Attach Policies to Instance Role
resource "aws_iam_policy_attachment" "policy_attach" {
  count      = length(var.policies)
  name       = "${var.role_name}-policy-attachment-${count.index}"
  roles      = [aws_iam_role.ec2_iam_role.id]
  policy_arn = "arn:aws:iam::aws:policy/${element(var.policies, count.index)}"
  depends_on = [aws_iam_role.ec2_iam_role]
}


