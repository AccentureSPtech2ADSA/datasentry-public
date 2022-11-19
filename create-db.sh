#!/bin/bash

msgAutomatizada="$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) "

echo $mensagemAutomatizada "Atualizando os pacotes..."
sudo apt update && sudo apt upgrade -y

docker --version
if ! [[ $? -eq 0 ]]
    echo $mensagemAutomatizada "Instalando o Docker!"
    sudo apt install docker -y
    sudo apt install docker.io -y

    sleep 2

    echo $mensagemAutomatizada "Atualizando os pacotes novamente..."
    sudo apt update && sudo apt upgrade -y

    sleep 2
fi

echo $mensagemAutomatizada "Verificando se você já possuí os grupos de Docker corretos..."
groups | grep docker

if ! [[ $? -eq 0 ]]
then
    echo $mensagemAutomatizada "Adicionando algumas configurações do Docker"
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    sudo systemctl restart docker
    source ~/.bashrc
    echo $mensagemAutomatizada "Configurações realizadas!"
    else
    echo $mensagemAutomatizada "Você já possuí os grupos corretos!"
fi

echo $mensagemAutomatizada "Verificando se o banco de dados já existe..."
docker ps -a | grep datasentry-db
        if ! [[ $? -eq 0 ]]
            then
            echo $mensagemAutomatizada "Voce já possuí o nosso banco de dados!"
            echo $mensagemAutomatizada "Deseja reinstalar novamente?(S/N)"
            read resposta
            if [ \"$resposta\" == \"S\" ]
                then
                    docker exec -it datasentry-db /opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 -U sa -P Gfgrupo1 -q "DROP DATABASE IF EXISTS datasentry"
                else
                    echo $mensagemAutomatizada "Você optou por não reinstalar o banco de dados."
            fi
        fi
    sleep 2

    echo $mensagemAutomatizada "Pegando imagem do banco de dados SQLServer do Datasentry"
    sudo docker pull deofino/datasentry-mssql

    echo $mensagemAutomatizada "Iniciando o container com o banco de dados..."
    docker rm datasentry-db
    docker run -p 1433:1433 --name datasentry-db -d deofino/datasentry-mssql
    echo $mensagemAutomatizada "Criando o banco de dados"
    echo $mensagemAutomatizada "Esperando 50 segundos para o SQLServer subir..."
    sleep 50

    echo $mensagemAutomatizada "Inserindo tabelas no banco de dados!"
    docker exec -it datasentry-db /opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 -U sa -P Gfgrupo1 -i /opt/mssql-tools/bin/tables.sql

    echo $mensagemAutomatizada "Inserindo Procedures e configurações"
    docker exec -it datasentry-db /opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 -U sa -P Gfgrupo1 -i /opt/mssql-tools/bin/procedures.sql

    echo $mensagemAutomatizada "Banco de dados criado com sucesso!"
