#!bin/bash

yum update -y
yum install -y docker
yum install -y amazon-efs-utils

systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
chkconfig docker on

curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
mv /usr/local/bin/docker-compose /bin/docker-compose

curl -sL https://raw.githubusercontent.com/LucasEmanoel/compass-docker/main/docker-compose.yml --output /home/ec2-user/docker-compose.yml

mkdir -p /mnt/efs/lucas-emanoel/var/www/html

sudo mount -t efs fs-00551b6438692354b.efs.us-east-1.amazonaws.com:/ /mnt/efs
sudo chown ec2-user:ec2-user /mnt/efs

echo "fs-00551b6438692354b.efs.us-east-1.amazonaws.com:/ /mnt/efs nfs defaults 0 0" >> /etc/fstab

docker-compose -f /home/ec2-user/docker-compose.yml up -d
