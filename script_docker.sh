# !/bin/bash
echo 'Baixando Docker'
sudo apt-get remove docker docker-engine docker.io containerd runc -y
echo 'Instalando Docker'
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
echo 'Docker instalado com sucesso'
echo 'Ajustando algumas configurações...'
sudo groupadd docker
sudo usermod -aG docker $USER
source ~/.bashrc
echo 'Docker configurado!'
