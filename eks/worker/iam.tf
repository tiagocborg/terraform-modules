# ######################################################
# # Setup IAM role & instance profile for worker nodes #
# ######################################################

# resource "aws_iam_role" "eks_worker" {
#   name               = "eks-${var.project_name}-worker-role"
#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_policy" "external-dns" {
#   name        = "eks-${var.project_name}-external-dns-policy"
#   path        = "/"
#   description = "Policy for External dns Ingress"

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "route53:ListHostedZones",
#         "route53:ListResourceRecordSets",
#         "route53:ChangeResourceRecordSets"
#       ],
#       "Resource": "*"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_policy" "alb" {
#   name        = "${var.cluster_name}-alb-ingress-policy-policy"
#   path        = "/"
#   description = "Policy for ALB EKS Ingress"

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "acm:DescribeCertificate",
#         "acm:ListCertificates",
#         "acm:GetCertificate"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "ec2:AuthorizeSecurityGroupIngress",
#         "ec2:CreateSecurityGroup",
#         "ec2:CreateTags",
#         "ec2:DeleteTags",
#         "ec2:DeleteSecurityGroup",
#         "ec2:DescribeAccountAttributes",
#         "ec2:DescribeAddresses",
#         "ec2:DescribeInstances",
#         "ec2:DescribeInstanceStatus",
#         "ec2:DescribeInternetGateways",
#         "ec2:DescribeNetworkInterfaces",
#         "ec2:DescribeSecurityGroups",
#         "ec2:DescribeSubnets",
#         "ec2:DescribeTags",
#         "ec2:DescribeVpcs",
#         "ec2:ModifyInstanceAttribute",
#         "ec2:ModifyNetworkInterfaceAttribute",
#         "ec2:RevokeSecurityGroupIngress"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "elasticloadbalancing:AddListenerCertificates",
#         "elasticloadbalancing:AddTags",
#         "elasticloadbalancing:CreateListener",
#         "elasticloadbalancing:CreateLoadBalancer",
#         "elasticloadbalancing:CreateRule",
#         "elasticloadbalancing:CreateTargetGroup",
#         "elasticloadbalancing:DeleteListener",
#         "elasticloadbalancing:DeleteLoadBalancer",
#         "elasticloadbalancing:DeleteRule",
#         "elasticloadbalancing:DeleteTargetGroup",
#         "elasticloadbalancing:DeregisterTargets",
#         "elasticloadbalancing:DescribeListenerCertificates",
#         "elasticloadbalancing:DescribeListeners",
#         "elasticloadbalancing:DescribeLoadBalancers",
#         "elasticloadbalancing:DescribeLoadBalancerAttributes",
#         "elasticloadbalancing:DescribeRules",
#         "elasticloadbalancing:DescribeSSLPolicies",
#         "elasticloadbalancing:DescribeTags",
#         "elasticloadbalancing:DescribeTargetGroups",
#         "elasticloadbalancing:DescribeTargetGroupAttributes",
#         "elasticloadbalancing:DescribeTargetHealth",
#         "elasticloadbalancing:ModifyListener",
#         "elasticloadbalancing:ModifyLoadBalancerAttributes",
#         "elasticloadbalancing:ModifyRule",
#         "elasticloadbalancing:ModifyTargetGroup",
#         "elasticloadbalancing:ModifyTargetGroupAttributes",
#         "elasticloadbalancing:RegisterTargets",
#         "elasticloadbalancing:RemoveListenerCertificates",
#         "elasticloadbalancing:RemoveTags",
#         "elasticloadbalancing:SetIpAddressType",
#         "elasticloadbalancing:SetSecurityGroups",
#         "elasticloadbalancing:SetSubnets",
#         "elasticloadbalancing:SetWebAcl"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "iam:CreateServiceLinkedRole",
#         "iam:GetServerCertificate",
#         "iam:ListServerCertificates"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "cognito-idp:DescribeUserPoolClient"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "waf-regional:GetWebACLForResource",
#         "waf-regional:GetWebACL",
#         "waf-regional:AssociateWebACL",
#         "waf-regional:DisassociateWebACL"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "tag:GetResources",
#         "tag:TagResources"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "waf:GetWebACL"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "wafv2:GetWebACL",
#         "wafv2:GetWebACLForResource",
#         "wafv2:AssociateWebACL",
#         "wafv2:DisassociateWebACL"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "shield:DescribeProtection",
#         "shield:GetSubscriptionState",
#         "shield:DeleteProtection",
#         "shield:CreateProtection",
#         "shield:DescribeSubscription",
#         "shield:ListProtections"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "secretsmanager:GetRandomPassword",
#         "secretsmanager:GetResourcePolicy",
#         "secretsmanager:GetSecretValue",
#         "secretsmanager:DescribeSecret",
#         "secretsmanager:ListSecretVersionIds",
#         "secretsmanager:ListSecrets"
#       ],
#       "Resource": "*"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_role_policy_attachment" "eks-worker-AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.eks_worker.name
# }

# resource "aws_iam_role_policy_attachment" "eks-worker-AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.eks_worker.name
# }

# resource "aws_iam_role_policy_attachment" "eks-worker-AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.eks_worker.name
# }

# resource "aws_iam_instance_profile" "node" {
#   name = "eks-${var.project_name}worker-profile"
#   role = aws_iam_role.eks_worker.name
# }

# resource "aws_iam_role_policy_attachment" "alb-oidc" {
#   policy_arn = aws_iam_policy.alb.arn
#   role       = aws_iam_role.alb.name
# }

# resource "aws_iam_role_policy_attachment" "alb-work-node" {
#   policy_arn = aws_iam_policy.alb.arn
#   role       = aws_iam_role.eks_worker.name
# }

# resource "aws_iam_role_policy_attachment" "external-dns-work-node" {
#   policy_arn = aws_iam_policy.external-dns.arn
#   role       = aws_iam_role.eks_worker.name
# }

# resource "aws_iam_role_policy_attachment" "eks-worker-CloudWatchAgentServerPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
#   role       = aws_iam_role.eks_worker.name
# }

# resource "aws_iam_role" "alb" {
#   assume_role_policy = data.aws_iam_policy_document.eks-auth.json
#   name               = "${var.project_name}-eks-auth-oidc"
# }

# data "aws_iam_policy_document" "eks-auth" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     condition {
#       test     = "ForAnyValue:StringEquals"
#       variable = "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
#       values = [
#         "system:serviceaccount:kube-system:aws-node",
#         "system:serviceaccount:kube-system:aws-load-balancer-controller",
#       "system:serviceaccount:aws-load-balancer-controller:aws-load-balancer-controller"]
#     }

#     principals {
#       identifiers = [aws_iam_openid_connect_provider.this.arn]
#       type        = "Federated"
#     }
#   }
# }

# resource "aws_iam_openid_connect_provider" "this" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.this.certificates.0.sha1_fingerprint]
#   url             = data.aws_eks_cluster.this.identity.0.oidc.0.issuer
# }

# data "tls_certificate" "this" {
#   url = data.aws_eks_cluster.this.identity.0.oidc.0.issuer
# }

# data "aws_eks_cluster" "this" {
#   name = var.cluster_name
# }
