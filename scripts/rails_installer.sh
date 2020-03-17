#!/bin/bash

./update.sh

sudo apt-get install git \
                     curl \
                     zlib1g-dev \
                     build-essential \
                     libssl-dev \
                     libreadline-dev \
                     libyaml-dev \
                     sqlite3 \
                     libsqlite3-dev 

if [ ! `which rbenv` ]; then
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv

  export PATH=$HOME/.rbenv/bin:$PATH
  source ~/.bashrc
  hash -r

  eval "$(rbenv init -)"

  source ~/.bashrc
  hash -r

  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

  source ~/.bashrc
  hash -r
  echo $PATH

  rbenv install -l
  rbenv install 2.5.1

  echo 'gem: --no-ri --no-rdoc' > ~/.gemrc

  rbenv global 2.5.1
  rbenv rehash
  gem i rbenv-rehash

  gem i rails -v 5.1.6

  gem install sqlite3 -v '1.3.13'
fi

gem cleanup
gem list
gem -v
rails -v
