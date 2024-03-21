resource "aws_eip" "sequencers" {
  count = 2
}

data "aws_iam_policy_document" "eip-association-policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_policy" "eip-association-policy" {
  name_prefix = "eip-association-policy"
  path        = "/"
  description = "Used for binding an eip to an EC2 instance"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:AssociateAddress",
          "ec2:DescribeAddresses",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeTags",
          "ec2:DisassociateAddress"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "eip-association-role" {
  name_prefix        = "metis-seq-eip-role"
  assume_role_policy = data.aws_iam_policy_document.eip-association-policy.json
}

resource "aws_iam_role_policy_attachment" "eip-association-role" {
  policy_arn = aws_iam_policy.eip-association-policy.arn
  role       = aws_iam_role.eip-association-role.name
}

resource "aws_eks_pod_identity_association" "eip" {
  cluster_name    = var.eks-cluster-name
  namespace       = var.k8s-ns-name
  service_account = var.k8s-eip-sa-name
  role_arn        = aws_iam_role.eip-association-role.arn
}
