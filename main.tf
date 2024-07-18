

resource "aws_launch_template" "sequencer" {
  name_prefix = "metis-sequencer"

  vpc_security_group_ids = compact(concat([aws_security_group.sequencer.id], [var.eks-primary-security-group-id]))

  metadata_options {
    // Don't allow containers use Metadata service
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
  }

  monitoring {
    enabled = true
  }
}

# We don't allow remote access
# If you need it please use aws ssm instead

resource "aws_eks_node_group" "l2geth" {
  cluster_name           = var.eks-cluster-name
  node_role_arn          = var.eks-node-role-arn
  node_group_name_prefix = "metis-sequencer-l2geth"

  subnet_ids    = var.vpc-public-subnet-id
  labels        = var.l2geth-node-group-labels
  capacity_type = "ON_DEMAND"

  version         = var.k8s-version
  ami_type        = var.ami-type
  instance_types = [var.instance-type]

  # the default is 20, that's should enough
  # disk_size = 20

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  launch_template {
    id      = aws_launch_template.sequencer.id
    version = aws_launch_template.sequencer.latest_version
  }

  update_config {
    max_unavailable = 1
  }

  dynamic "taint" {
    for_each = var.l2geth-node-group-taint

    content {
      key    = taint.value.key
      value  = try(taint.value.value, null)
      effect = taint.value.effect
    }
  }

  tags = {
    "Name" = "metis-l2geth"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eks_node_group" "themis" {
  cluster_name           = var.eks-cluster-name
  node_role_arn          = var.eks-node-role-arn
  node_group_name_prefix = "metis-sequencer-themis"

  subnet_ids    = var.vpc-public-subnet-id
  labels        = var.themis-node-group-labels
  capacity_type = "ON_DEMAND"

  version         = var.k8s-version
  ami_type        = var.ami-type
  instance_types = [var.instance-type]

  # the default is 20, that's should enough
  # disk_size = 20

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  launch_template {
    id      = aws_launch_template.sequencer.id
    version = aws_launch_template.sequencer.latest_version
  }

  update_config {
    max_unavailable = 1
  }

  dynamic "taint" {
    for_each = var.themis-node-group-taint

    content {
      key    = taint.value.key
      value  = try(taint.value.value, null)
      effect = taint.value.effect
    }
  }

  tags = {
    "Name" = "metis-themis"
  }

  lifecycle {
    create_before_destroy = true
  }
}
