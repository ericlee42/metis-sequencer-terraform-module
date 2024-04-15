resource "aws_security_group" "sequencer" {
  name        = "metis-sequencer-sg"
  description = "Allow P2P connections between sequencers"
  vpc_id      = var.vpc-id
}

resource "aws_vpc_security_group_ingress_rule" "l2geth-p2p-udp" {
  security_group_id = aws_security_group.sequencer.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 30303
  ip_protocol       = "udp"
  to_port           = 30303
}

resource "aws_vpc_security_group_ingress_rule" "sequencer-self" {
  description                  = "Allow access within sequencer instances"
  security_group_id            = aws_security_group.sequencer.id
  referenced_security_group_id = aws_security_group.sequencer.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "l2geth-p2p-tcp" {
  security_group_id = aws_security_group.sequencer.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 30303
  ip_protocol       = "tcp"
  to_port           = 30303
}

resource "aws_vpc_security_group_ingress_rule" "themis-p2p-tcp" {
  security_group_id = aws_security_group.sequencer.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 26656
  ip_protocol       = "tcp"
  to_port           = 26656
}

resource "aws_vpc_security_group_egress_rule" "sequencer-output" {
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.sequencer.id
}
