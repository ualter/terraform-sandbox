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

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.linux.id}"
  instance_type = "t2.micro"

  tags = var.tags
}