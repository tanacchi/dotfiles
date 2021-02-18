#!/bin/sh

PKG_COMMAND="${PKG_COMMAND:-apt -y}"
sudo $PKG_COMMAND install \
     build-essential \
     libssl-dev \
     zlib1g-dev \
     libbz2-dev \
     libreadline-dev \
     libsqlite3-dev \
     wget \
     curl \
     llvm \
     libncurses5-dev \
     libncursesw5-dev \
     xz-utils \
     tk-dev \
     libffi-dev \
     liblzma-dev \
     python-openssl \
     git

git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo "pyenv cloned"
