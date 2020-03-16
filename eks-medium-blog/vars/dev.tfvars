### Provider
aws_region = "eu-central-1"
aws_profile = "highcloud"


## Application Specification
environment = "dev"
application_name = "High Cloud"
application_slug = "highcloud"
tags = {
  "kubernetes.io/cluster/dev-k8s.highcloud.local" = "owned",
  "Application" = "HighCloud"
}
## Network Specification
vpc_cidr = "10.0.0.0/20"
az_list = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
private_subnet_cidr_list = ["10.0.4.0/22", "10.0.8.0/22", "10.0.12.0/22"]
public_subnet_cidr_list  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]