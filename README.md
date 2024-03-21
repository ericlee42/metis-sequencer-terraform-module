# Metis Sequencer Terraform Module

We don't want to make this module very complex, so this module just does:

1. create two EIPs for l2geth(metis execution client) and themis(metis consensus client)
2. create eip-association role
3. create two node groups and necessary security grup rules for them

You need to have an aws eks first.

The following add-on plugins should be enabled:

1. aws vpc-cni, you should use IRSA instead of ec2 role for it.
2. aws pod identity agent
3. aws ebs csi and snapshot controller(Not for this module, but required for deployment)

By default, we use 1.29 k8s and Bottlerocket ami.

We don't have remote access for the node groups since it's not safe and necessary.

If you actually need it, you can use aws ssm instead, to achieve that, you will have to add `AmazonSSMManagedInstanceCore` policy to your node group role.

This module has not undergone too much testing, if you have any question and feadback, please file a new issue on github, and pull request is always welcome.
