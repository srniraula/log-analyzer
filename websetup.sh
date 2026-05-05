#!/bin/bash

sudo yum install wget unzip httpd -y

sudo systemctl start httpd
sudo systemctl enable httpd

mkdir -p /tmp/webfiles
cd /tmp/webfiles

wget https://www.tooplate.com/zip-templates/2155_modern_musician.zip
unzip 2155_modern_musician.zip
sudo cp -r 2155_modern_musician/* /var/www/html/

systemctl restart httpd

rm -rf /tmp/webfiles
