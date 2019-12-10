#!/bin/bash

JENKINS_URL=ec2-50-17-55-113.compute-1.amazonaws.com

scp -o StrictHostKeyChecking=no -i "~/.aws/Jenkins.pem" ~/.aws/credentials ubuntu@${JENKINS_URL}:~/credentials
ssh -o StrictHostKeyChecking=no -i "~/.aws/Jenkins.pem" ubuntu@${JENKINS_URL} "sudo mv ~/credentials /var/lib/jenkins/.aws/credentials"
ssh -o StrictHostKeyChecking=no -i "~/.aws/Jenkins.pem" ubuntu@${JENKINS_URL} "sudo chmod a+r /var/lib/jenkins/.aws/credentials"