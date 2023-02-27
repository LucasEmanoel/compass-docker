#!bin/bash

sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
sudo chkconfig docker on

sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo mv /usr/local/bin/docker-compose /bin/docker-compose

cat <<EOF >/home/ec2-user/docker-compose.yml
version: "3.3"
services:
  apache:
    image: httpd:latest
    ports:
    -  80:80
EOF

/bin/docker-compose -f /home/ec2-user/docker-compose.yml up -d
