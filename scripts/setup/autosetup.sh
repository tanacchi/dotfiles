#!/bin/sh
# This is tanacchi's auto-setup-script

# Setup shell
set -eu

# Declare file path variables
dotfiles_dir="${HOME}/dotfiles"
scripts_dir="${dotfiles_dir}/scripts"

# Update repositories and packages
sudo apt update       -y
sudo apt upgrade      -y
sudo apt dist-upgrade -y

# Install required tools
sudo apt install git terminator -y

# Clone dotfiles repository
cd ${HOME}
git clone https://github.com/tanacchi/dotfiles.git ${dotfiles_dir}

# Generate ssh keys for GitHub
mkdir "${HOME}/.ssh"
sh ${scripts_dir}/config/git_ssh_config.sh

# Install (or Build) git, vivaldi, vim
sh   ${scripts_dir}/tools/git.sh
sh   ${scripts_dir}/tools/vivaldi.sh
bash ${scripts_dir}/tools/vim.bash

rm -rf ${dotfiles_dir}

# Ending message
echo "Please make ssh key for github and access the link below to set it up."
echo "https://github.com/settings/ssh/new\n"
echo "After that, clone dotfiles with link below."
echo "git@github.com:tanacchi/dotfiles.git"
