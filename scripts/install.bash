#!/bin/bash

# set -eu

dotfiles_dir="$(cd "$(dirname ${0})"; pwd)/../"

source ${dotfiles_dir}/scripts/functions.bash

if [ ! -f ${dotfiles_dir}/.gitconfig.user ]; then
  create_git_user_config
fi

dotfiles=`ls -a  /home/tanacchi/dotfiles/  | tr ' ' '\n' | \grep -E "^\..*$" | grep -Ev "^\.\.?$"`
for target in ${dotfiles[@]}; do
  link_file ${target}
done

terminator_config_dir="${HOME}/.config/terminator"
if [ ! -d ${terminator_config_dir} ]; then
  mkdir ${terminator_config_dir}
  ln -sfn ${dotfiles_dir}/config  ${terminator_config_dir}/
fi

if [ ! `which trash-put` ]; then
  sudo apt install trash-cli
fi

if [ ! `which xsel` ]; then
  sudo apt install xsel
fi

git submodule init && git submodule update
