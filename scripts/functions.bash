#!/bin/bash

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
