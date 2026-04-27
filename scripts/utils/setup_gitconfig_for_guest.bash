#!/bin/bash

dotfiles_dir="$(cd "$(dirname "${0}")" || exit; pwd)/../.."
# shellcheck source=scripts/utils/functions.bash
source "${dotfiles_dir}/scripts/utils/functions.bash"

link_file ".gitconfig"

create_git_user_config
