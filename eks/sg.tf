resource "aws_security_group" "eks_node" {
  name   = "${var.project_name}-eks-node"
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = "sg-${var.project_name}-${var.region}-node"
    },
    local.common_tags
  )
}

resource "aws_security_group" "eks_master" {
  name   = "${var.project_name}-eks-master"
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = "sg-${var.project_name}-${var.region}-master"
    },
    local.common_tags
  )
}

resource "aws_security_group_rule" "eks_node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_node.id
  source_security_group_id = aws_security_group.eks_node.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks_node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_node.id
  source_security_group_id = aws_security_group.eks_master.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_node.id
  source_security_group_id = aws_security_group.eks_master.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks_node-ingress-master" {
  description              = "Allow cluster control to receive communication from the worker Kubelets"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_master.id
  source_security_group_id = aws_security_group.eks_node.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_node.id
}
