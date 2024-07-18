variable "vpc-id" {
  description = "the vpc id"
}

variable "vpc-public-subnet-id" {
  description = "the public subnet id"
  type        = list(string)
}

variable "instance-type" {
  description = "instance type for sequencer node"
  default     = "c5.2xlarge"
}

variable "eks-cluster-name" {
  description = "the eks cluster name you have deployed"
}

variable "k8s-ns-name" {
  description = "the kubernetes namespace you want to use"
  default     = "metis"
}

variable "eks-primary-security-group-id" {
  description = "the primary security group id of your eks, it will added to node group. if set as null, creation of node group will be failed."
}

variable "k8s-version" {
  default = "1.29"
}

variable "ami-type" {
  default = "BOTTLEROCKET_x86_64"
}

variable "ami-version" {
  default = "1.19.2-29cc92cc"
}

variable "k8s-eip-sa-name" {
  description = "the service account name for associating eip to your sequencer instance"
  default     = "eip"
}

variable "eks-node-role-arn" {
  description = "the role arn which you want to use on the eks node group, AmazonEKSWorkerNodePolicy and AmazonEC2ContainerRegistryReadOnly should be included at least"
}

variable "l2geth-node-group-labels" {
  description = "Kubernetes lables for l2geth instance"
  type        = any
  default     = {}
}

variable "l2geth-node-group-taint" {
  description = "Kubernetes taint for l2geth instance, refer to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group#taint-configuration-block"
  type        = any
  default = {
    "l2geth" : {
      effect = "NO_SCHEDULE"
      key    = "sequencer.metis.io"
      value  = "l2geth"
    }
  }
}

variable "themis-node-group-labels" {
  description = "Kubernetes lables for themis instance"
  type        = any
  default     = {}
}

variable "themis-node-group-taint" {
  description = "Kubernetes taints to be appied to themis instance, refer to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group#taint-configuration-block"
  type        = any
  default = {
    "themis" : {
      effect = "NO_SCHEDULE"
      key    = "sequencer.metis.io"
      value  = "themis"
    }
  }
}
