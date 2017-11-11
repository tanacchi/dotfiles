#!/bin/sh

dotfiles=${PWD}

ln -sfn  ${dotfiles}/.bashrc    ${HOME}/
ln -sfn  ${dotfiles}/.gitconfig ${HOME}/
ln -sfn  ${dotfiles}/.emacs.d   ${HOME}/
ln -sfn  ${dotfiles}/.inputrc   ${HOME}/
