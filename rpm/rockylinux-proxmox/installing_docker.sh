#!/usr/bin/env bash 

## Script to install docker-ce on Rocky Linux
## Run using `sudo rocky-docker.sh`

# # Ensuring "GROUP" variable has not been set elsewhere
unset GROUP

echo "Removing podman and installing Docker CE"
sudo dnf remove -y podman buildah
sudo dnf install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io

echo "Setting up docker service"
sudo systemctl enable docker
sudo systemctl start docker
# sudo systemctl status docker

echo "Adding permissions to current user for docker, attempting to reload group membership"
sudo usermod -aG docker jkirk 
GROUP=$(id -g)
newgrp docker
newgrp $GROUP
unset GROUP

echo "Install completed, though you will probably require logout/login if the following command fails:"
docker ps
