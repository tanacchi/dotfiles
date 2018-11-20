#!/bin/bash

dotfiles=${PWD}

read -p "Please set your 'user name' on git : " git_user_name
read -p "Please set your 'email' on git : " git_email
echo -e "[user]\n\tname = ${git_user_name}\n\temail = ${git_email}\n" > ${dotfiles}/.gitconfig.user

ln -sfn  ${dotfiles}/.bashrc    ${HOME}/
ln -sfn  ${dotfiles}/.gitconfig ${HOME}/
ln -sfn  ${dotfiles}/.gitconfig.user ${HOME}/
ln -sfn  ${dotfiles}/.emacs.d   ${HOME}/
ln -sfn  ${dotfiles}/.inputrc   ${HOME}/

git submodule init && git submodule update
