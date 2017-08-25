resource "aws_autoscaling_group" "nodes-rookeval-storos-io" {
  name                 = "nodes.rookeval.storos.io"
  launch_configuration = "${aws_launch_configuration.nodes-rookeval-storos-io.id}"
  max_size             = "${var.node_count}"
  min_size             = "${var.node_count}"
  vpc_zone_identifier  = ["${aws_subnet.us-west-2b-rookeval-storos-io.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "rookeval.storos.io"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.rookeval.storos.io"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_iam_instance_profile" "nodes-rookeval-storos-io" {
  name = "nodes.rookeval.storos.io"
  role = "${aws_iam_role.nodes-rookeval-storos-io.name}"
}

resource "aws_iam_role" "nodes-rookeval-storos-io" {
  name               = "nodes.rookeval.storos.io"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.rookeval.storos.io_policy")}"
}

resource "aws_iam_role_policy" "nodes-rookeval-storos-io" {
  name   = "nodes.rookeval.storos.io"
  role   = "${aws_iam_role.nodes-rookeval-storos-io.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.rookeval.storos.io_policy")}"
}

resource "aws_launch_configuration" "nodes-rookeval-storos-io" {
  name_prefix                 = "nodes.rookeval.storos.io-"
  image_id                    = "${var.node_ami}"
  instance_type               = "${var.node_instance_type}"
  key_name                    = "${var.key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-rookeval-storos-io.id}"
  security_groups             = ["${aws_security_group.nodes-rookeval-storos-io.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.rookeval.storos.io_user_data")}"

  lifecycle = {
    create_before_destroy = true
  }
}
