### Provider
aws_region = "eu-central-1"

aws_image_id = "ami-03ab4e8f1d88ce614"

tags = {
  "Owner" = "Ualter Jr.",
  "Purpose" = "Terraform"
}

aws_linux_user_data =<<EOF
    #!/bin/bash
    cd /tmp
    sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    sudo status amazon-ssm-agent
    sudo start amazon-ssm-agent
EOF

# Amazon Linux AMI 2018.03.0 (HVM), SSD Volume Type - ami-03ab4e8f1d88ce614 
#sudo status amazon-ssm-agent
#sudo start amazon-ssm-agent

# Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-076431be05aaf8080 (64-bit x86) / ami-00b295cfc57f3deb6 (64-bit Arm)
#sudo systemctl enable amazon-ssm-agent
#sudo systemctl start amazon-ssm-agent

