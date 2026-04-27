#!/usr/bin/env bash
set -euo pipefail

dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

find "${dotfiles_dir}" -maxdepth 1 -name '.*' \
  ! -name '.' \
  ! -name '..' \
  ! -name '.git' \
  ! -name '.gitignore' \
  ! -name '.gitmodules' \
  ! -name '.DS_Store' \
  -print |
while IFS= read -r source; do
  name="$(basename "${source}")"
  target="${HOME}/${name}"

  if [ -L "${target}" ] && [ "$(readlink "${target}")" = "${source}" ]; then
    rm "${target}"
    echo "removed ${target}"
  fi
done

rm -f "${dotfiles_dir}/.gitconfig.user"
