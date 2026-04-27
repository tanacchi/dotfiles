#!/usr/bin/env bash
set -euo pipefail

if command -v apt >/dev/null 2>&1; then
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
elif command -v brew >/dev/null 2>&1; then
  brew update
  brew upgrade
fi

if command -v mise >/dev/null 2>&1; then
  mise upgrade
fi

if command -v vim >/dev/null 2>&1; then
  vim +'PlugUpgrade' +'PlugUpdate --sync' +qa
fi
