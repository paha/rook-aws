provider "aws" {
  region = "us-west-2"
}

terraform = {
  required_version = ">= 0.9.3"
}

variable "zone" {
  description = "Route53 hosted domain name."
  default     = "storos.io"
}

variable "key_name" {
  description = "AWS key pair name used for instances."
  default     = "castle-paha"
}

variable "cluster_name" {
  description = "Kube cluster name."
  default     = "rookeval"
}

variable "node_ami" {
  description = "AMI id to provision kube hosts."
  default     = "ami-0b415472"                    # Ubuntu 16.04 LTS, instance store.
}

variable "node_instance_type" {
  description = "EC2 instance type for kube hosts."
  default     = "c3.large"                          # vCPU - 2; mem - 3.75 GB; Store - 32 GB (2 * 16 GB SSD)
}

variable "node_count" {
  description = "Kube node count to deploy."
  default     = 3
}

variable "green_net" {
  description = "CIDR for inbound whitelisting."
  default     = "63.239.222.210/32"
}
