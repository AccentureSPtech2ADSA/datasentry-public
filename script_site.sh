# !/bin/bash
echo 'Oi, vamos instalar o site do Data Sentry :)'
echo 'Vamos instalar o Node!'
DIR=~/datasentrysite
node -v
if [ $? != 0 ];
then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
        export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        source ~/.bashrc
        nvm install --lts
fi

echo 'Baixando e clonando o DataSentry Site'

if [ -d '$DIR' ];
then
        git clone https://GuilhermeDelfino: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@github.com/AccentureSPtech2ADSA/Data-Sentry-Website $DIR
fi

cd $DIR

cp .env ./app/

echo "Clonado com sucesso no diretório $DIR"

