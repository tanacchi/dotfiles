#!/bin/bash

dotfiles_dir="$(cd "$(dirname ${0})"; pwd)/../.."
source ${dotfiles_dir}/scripts/utils/functions.bash

link_file ".gitconfig"

create_git_user_config
