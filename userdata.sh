#!/bin/bash
yum update -y
yum install ansible -y
yum install git -y
cd /home/ec2-user
git clone https://github.com/NidaCambay/Jenkins-Project.git
cd Jenkins-Project
chmod 400 /home/ec2-user/firstkey.pem