#!/bin/bash

# set -eu

dotfiles_dir="$(cd "$(dirname ${0})"; pwd)/../.."
echo "${dotfiles_dir}"
dotfiles=`ls -A "${dotfiles_dir}/" | tr ' ' '\n' | grep -E "^\..*$" | grep -Ev "^\.(git|terminator|gitmodules|gitignore)$"`
echo "${dotfiles[@]}"
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
