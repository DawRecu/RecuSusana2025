#!/bin/bash

# Actualizamos los paquetes
sudo apt-get update -y

# Instalamos dependencias necesarias para Docker
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Agregamos la clave GPG oficial de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Agregamos el repositorio oficial de Docker
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Actualizamos los paquetes después de agregar el repositorio
sudo apt-get update -y

# Instalamos Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Habilitamos y arrancamos Docker
sudo systemctl enable docker
sudo systemctl start docker

# Agregamos el usuario ubuntu al grupo docker para evitar usar sudo en cada comando
sudo usermod -aG docker ubuntu

# Descargamos e iniciamos el contenedor de Jenkins
sudo docker run -d --name jenkins -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts

# Configuramos el contenedor para reiniciarse automáticamente
sudo docker update --restart unless-stopped jenkins
