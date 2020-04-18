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

resource "aws_instance" "prod" {
  ami           = "${data.aws_ami.linux.id}"
  instance_type = "t2.micro"
  count = 1

  key_name = "eu-central-1-Administrator"

  user_data_base64 = "${base64encode(var.aws_linux_user_data)}"

  iam_instance_profile = "${aws_iam_instance_profile.UJR_SSMRoleForEC2Instances.name}"

  tags = "${merge("${local.allTags}",map("Enviroment","PROD"))}"
}

#resource "aws_instance" "dev" {
#  ami           = "${data.aws_ami.linux.id}"
#  instance_type = "t2.micro"
#  count = 1
#
#  tags = "${merge("${local.allTags}",map("Enviroment","DEV"))}"
#}

#output "vpc_id" {
#  value = "${aws_vpc.infra.id}"
#}
