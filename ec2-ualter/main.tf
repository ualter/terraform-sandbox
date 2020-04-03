

locals {
  allTags = "${merge("${var.tags}",map("Enviroment","${var.environment}"))}"
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

resource "aws_vpc" "infra" {
  cidr_block = "10.1.0.0/24"
  tags = "${merge(map("Name","vpc-infra"),"${local.allTags}")}"
}

resource "aws_subnet" "infra_subnet" {
  vpc_id = "${aws_vpc.infra.id}"
  cidr_block = "10.1.0.0/27"
  tags = "${merge(map("Name","subnet-infra"),"${local.allTags}")}"
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.linux.id}"
  instance_type = "t2.micro"
  count = 2
  subnet_id = "${aws_subnet.infra_subnet.id}"

  tags = "${local.allTags}"
}

output "vpc_id" {
  value = "${aws_vpc.infra.id}"
}
