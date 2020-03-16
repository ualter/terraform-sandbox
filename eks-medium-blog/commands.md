```bash
# Initialized Terraform Project
terraform init -upgrade=true -var-file=vars/dev.tfvars

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