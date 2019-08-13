#!/usr/bash 

sudo apt-get update

#the following might not be needed, but shouldn't hurt to run it.
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add dockers gpg key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify that you now have the key with the fingerprint 
# 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88, 
# by searching for the last 8 characters of the fingerprint.
sudo apt-key fingerprint 0EBFCD88

# set up the stable repository (lsb_release -cs will return "trusty")
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

#The following command might change depending on where Docker containers are spun up during deployment
sudo apt-get install docker-ce

# Start docker-engine on host
sudo systemctl enable docker
sudo systemctl start docker

# For 14.04
#sudo update-rc.d docker defaults


# The docker daemon always runs as the root user.
# Add docker user to ubuntu user group
sudo usermod -aG docker ubuntu

# create workspace directory for Jenkins on host
sudo mkdir -p /var/jenkins_home
sudo chown -R ubuntu:ubuntu /var/jenkins_home/
docker build -t jenkins-docker .
docker run -p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -d --name jenkins-docker jenkins-docker

echo 'Jenkins installed'
echo 'You should now be able to access jenkins at: http://'$(curl -s ifconfig.co)':8080'
