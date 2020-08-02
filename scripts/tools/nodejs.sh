#!/bin/sh

VERSION=$1
if [ $# -ne 1 ]; then
  echo "Pease specify version on Nodejs."
  exit 1
fi
echo "Installing Nodejs (version $1)"
sudo apt install curl software-properties-common
echo "https://deb.nodesource.com/setup_${VERSION}.x"
curl -sL "https://deb.nodesource.com/setup_${VERSION}.x" | sudo bash -
sudo apt install nodejs npm -y

sudo npm install n -g
sudo n stable

sudo apt remove --purge -y nodejs
exec $SHELL

node -v
