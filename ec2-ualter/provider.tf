provider "aws" {
  region = var.aws_region  # Terraform 0.12 Syntax
  #region = "${var.aws_region}" # Terraform 0.11 Syntax
}