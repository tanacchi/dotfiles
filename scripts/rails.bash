#/bin/bash

sudo apt update
sudo apt-get install autoconf \
                     build-essential \
                     curl \
                     libreadline-dev \
                     libsqlite3-dev
                     libssl-dev \
                     libyaml-dev \
                     sqlite3 \
                     zlib1g-dev \

if [ `which rbenv` ]; then
  echo "Rails has already been installed."
  exit 0
fi

# Install rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

cd ~/.rbenv && src/configure && make -C src && cd -
export PATH=$HOME/.rbenv/bin:$PATH

eval "$(rbenv init -)"

source ~/.bashrc
hash -r

# Install Ruby

rbenv rehash
RUBY_VERSION="2.5.3"
echo "Installing Ruby (version ${RUBY_VERSION})"
rbenv install -l
rbenv install ${RUBY_VERSION}
rbenv global ${RUBY_VERSION}
gem i rbenv-rehash

echo 'gem: --no-ri --no-rdoc' > ~/.gemrc

# Install Rails

gem list rails
gem install rails

# Exiting script
gem cleanup
gem list
gem -v
rails -v
