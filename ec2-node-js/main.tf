locals {
  allTags = var.tags
}

data "aws_ami" "linux" {
  filter {
    name   = "image-id"
    values = [var.aws_image_id]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

resource "aws_vpc" "vpc" {
  cidr_block           = "10.22.0.0/16"
  enable_dns_hostnames = true
  tags = merge(
    local.allTags,
    {
      "Name" = "VPC-PoC"
    },
    {
      "Environment" = "POC"
    },
  )
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.allTags,
    {
      "Name" = "Gw-PoC"
    },
    {
      "Environment" = "POC"
    },
  )
}

resource "aws_route_table" "routeTable" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  #route {
  #  ipv6_cidr_block        = "::/0"
  #  egress_only_gateway_id = "${aws_egress_only_internet_gateway.foo.id}"
  #}

  tags = merge(
    local.allTags,
    {
      "Name" = "Rt-PoC"
    },
    {
      "Environment" = "POC"
    },
  )
}

data "aws_availability_zones" "available" {}

# Publics in AZs
resource "aws_subnet" "subnet1" {
  count      = "${length(data.aws_availability_zones.available.names)}"
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.22.${10+count.index}.0/27"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
  
  tags = merge(
    local.allTags,
    {
      "Name" = "Subnet1-PoC"
    },
    {
      "Environment" = "POC"
    },
  )
}

# Privates in AZs
resource "aws_subnet" "subnet2" {
  count      = "${length(data.aws_availability_zones.available.names)}"
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.22.${20+count.index}.0/27"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  
  tags = merge(
    local.allTags,
    {
      "Name" = "Subnet2-PoC"
    },
    {
      "Environment" = "POC"
    },
  )
}

resource "aws_route_table_association" "a1" {
  count = length(aws_subnet.subnet1)
  subnet_id      = aws_subnet.subnet1[count.index].id
  route_table_id = aws_route_table.routeTable.id
}

resource "aws_security_group" "ec2_sggroup" {
  name        = "Security Group EC2 PoC"
  description = "Security Group EC2 PoC"
  vpc_id      = aws_vpc.vpc.id

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
    security_groups = [aws_security_group.lb_sggroup.id]
    #cidr_blocks = []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.allTags,
    {
      "Name" = "SgGroup-EC2-PoC"
    },
    {
      "Environment" = "POC"
    },
  )
}

resource "aws_instance" "ec2" {
  ami              = data.aws_ami.linux.id
  instance_type    = "t2.micro"
  count            = 1
  subnet_id        = aws_subnet.subnet1[0].id
  security_groups  = [aws_security_group.ec2_sggroup.id]
  key_name         = "eu-central-1-Administrator"

  provisioner "file" {
    source      = "script/index.js"
    destination = "~/index.js"

    connection {
      host = self.public_ip
      user        = "ec2-user"
      private_key = "${file("~/.ssh/eu-central-1-Administrator.pem")}"
    }
  }

  user_data_base64 = base64encode(var.aws_linux_user_data_nodejs)

  #iam_instance_profile = "${aws_iam_instance_profile.UJR_SSMRoleForEC2Instances.name}"
  associate_public_ip_address = true
  depends_on                  = [aws_internet_gateway.gw]
  tags = merge(
    local.allTags,
    {
      "Environment" = "POC"
    },
  )
}



#output "vpc_id" {
#  value = "${aws_vpc.infra.id}"
#}
