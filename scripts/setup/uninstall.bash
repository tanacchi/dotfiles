#!/bin/bash

# set -eu

dotfiles_dir="$(cd "$(dirname ${0})"; pwd)/../"

declare -a dotfiles=(
  ".bashrc" ".gitconfig" ".gitconfig.user" 
  ".emacs.d" ".inputrc" ".vimrc" ".vim"
)

for target in ${dotfiles[@]}; do
  if [ -e "${HOME}/${target}" ]; then
    rm "${HOME}/${target}"
  fi

  if [ -e "${HOME}/${target}.backup" ]; then
    mv "${HOME}/${target}.backup" "${HOME}/${target}"
  fi
done

if [ ! -e "${HOME}/.bashrc" ]; then
  cp "/etc/skel/.bashrc" "${HOME}"
fi

rm "${dotfiles_dir}/.gitconfig.user"
