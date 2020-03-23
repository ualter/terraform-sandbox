## Terraform

```bash
# Initialized Terraform Project
export ENVIRONMENT=dev
export TF_VAR_environment=dev

# Init
terraform init -backend-config="key=${ENVIRONMENT}/infrastructure.tfstate" -var-file="${ENVIRONMENT}/infra.tfvars" -backend=true
# Plan
terraform plan -var-file="${ENVIRONMENT}/infra.tfvars" -out tfplan
# Apply
terraform apply tfplan
# Destroy
terraform destroy -var-file="${ENVIRONMENT}/infra.tfvars"

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
``` 

