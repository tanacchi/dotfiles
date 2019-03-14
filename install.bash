#!/bin/bash

set -eu

dotfiles_dir=${PWD}

function create_git_user_config()
{
  read -p "Please set your 'user name' on git : " git_user_name
  read -p "Please set your 'email' on git : " git_email
  echo -e "[user]\n\tname = ${git_user_name}\n\temail = ${git_email}\n" > ${dotfiles_dir}/.gitconfig.user
}

function link_file()
{
  if [ -e ${HOME}/${1} -a ! -L ${HOME}/${1} ]; then
    mv ${HOME}/${1} ${HOME}/${1}.backup
    echo "${1} was replaced."
  fi
  ln -sfn ${dotfiles_dir}/${1} ${HOME}/
}


if [ ! -f ${dotfiles_dir}/.gitconfig.user ]; then
  create_git_user_config
fi

declare -a dotfiles=(
  ".bashrc" ".gitconfig" ".gitconfig.user" 
  ".emacs.d" ".inputrc" ".vimrc" ".vim"
)
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
