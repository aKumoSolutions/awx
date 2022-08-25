#!/usr/bin/env bash

## Color variables
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
# Clear the color after that
clear='\033[0m'

## Ensure Linux Distribution is Ubuntu 20.04  ##
if cat /etc/*release | grep ^NAME | grep -i CentOS && \
   cat /etc/*release | grep ^VERSION_ID | grep 7 ; then
   echo -e "${yellow}=========================="
   echo -e "${yellow}Updating existing packages"
   echo -e "${yellow}==========================${clear}"
   
   ## Update exiting packages ##
   sudo yum update -y
   echo -e "${green}Done${clear}"

   ## Install Dependencies ##
   echo -e "${yellow}==========================================="
   echo -e "${yellow}Updating Packages & Installing Dependencies"
   echo -e "${yellow}===========================================${clear}"
   sudo yum update -y
   sudo yum install -y wget epel-release
   sudo yum remove -y python-docker-py
   sudo yum install -y yum-utils device-mapper-persistent-data lvm2 ansible git python-devel python-pip python-docker-py
   echo -e "${green}Done${clear}"

   ## Upgrade to Python 3.7 ##
   echo -e "${yellow}================"
   echo -e "${yellow}Upgrading Python"
   echo -e "${yellow}================${clear}"
   sudo yum install -y gcc openssl-devel bzip2-devel libffi-devel zlib-devel xz-devel
   sudo wget https://www.python.org/ftp/python/3.7.11/Python-3.7.11.tgz  -P /tmp
   sudo tar xzf /tmp/Python-3.7.11.tgz -C /tmp/
   cd /tmp/Python-3.7.11; ./configure --enable-optimizations
   cd /tmp/Python-3.7.11; make altinstall
   ln -s /usr/local/bin/python3.7 /usr/bin/python3
   echo -e "${green}Done${clear}"

   ### Install Pip Dependencies ##
   echo -e "${yellow}==========================="
   echo -e "${yellow}Installing Pip Dependencies"
   echo -e "${yellow}===========================${clear}"
   pip3.7 install cryptography
   pip3.7 install jsonschema
   pip3.7 install docker-compose~=1.23.0
   pip3.7 install docker
   echo -e "${green}Done${clear}"

   ### Install Docker ##
   echo -e "${yellow}=================="
   echo -e "${yellow}Installing Docker"
   echo -e "${yellow}==================${clear}"
   sudo yum-config-manager –add-repo https://download.docker.com/linux/centos/docker-ce.repo
   sudo yum install -y docker-ce
   echo -e "${green}Done${clear}"

   ### Starting Docker Service ##
   echo -e "${yellow}=========================="
   echo -e "${yellow}Enabling & Starting Docker"
   echo -e "${yellow}==========================${clear}"
   sudo yum-config-manager –add-repo https://download.docker.com/linux/centos/docker-ce.repo
   sudo yum install -y docker-ce
   systemctl start docker
   systemctl enable docker
   echo -e "${green}Done${clear}"

   ### Clone AWX ##
   echo -e "${yellow}=========================="
   echo -e "${yellow}Clone AWX Repo"
   echo -e "${yellow}==========================${clear}"
   git clone https://github.com/ansible/awx.git
   cd awx/; git clone https://github.com/ansible/awx-logos.git
   cd awx/installer/
   echo -e "${green}Done${clear}"

else
   echo -e "${red}Linux Distribution doesn't match requirement${clear}"
fi