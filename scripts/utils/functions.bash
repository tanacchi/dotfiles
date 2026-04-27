#!/bin/bash

function create_git_user_config()
{
  : "${dotfiles_dir:?}"
  read -r -p "Please set your 'user name' on git : " git_user_name
  read -r -p "Please set your 'email' on git : " git_email
  printf "[user]\n\tname = %s\n\temail = %s\n" "${git_user_name}" "${git_email}" > "${dotfiles_dir}/.gitconfig.user"
}

function link_file()
{
  : "${dotfiles_dir:?}"
  if [ -e "${HOME}/${1}" ] && [ ! -L "${HOME}/${1}" ]; then
    mv "${HOME}/${1}" "${HOME}/${1}.backup"
    echo "${1} was replaced."
  fi
  ln -sfn "${dotfiles_dir}/${1}" "${HOME}/"
}
