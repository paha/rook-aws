resource "aws_internet_gateway" "rookeval-storos-io" {
  vpc_id = "${aws_vpc.rookeval-storos-io.id}"

  tags = {
    KubernetesCluster = "rookeval.storos.io"
    Name              = "rookeval.storos.io"
  }
}

resource "aws_route" "0-0-0-0--0" {
  route_table_id         = "${aws_route_table.rookeval-storos-io.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.rookeval-storos-io.id}"
}

resource "aws_route_table" "rookeval-storos-io" {
  vpc_id = "${aws_vpc.rookeval-storos-io.id}"

  tags = {
    KubernetesCluster = "rookeval.storos.io"
    Name              = "rookeval.storos.io"
  }
}

resource "aws_route_table_association" "us-west-2b-rookeval-storos-io" {
  subnet_id      = "${aws_subnet.us-west-2b-rookeval-storos-io.id}"
  route_table_id = "${aws_route_table.rookeval-storos-io.id}"
}

resource "aws_security_group" "masters-rookeval-storos-io" {
  name        = "masters.rookeval.storos.io"
  vpc_id      = "${aws_vpc.rookeval-storos-io.id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster = "rookeval.storos.io"
    Name              = "masters.rookeval.storos.io"
  }
}

resource "aws_security_group" "nodes-rookeval-storos-io" {
  name        = "nodes.rookeval.storos.io"
  vpc_id      = "${aws_vpc.rookeval-storos-io.id}"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster = "rookeval.storos.io"
    Name              = "nodes.rookeval.storos.io"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-rookeval-storos-io.id}"
  source_security_group_id = "${aws_security_group.masters-rookeval-storos-io.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-rookeval-storos-io.id}"
  source_security_group_id = "${aws_security_group.masters-rookeval-storos-io.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-rookeval-storos-io.id}"
  source_security_group_id = "${aws_security_group.nodes-rookeval-storos-io.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "https-external-to-master-63-239-222-210--32" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-rookeval-storos-io.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["${var.green_net}"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-rookeval-storos-io.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-rookeval-storos-io.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-rookeval-storos-io.id}"
  source_security_group_id = "${aws_security_group.nodes-rookeval-storos-io.id}"
  from_port                = 1
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-rookeval-storos-io.id}"
  source_security_group_id = "${aws_security_group.nodes-rookeval-storos-io.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-rookeval-storos-io.id}"
  source_security_group_id = "${aws_security_group.nodes-rookeval-storos-io.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-63-239-222-210--32" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-rookeval-storos-io.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.green_net}"]
}

resource "aws_security_group_rule" "ssh-external-to-node-63-239-222-210--32" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-rookeval-storos-io.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.green_net}"]
}

resource "aws_subnet" "us-west-2b-rookeval-storos-io" {
  vpc_id            = "${aws_vpc.rookeval-storos-io.id}"
  cidr_block        = "172.20.32.0/19"
  availability_zone = "us-west-2b"

  tags = {
    KubernetesCluster                          = "rookeval.storos.io"
    Name                                       = "us-west-2b.rookeval.storos.io"
    "kubernetes.io/cluster/rookeval.storos.io" = "owned"
  }
}

resource "aws_vpc" "rookeval-storos-io" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster                          = "rookeval.storos.io"
    Name                                       = "rookeval.storos.io"
    "kubernetes.io/cluster/rookeval.storos.io" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "rookeval-storos-io" {
  domain_name         = "us-west-2.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster = "rookeval.storos.io"
    Name              = "rookeval.storos.io"
  }
}

resource "aws_vpc_dhcp_options_association" "rookeval-storos-io" {
  vpc_id          = "${aws_vpc.rookeval-storos-io.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.rookeval-storos-io.id}"
}
