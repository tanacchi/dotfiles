#!/bin/sh

dotfiles=${PWD}

ln -sfn  ${dotfiles}/.bashrc           ${HOME}/
ln -sfn  ${dotfiles}/.gitconfig        ${HOME}/
ln -rsfn ${dotfiles}/.emacs.d/init.el  ${HOME}/.emacs.d/
ln -sfn  ${dotfiles}/.inputrc          ${HOME}/
