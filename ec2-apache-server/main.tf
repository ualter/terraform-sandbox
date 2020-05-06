locals {
  allTags = "${var.tags}"
}


data "aws_ami" "linux" {
  filter {
    name   = "image-id"
    values = ["${var.aws_image_id}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags       = "${merge("${local.allTags}",map("Name","VPC-PoC"),map("Environment","POC"))}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags   = "${merge("${local.allTags}",map("Name","Gw-PoC"),map("Environment","POC"))}"
}

resource "aws_route_table" "routeTable" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  #route {
  #  ipv6_cidr_block        = "::/0"
  #  egress_only_gateway_id = "${aws_egress_only_internet_gateway.foo.id}"
  #}

  tags   = "${merge("${local.allTags}",map("Name","Rt-PoC"),map("Environment","POC"))}"
}

resource "aws_subnet" "subnet1" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.1.0/24"
  tags       = "${merge("${local.allTags}",map("Name","Subnet1-PoC"),map("Environment","POC"))}"
}

resource "aws_route_table_association" "a1" {
  subnet_id      = "${aws_subnet.subnet1.id}"
  route_table_id = "${aws_route_table.routeTable.id}"
}

resource "aws_security_group" "sggroup" {
  name        = "Security Group PoC"
  description = "Security Group PoC"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    description = "Allow incoming SSH Connection"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow incoming HTTP Connection"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge("${local.allTags}",map("Name","SgGroup-PoC"),map("Environment","POC"))}"
}

resource "aws_instance" "ec2" {
  ami                  = "${data.aws_ami.linux.id}"
  instance_type        = "t2.micro"
  count                = 1
  subnet_id            = "${aws_subnet.subnet1.id}"
  security_groups      = ["${aws_security_group.sggroup.id}"]
  key_name             = "eu-central-1-Administrator"
  user_data_base64     = "${base64encode(var.aws_linux_user_data)}"
  #iam_instance_profile = "${aws_iam_instance_profile.UJR_SSMRoleForEC2Instances.name}"
  associate_public_ip_address = true
  depends_on           = ["aws_internet_gateway.gw"]
  tags                 = "${merge("${local.allTags}",map("Environment","POC"))}"
}


#output "vpc_id" {
#  value = "${aws_vpc.infra.id}"
#}
