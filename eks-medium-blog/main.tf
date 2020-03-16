provider "aws" {
  region = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

## Kubernetes EIPs
resource "aws_eip" "nat" {
  count = 3
  vpc   = true
}
# VPC Installation
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "${var.environment}-${var.application_slug}"
  cidr = "${var.vpc_cidr}"
  azs             = "${var.az_list}"
  private_subnets = "${var.private_subnet_cidr_list}"
  public_subnets  = "${var.public_subnet_cidr_list}"
  enable_nat_gateway  = true
  reuse_nat_ips       = true
  external_nat_ip_ids = ["${aws_eip.nat.*.id}"]
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = "${var.tags}"
}