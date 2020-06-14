#!/bin/bash

# set -eu

dotfiles_dir="$(cd "$(dirname ${0})"; pwd)/../.."

source ${dotfiles_dir}/scripts/utils/functions.bash

if [ ! -f ${dotfiles_dir}/.gitconfig.user ]; then
  create_git_user_config
else
  echo "dotfiles are already installed."
  exit 0
fi

dotfiles=`ls -A "${dotfiles_dir}/" | tr ' ' '\n' | grep -E "^\..*$" | grep -Ev "^\.(git|terminator|gitmodules|gitignore)$"`
echo -e "Following file will be installed:\n${dotfiles[@]}"
for target in ${dotfiles[@]}; do
  link_file ${target}
done

terminator_config_dir="${HOME}/.config/terminator"
if [ ! -d ${terminator_config_dir} ]; then
  mkdir -p ${terminator_config_dir}
fi
if [ -f "${terminator_config_dir}/config" ]; then
  mv "${terminator_config_dir}/config" "${terminator_config_dir}/config.backup"
fi
ln -sfn "${dotfiles_dir}/.terminator" "${terminator_config_dir}/config"

git submodule init && git submodule update
