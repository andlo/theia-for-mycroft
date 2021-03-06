#!/bin/bash
export NVM_DIR=$(pwd)/nvm

echo "Cleaning up..."
rm gen-webpack.config.js
rm webpack.config.js
rm yarn.lock
rm -rf lib
rm -rf node_modules
rm -rf nvm
rm -rf plugins
rm -rf src-gen
rm .yarnclean

echo "Installing nvm..."
mkdir $NVM_DIR
curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  >/dev/null 2>/dev/null # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  >/dev/null 2>/dev/null # This loads nvm bash_completion

mkdir $(pwd)/plugins
export NODE_OPTIONS=--max_old_space_size=4096
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

echo "Intstalling node..."
nvm install 10
echo "Installling yarn..."
npm install -g yarn

echo "Building theia..."

yarn
yarn theia build
yarn autoclean --init
echo *.ts >> .yarnclean
echo *.ts.map >> .yarnclean
echo *.spec.* >> .yarnclean
yarn autoclean --force
rm -rf ./node_modules/electron*
rm -rf nvm/.cache/
yarn cache clean

echo "Building theia...OK"