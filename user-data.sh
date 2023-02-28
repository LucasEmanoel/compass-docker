#!bin/bash

sudo yum update -y
sudo yum install -y docker
sudo yum install -y amazon-efs-utils

sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
sudo chkconfig docker on

sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo mv /usr/local/bin/docker-compose /bin/docker-compose

sudo curl -sL https://raw.githubusercontent.com/LucasEmanoel/compass-docker/main/docker-compose.yml --output /home/ec2-user/docker-compose.yml

/bin/docker-compose -f /home/ec2-user/docker-compose.yml up -d
