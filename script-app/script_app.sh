# !/bin/bash

function InstalacaoJava () {
    echo  "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Estou verificando se seu servidor tem alguma versão de Java instalada..."
    # Verificar se o Java existe
    java -version 
    # Se já existir o Java, perguntamos se quer fazer a instalação que a DataSentry recomenda (versão JRE11)
    # Se ele quiser vamos instalar e usar esse JRE, senão vamos para o passo seguinte.
    if [ $? -eq 0 ]
        then
            echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Você já tem alguma versão de Java instalado no seu servidor!"
        else
            echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Parece que esta máquina não tem nenhuma versão de Java instalado..."
    fi
    echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Deseja instalar a versão que Datasentry recomenda? (y/n)"
    read inst
    if [ $inst = "y" ]
        then
            echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Perfeito, vamos instalar o Java!"
            echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Trazendo algumas configurações para a instalação!"
            sleep 1
            sudo add-apt-repository ppa:webupd8team/java -y
            sleep 1
            sudo apt update -y
            clear
            echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Preparando para instalar a versão 11 do Java. Confirme a instalação quando solicitado ;D"
            sudo apt install default-jre && apt install openjdk-11-jre-headless -y
            clear
            echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Java instalado com sucesso!"
        else 	
        echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Vamos continuar sem a instalação do Java..."
        sleep 1
        echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Você posteriormente pode ter problemas sem esse passo..."
    fi
}

