variable "aws_region" {
  description = "The region to create the EC2 Instance"
  default=""
}

variable "aws_image_id" {
  description = "The chosen AMI for the EC2 Instance"
  default=""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "environment" {
  description = "Which environment we are running this"
  default     = ""
}