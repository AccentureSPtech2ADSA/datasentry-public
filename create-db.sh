#!/bin/bash

echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Atualizando os pacotes..." 
sudo apt update && sudo apt upgrade -y

echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Verificando se você já possuí o Docker..."

docker --version
if [ $? != 0 ];
then
    echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Instalando o Docker!"
    sudo apt install docker -y
    sudo apt install docker.io -y

    sleep 2

    echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Atualizando os pacotes novamente..."
    sudo apt update && sudo apt upgrade -y
fi

echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Verificando se você já possuí os grupos de Docker corretos..."
groups | grep docker

if [ $? != 0 ];
then
    echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Adicionando algumas configurações do Docker"
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    sudo systemctl restart docker
    source ~/.bashrc
    echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Configurações realizadas!"
else
    echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Você já possuí os grupos corretos!"
fi

echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Pegando imagem do banco de dados SQLServer do DataSentry"
sudo docker pull deofino/datasentry-mssql

echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Verificando se o banco de dados já existe..."
docker ps -a | grep datasentry-db
        if [ $? -eq 0 ];
        then
            echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Voce já possuí o nosso banco de dados!"
            echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Deseja reinstalar novamente?(S/N)"
            read resposta
            if [ "$resposta" == "S" ];
            then
                echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Iniciando o container com o banco de dados..."
                docker rm -f datasentry-db
                docker run -p 1433:1433 --name datasentry-db -d deofino/datasentry-mssql
                echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Criando o banco de dados"
                echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Esperando 50 segundos para o SQLServer subir..."
                sleep 50

                echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Inserindo tabelas no banco de dados!"

                # docker exec -it datasentry-db /opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 -U sa -P Gfgrupo1 -q "DROP DATABASE IF EXISTS datasentry"

                docker exec -it datasentry-db /opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 -U sa -P Gfgrupo1 -i /opt/mssql-tools/bin/tables.sql

                echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Inserindo Procedures e configurações"
                docker exec -it datasentry-db /opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 -U sa -P Gfgrupo1 -i /opt/mssql-tools/bin/procedures.sql

                echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Banco de dados criado com sucesso!"
            else
                docker start datasentry-db
                echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Você optou por não reinstalar o banco de dados."
            fi
        fi
