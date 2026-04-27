# Agent Guide

This repository is a personal dotfiles workspace.

## Layout

- `.vimrc` is the primary editor configuration. Keep it compatible with Vim 9.
- `.bashrc` should stay portable across macOS and Linux bash.
- `mise.toml` owns developer tools and maintenance tasks.
- `scripts/setup/install.py` is the local installer used by the curl bootstrap.
- `docs/index.html` is intentionally a shell script served by GitHub Pages.

## Conventions

- Prefer `mise` for language runtimes and CLI tools instead of pyenv, rbenv, or hand-built PATH entries.
- Prefer `rg`, `fd`, `fzf`, `bat`, and `delta` for interactive CLI workflows.
- Keep AI-facing docs concise: include commands, ownership, and expected behavior.
- Do not add editor AI plugins unless explicitly requested.

## Checks

Run these before committing changes:

```sh
python3 -m py_compile scripts/setup/install.py scripts/setup/autosetup.py
bash -n .bashrc .bash_aliases scripts/setup/uninstall.bash scripts/utils/update.sh docs/index.html
vim -Nu .vimrc -n --not-a-term +'set nomore' +qa
```

If `mise` is healthy:

```sh
mise run doctor
mise run lint:shell
```
