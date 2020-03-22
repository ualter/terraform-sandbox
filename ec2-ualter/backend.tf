terraform {
  backend "s3" {
    bucket     = "iac-ec2-remote-state"
    region     = "eu-west-3"
  }
}
