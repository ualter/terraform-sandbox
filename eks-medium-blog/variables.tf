### Provider
variable "aws_region" {
  description = "The region to deploy the kubernetes cluster"
  default=""
}
variable "aws_profile" {
  description = "IAM Profile name for AWS"
  default=""
}


## Application Specification
variable "environment" {
  description = "The Environment of the Kubernetes cluster"
  default     = ""
}
variable "application_name" {
  description = "The Application Name of the Kubernetes cluster"
  default     = ""
}
variable "application_slug" {
  description = "The Application Slug of the Kubernetes cluster"
  default     = ""
}
variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}
## Network Specification
variable "vpc_cidr" {
  description = "The CIDR Range for the Kubernetes cluster vpc"
  default     = ""
}
variable "az_list" {
  description = "The AZ of the Kubernetes cluster will be placed in"
  default     = []
}
variable "private_subnet_cidr_list" {
  description = "The CIDR list of the Kubernetes nodes will be placed in"
  default     = []
}
variable "public_subnet_cidr_list" {
  description = "The CIDR list of the Kubernetes Public Pieces will be placed in"
  default     = []
}

