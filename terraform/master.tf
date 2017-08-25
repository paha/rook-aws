resource "aws_autoscaling_group" "master-us-west-2b-masters-rookeval-storos-io" {
  name                 = "master-us-west-2b.masters.rookeval.storos.io"
  launch_configuration = "${aws_launch_configuration.master-us-west-2b-masters-rookeval-storos-io.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.us-west-2b-rookeval-storos-io.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "rookeval.storos.io"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-west-2b.masters.rookeval.storos.io"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_ebs_volume" "b-etcd-events-rookeval-storos-io" {
  availability_zone = "us-west-2b"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "rookeval.storos.io"
    Name                 = "b.etcd-events.rookeval.storos.io"
    "k8s.io/etcd/events" = "b/b"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "b-etcd-main-rookeval-storos-io" {
  availability_zone = "us-west-2b"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "rookeval.storos.io"
    Name                 = "b.etcd-main.rookeval.storos.io"
    "k8s.io/etcd/main"   = "b/b"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_iam_instance_profile" "masters-rookeval-storos-io" {
  name = "masters.rookeval.storos.io"
  role = "${aws_iam_role.masters-rookeval-storos-io.name}"
}

resource "aws_iam_role" "masters-rookeval-storos-io" {
  name               = "masters.rookeval.storos.io"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.rookeval.storos.io_policy")}"
}

resource "aws_iam_role_policy" "masters-rookeval-storos-io" {
  name   = "masters.rookeval.storos.io"
  role   = "${aws_iam_role.masters-rookeval-storos-io.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.rookeval.storos.io_policy")}"
}

resource "aws_launch_configuration" "master-us-west-2b-masters-rookeval-storos-io" {
  name_prefix                 = "master-us-west-2b.masters.rookeval.storos.io-"
  image_id                    = "ami-2606e05e"
  instance_type               = "m3.medium"
  key_name                    = "castle-paha"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-rookeval-storos-io.id}"
  security_groups             = ["${aws_security_group.masters-rookeval-storos-io.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-west-2b.masters.rookeval.storos.io_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  ephemeral_block_device = {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }

  lifecycle = {
    create_before_destroy = true
  }
}
