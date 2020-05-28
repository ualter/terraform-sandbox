variable "aws_region" {
  description = "The region to create the EC2 Instance"
  default     = ""
}

variable "aws_image_id" {
  description = "The chosen AMI for the EC2 Instance"
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "environment" {
  description = "Which environment we are running this"
  default     = ""
}

variable "aws_linux_user_data_apache_server" {
  description = "User data for AWS Linux 2 AMI Apache Server "
  default     = ""
}

variable "aws_linux_user_data_nodejs" {
  description = "User data for AWS Linux 2 AMI NodeJS Server"
  default     = ""
}



