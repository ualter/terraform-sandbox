### Provider
aws_region = "eu-central-1"

aws_image_id = "ami-03ab4e8f1d88ce614"

tags = {
  "Owner" = "UJR",
  "Purpose" = "PoC"
}

aws_linux_user_data =<<EOF
    #!/bin/bash
    sudo yum install -y httpd
    sudo service httpd start
    usermod -a -G apache ec2-user
    chown -R ec2-user:apache /var/www
    chmod 2775 /var/www
    find /var/www -type d -exec chmod 2775 {} \;
    find /var/www -type f -exec chmod 0664 {} \;
    echo "<html><head></head><body><h3>Hello from $(hostname -f)</h3></body></html>" > /var/www/html/index.html
EOF

# Amazon Linux AMI 2018.03.0 (HVM), SSD Volume Type - ami-03ab4e8f1d88ce614 
#sudo status amazon-ssm-agent
#sudo start amazon-ssm-agent

# Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-076431be05aaf8080 (64-bit x86) / ami-00b295cfc57f3deb6 (64-bit Arm)
#sudo systemctl enable amazon-ssm-agent
#sudo systemctl start amazon-ssm-agent

