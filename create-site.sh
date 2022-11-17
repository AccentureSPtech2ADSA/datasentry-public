#!/bin/bash
echo "Atualizando os pacotes..."
sudo apt update && sudo apt upgrade -y

# Verifica se já está instalado
echo "Instalando o Docker!"
sudo apt install docker -y
sudo apt install docker.io -y

echo "Atualizando os pacotes novamente..."
sudo apt update && sudo apt upgrade -y

# Verifica se já tem as config
echo "Adicionando algumas configurações do Docker"
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl restart docker

echo "Pegando imagem do Site de produção do Datasentry"
sudo docker pull deofino/datasentry-site-prod

echo "Iniciando o container com o site em produção"
docker rm site
docker run --network host --name site -d deofino/datasentry-site-prod

echo "Site rodando na porta 80... Ou http://datasentry.sytes.net/"
