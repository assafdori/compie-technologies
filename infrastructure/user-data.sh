#!/bin/bash

sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user
sudo docker pull nginx
sudo docker run -d -p 80:80 nginx
