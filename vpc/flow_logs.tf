resource "aws_flow_log" "this" {
  count           = var.enable_flow_logs ? 1 : 0
  iam_role_arn    = aws_iam_role.this.0.arn
  log_destination = aws_cloudwatch_log_group.this.0.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id
  tags            = local.common_tags
}

resource "aws_cloudwatch_log_group" "this" {
  count             = var.enable_flow_logs ? 1 : 0
  name              = "${var.project_name}-flow-logs"
  retention_in_days = 30
  tags              = local.common_tags
}

resource "aws_iam_role" "this" {
  count              = var.enable_flow_logs ? 1 : 0
  name               = "${var.project_name}-flow-logs"
  tags               = local.common_tags
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "this" {
  count  = var.enable_flow_logs ? 1 : 0
  name   = "${var.project_name}-flow-logs"
  role   = aws_iam_role.this.0.id
  tags   = local.common_tags
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
