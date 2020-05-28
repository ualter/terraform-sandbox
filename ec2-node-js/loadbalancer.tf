


resource "aws_security_group" "lb_sggroup" {
  name        = "Security Group ELB PoC"
  description = "Security Group ELB PoC"
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
    cidr_blocks = ["0.0.0.0/0"]
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
      "Name" = "SgGroup-ELB-PoC"
    },
    {
      "Environment" = "POC"
    },
  )
}

#resource "aws_s3_bucket" "lb_logs" {
#    bucket = "ujrlblogs"
#    acl    = "public"
#
#    tags = merge(
#      local.allTags,
#      {
#       "Name" = "S3-LB-LOGS-PoC"
#      },
#      {
#       "Environment" = "POC"
#      },
#    )
#}

# Instance Target Group
resource "aws_lb_target_group" "tg_test" {
  name     = "tf-test-lb-test"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"

  tags = merge(
      local.allTags,
      {
       "Name" = "TG-TEST-PoC"
      },
      {
       "Environment" = "POC"
      },
   )
}

resource "aws_lb_target_group_attachment" "tg_attach_test" {
  count = length(aws_instance.ec2)
  target_group_arn = "${aws_lb_target_group.tg_test.arn}"
  target_id = aws_instance.ec2[count.index].id
  port             = 80
}

resource "aws_lb" "lb_test" {
    name = "test-lb-test"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.lb_sggroup.id]

    #count = length(aws_subnet.subnet1)
    subnets = [for subnet in aws_subnet.subnet1 : subnet.id]

    #access_logs {
    #    bucket  = "${aws_s3_bucket.lb_logs.bucket}"
    #    prefix  = "test-lb"
    #    enabled = true
    #}

    tags = merge(
      local.allTags,
      {
       "Name" = "LB_TEST-PoC"
      },
      {
       "Environment" = "POC"
      },
    )
}

resource "aws_lb_listener" "lb_listener_test" {
  load_balancer_arn = "${aws_lb.lb_test.arn}"
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tg_test.arn}"
  }
}