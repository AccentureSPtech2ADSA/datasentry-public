#!/bin/bash
echo "Atualizando os pacotes..."
sudo apt update && sudo apt upgrade -y

echo "Instalando o Docker!"
sudo apt install docker -y
sudo apt install docker.io -y

echo "Atualizando os pacotes novamente..."
sudo apt update && sudo apt upgrade -y

echo "Adicionando algumas configurações do Docker"
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl restart docker

echo "Pegando imagem do banco de dados SQLServer do Datasentry"
sudo docker pull deofino/datasentry-mssql

echo "Iniciando o container com o banco de dados..."
docker rm datasentry-db
docker run -p 1433:1433 --name datasentry-db -d deofino/datasentry-mssql
echo "Criando o banco de dados"
echo "Esperando 50 segundos para o SQLServer subir..."

sleep 50
echo "Inserindo tabelas no banco de dados!"
docker exec -it datasentry-db /opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 -U sa -P Gfgrupo1 -i /opt/mssql-tools/bin/tables.sql

echo "Inserindo Procedures e configurações"
docker exec -it datasentry-db /opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 -U sa -P Gfgrupo1 -i /opt/mssql-tools/bin/procedures.sql

echo "Banco de dados criado com sucesso!"