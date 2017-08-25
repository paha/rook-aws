output "cluster_name" {
  value = "rookeval.storos.io"
}

output "region" {
  value = "us-west-2"
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-rookeval-storos-io.id}"]
}

output "masters_role_name" {
  value = "${aws_iam_role.masters-rookeval-storos-io.name}"
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-rookeval-storos-io.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.us-west-2b-rookeval-storos-io.id}"]
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-rookeval-storos-io.name}"
}

output "vpc_id" {
  value = "${aws_vpc.rookeval-storos-io.id}"
}
