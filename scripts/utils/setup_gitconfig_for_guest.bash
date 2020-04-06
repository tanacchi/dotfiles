#!/bin/bash

dotfiles_dir="$(cd "$(dirname ${0})"; pwd)/../"
source ${dotfiles_dir}/scripts/utils/functions.bash

curl https://raw.githubusercontent.com/tanacchi/dotfiles/master/.gitconfig > ${HOME}/.gitconfig

create_git_user_config
