#!/bin/bash

dotfiles=${PWD}

ln -sfn  ${dotfiles}/.bashrc    ${HOME}/
ln -sfn  ${dotfiles}/.gitconfig ${HOME}/
ln -sfn  ${dotfiles}/.emacs.d   ${HOME}/
ln -sfn  ${dotfiles}/.inputrc   ${HOME}/

read -p "Please set your \'user name\' on git" git_user_name
git config --global user.name ${git_user_name}
read -p "Please set your \'email\' on git" git_email
git config --global user.email ${git_email}
