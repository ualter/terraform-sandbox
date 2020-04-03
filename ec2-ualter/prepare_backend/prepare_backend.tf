provider "aws" {
  region = "eu-west-3"
}

# terraform state file setup
# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "terraform-state-storage-s3" {
    bucket = "iac-ujr-terraform-remote-state"

    versioning {
        enabled = true
    }

    #lifecycle {
    #    prevent_destroy = true
    #}

    tags = {Name = "S3 Remote Terraform State Store Ualter Jr."}
          
}

# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
    name = "terraform_dev_remote_state_lock"
    hash_key = "LockID"
    read_capacity = 20
    write_capacity = 20

    attribute {
        name = "LockID"
        type = "S"
    }

    tags = {Name = "DynamoDB Terraform State Lock Table"}
}