# dotfiles

Personal dotfiles for macOS and Linux, centered on Vim, bash, mise, fzf, and fast CLI search.

## Installation

### From a Fresh Machine

Clone and install in one command:

```sh
curl -L https://tanacchi.github.io/dotfiles | bash
```

This downloads the bootstrap script, clones this repository into `~/dotfiles`,
installs or repairs `mise`, links dotfiles into `$HOME`, and runs `mise install`.

### From an Existing Clone

Run this from the repository root:

```sh
python3 scripts/setup/install.py --install-mise --install-tools
```

For a dry run:

```sh
python3 scripts/setup/install.py --dry-run --install-mise --install-tools
```

The installer creates symlinks into `$HOME` and moves existing files to timestamped
`.backup.*` paths before replacing them.

## Daily Commands

```sh
mise run doctor       # check required commands
mise run install      # install tools from mise.toml
mise run vim:plugins  # install/update Vim plugins
mise run update       # upgrade mise tools and Vim plugins
mise run lint:shell   # shellcheck dotfiles scripts
```

## Vim

Vim uses `vim-plug` and auto-bootstraps `~/.vim/autoload/plug.vim` on first start.

Main mappings:

```text
<Space>f  files
<Space>F  git files
<Space>g  ripgrep
<Space>b  buffers
<Space>h  history
<Space>x  run ALE fixers
[d / ]d   previous/next diagnostic
gd / gr   definition/references when ALE can provide them
```

## Tooling

`mise.toml` owns language runtimes and CLI tools. Keep shell-specific PATH edits
small and let `mise activate bash` run late in `.bashrc` so managed tools win.

If `mise` itself is broken or missing, reinstall it first:

```sh
brew install mise
# or
curl https://mise.run | sh
```

If `mise install` fails around `aqua:mvdan/sh` / `sha256sums.txt`, upgrade
`mise` first. `shfmt` is pinned in `mise.toml` to avoid this known old-registry
failure during bootstrap.