function InstalarDatasentry () {
    echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Instalando o Datasentry..."
    sleep 2
    # Se sim, vamos apagar o projeto e vamos clonar novamente o projeto em sua ultima versão estável
    DIR=$HOME/datasentry
    sudo mkdir $DIR
    wget -q https://github.com/AccentureSPtech2ADSA/datasentry-public/blob/main/data-sentry-1.0-SNAPSHOT-jar-with-dependencies.jar?raw=true
    sudo cp data-sentry-1.0-SNAPSHOT-jar-with-dependencies.jar\?raw\=true $DIR/datasentryapp.jar
    sudo rm -rf 'data-sentry-1.0-SNAPSHOT-jar-with-dependencies.jar?raw=true'
    sudo chmod 755 $DIR/datasentryapp.jar
    echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Instalação finalizada!!"
    sleep 2
}
function BaixarDatasentry () {
    DIR=$HOME/datasentry
    echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Vamos agora baixar o App do Datasentry!"
    sleep 1
    # Verificamos se o projeto já existe no /home/user, caso exista iremos perguntar se deseja substituir (recomendados caso esteja desatualizado)
    if [ -d "$DIR" ]
        then
            echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Parece que o App já foi instalado anteriormente..."
            sleep 1
            echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Recomendamos que você substitua o App para ficar com a ultima versão do Datasentry!"
            sleep 1
            echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Deseja substituir? (y/n)"
            read inst
            if [ $inst = "y" ]
                then
                    sudo rm -rf $DIR
                    InstalarDatasentry
                else 
                    echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Certo! Vamos sem substituir então!"
            sleep 2
            fi
        else 
            InstalarDatasentry
    fi
}
function ConfiguracoesAdicionais () {
    # verificar se atalhos nao existem
    DIR=$HOME/datasentry
    APP=$DIR/datasentryapp.jar
    echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Vamos fazer algumas configurações adicionais agora!"
    # Vamos perguntar se ele deseja criar um atalho para ele executar facilmente pela CLI
    cat ~/.bashrc | grep datasentry # verifica se ja tem o CLI
    if [ $? = 0 ]
        then
        echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Já temos um atalho de CLI!"
        else
            echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Deseja que seja criado um atalho para executar o Datasentry usando o comando 'exec-datasentry' em na linha de comando? (y/n)"
            read inst
            # Se sim vamos criar este atalho e avisar que ele pode chamar o .JAR escrevendo 'exec-datasentry' no CLI
            if [ $inst = "y" ]
                then
                    echo "alias exec-datasentry='java -jar $APP' " >> $HOME/.bashrc
                    sleep 1
                    echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Inserindo atalho exec-datasentry!"
                    sleep 2
                    echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Atalho inserido com sucesso!"
                else
                    echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Certo! Sem atalhos CLI por aqui..."
            fi
    fi
    ls /usr/share/applications/ | grep datasentry
    if [ $? = 0 ]
        then
            echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Já temos um atalho de Interface gráfica!"
        else
            echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Caso use interface gráfica, deseja colocar um atalho com icone em seu desktop?(y/n)"
            # Vamos verificar se existe uma interface gráfica no sistema
            sleep 1
            read inst
            if [ $inst = "y" ] 
            then
                # Se existir vamos perguntar se ele deseja um a
                #talho desktop para acessar via Icone o aplicativo Datasentry
                # Se ele quiser vamos gerar um datasentry.desktop no share dele pra ele poder acessar, senão vamos ignorar
                LOCAL=/usr/share/applications
                APPDESK=datasentry.desktop
                touch $APPDESK
                echo "[Desktop Entry]" > $APPDESK
                echo "Exec=java -jar $APP" >> $APPDESK
                echo "Type=Application" >> $APPDESK
                echo "Icon=$DIR/icon.xpm" >> $APPDESK
                sudo cp $APPDESK $LOCAL/$APPDESK
                sleep 2
                rm -f $APPDESK
                echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Atalho com ícone inserido com sucesso!"
            else
                echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Certo! Sem atalhos GUI gráficos..."
            fi
    fi
    wget -q https://github.com/AccentureSPtech2ADSA/datasentry-public/blob/main/icon.XPM?raw=true
    sudo cp 'icon.XPM?raw=true' $DIR/icon.xpm
    rm -f 'icon.XPM?raw=true'
    source $HOME/.bashrc
    source ~/.bashrc 
    echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Sessão de configurações adicionais finalizada!"
}
function Execnow () {
    # Vamos perguntar se ele deseja executar o App naquele instante
    echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Deseja executar o APP neste instante?(y/n)"
    read inst
    # Se sim, executamos já, senão acabmos o script
    if [ $inst = "y" ]
        then
            DIR=$HOME/datasentry
            APP=$DIR/datasentryapp.jar
            java -jar $APP
        else
            echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Sem executar por agora."
            sleep 2
    fi
    
}
function InstalarDocker () {
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
}
function IniciarContainerApp () {

}
function ValidarTipoDeInterface () {
    echo $XDG_CURRENT_DESKTOP
    if [ $? -eq 0 ]; 
    then
        echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Você está utilizando interface gráfica no sistema!"
        InstalacaoJava
        sleep 1
        BaixarDatasentry
        sleep 1
        ConfiguracoesAdicionais
        sleep 1
        Execnow
    else
        echo "$(tput setaf 10)[DataSentry-BOT]:$(tput setaf 7) Você está usando sistema via interface CLI!"
        InstalarDocker
        sleep 1
        IniciarContainerApp
    fi
}


echo  "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Olá usuário $USERNAME, vou te acompanhar para a instalação da aplicação do Datasentry em sua máquina"
echo  "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Seus dados não estão sendo coletados, esse script serve exclusivamente para auxiliar na instalação do Datasentry em seu servidor."
echo  "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Para a aplicação funcionar corretamente, vamos precisar instalar os seguintes recursos: JRE (Java)"

sleep 2

echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Configuração concluida!"
echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Obrigado e pode contar conosco sempre! :)"
echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Datasentry Copyright © 2022"
echo "$(tput setaf 10)[Datasentry-BOT]:$(tput setaf 7) Acesse já: http://datasentry.sysnet.net e melhore já o monitoramento com a gente!"

sleep 2

# ===================================================================
# Todos os passos vão ter escritos o que estamos fazendo, isso via funçõe de SHELL
# Todos direitos reservados para o autor: Datasentry SPTech - Accenture.
# Sob licença Creative Commons @2022
# Podera modificar e reproduzir para uso pessoal.
# Proibida a comercialização e a exclusão da autoria.
# ===================================================================
