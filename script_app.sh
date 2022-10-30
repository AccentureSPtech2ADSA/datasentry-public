# !/bin/bash
echo 'Instalando DataSentryAplication'
sudo rm -rf ~/datasentry
sudo apt install git openjdk-11-jdk -y
sudo git clone https://GuilhermeNarciso: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@github.com/AccentureSPtech2ADSA/Data-Sentry-Application ~/datasentry
cd ~/datasentry/app/
sudo chmod 755 data-sentry-1.0-SNAPSHOT-jar-with-dependencies.jar
echo 'DataSentry instalado com sucesso'
java -jar data-sentry-1.0-SNAPSHOT-jar-with-dependencies.jar

