#!/bin/bash

set -eu

sudo apt update
# sudo apt build-dep vim
sudo apt install -y git \
                    gettext \
                    libtinfo-dev \
                    libacl1-dev \
                    libgpm-dev \
                    build-essential \
                    libxmu-dev \
                    libgtk2.0-dev \
                    libxpm-dev \
                    libperl-dev \
                    python-dev \
                    python3-dev \
                    ruby-dev \
                    lua5.2 \
                    liblua5.2-dev

git clone "https://github.com/vim/vim.git" ./vim
cd ./vim
./configure --with-features=huge --enable-gui=gtk2 --enable-perlinterp=yes --enable-pythoninterp=yes --enable-python3interp=yes --enable-rubyinterp=yes --enable-luainterp=yes
sudo make install
cd -
trash-put -rf ./vim
