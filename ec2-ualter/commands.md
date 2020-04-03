## Terraform

```bash
# Initialized Terraform Project
export ENVIRONMENT=dev
export TF_VAR_environment=dev
# Check prepared_backend folder, to do it automatically (DynamoDB and S3 for Backend remote state and Locking)
# The S3 Bucket is necessary to storage the Terraform state remotely
# The DynamoDB table is necessary to Lock the State while a user is being running the Terraform against it

## Steps
# Init
terraform init -backend-config="key=${ENVIRONMENT}/infrastructure.tfstate" -backend-config="dynamodb_table=terraform_${ENVIRONMENT}_remote_state_lock" -var-file="${ENVIRONMENT}/infra.tfvars" -backend=true -get=true -lock=true 
# Plan
terraform plan -var-file="${ENVIRONMENT}/infra.tfvars" -out tfplan
# Apply
terraform apply --auto-approve -no-color -lock=true tfplan 
# Destroy
terraform destroy -no-color -lock=true -var-file="${ENVIRONMENT}/infra.tfvars"

# Create Workspaces
terraform workspace new dev
terraform workspace new stg
terraform workspace new prod

# Change to a Workspace
terraform workspace select dev

# Launch/Upgrade Terraform
terraform init -upgrade=true -var-file=vars/dev.tfvars
terraform apply -var-file=vars/dev.tfvars
```
AWS CLI
```bash
# Look up an EC2 Instances by filter
aws ec2 describe-images --filters "Name=image-id,Values=ami-07eda9385feb1e969" --region eu-west-3

aws ec2 describe-images --filter "Name=image-id,Values=ami-09def150731bdbcc2" --region eu-central-1

# Create S3 Bucket for Backend
aws s3api create-bucket --bucket iac-ec2-remote-state --region eu-west-3 --create-bucket-configuration LocationConstraint=eu-west-3

# Import an existing AWS Instance (must be change the terrafor configuration script to add the aws instance example before)
terraform import -var-file=dev/infra.tfvars  aws_instance.example i-0953368a71600c848
``` 

