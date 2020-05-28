### Provider
aws_region = "eu-central-1"

aws_image_id = "ami-03ab4e8f1d88ce614"

tags = {
  "Owner" = "UJR",
  "Reference" = "NodeJs"
  "Purpose" = "PoC"
}

aws_linux_user_data_apache_server =<<EOF
    #!/bin/bash
    sudo yum install -y httpd
    sudo service httpd start
    usermod -a -G apache ec2-user
    chown -R ec2-user:apache /var/www
    chmod 2775 /var/www
    find /var/www -type d -exec chmod 2775 {} \;
    find /var/www -type f -exec chmod 0664 {} \;
    echo "<html><head></head><body><h3>Hello from $(hostname)</h3></body></html>" > /var/www/html/index.html
EOF

aws_linux_user_data_nodejs =<<EOF
    #!/bin/bash
    # sudo yum -y update
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash
    . /.nvm/nvm.sh
    nvm install --lts
    npm install pm2@latest -g
    pm2 start /home/ec2-user/index.js --name "index.js"
    #ln -s ~/.nvm/versions/node/$(node --version)/bin/node /usr/bin/node
    #node ~/index.js >> ~/index.log
    #cat ". /.nvm/nvm.sh" >> /home/ec2-user/.bashrc
EOF

# Amazon Linux AMI 2018.03.0 (HVM), SSD Volume Type - ami-03ab4e8f1d88ce614 
#sudo status amazon-ssm-agent
#sudo start amazon-ssm-agent

# Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-076431be05aaf8080 (64-bit x86) / ami-00b295cfc57f3deb6 (64-bit Arm)
#sudo systemctl enable amazon-ssm-agent
#sudo systemctl start amazon-ssm-agent

