terraform {
  backend "s3" {
    bucket     = "iac-ujr-terraform-remote-state"
    #dynamodb_table = "terraform_dev_remote_state_lock" (Passing as Parameter)
    region     = "eu-west-3"
  }
}
