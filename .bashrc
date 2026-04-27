# ~/.bashrc

# Stop here for non-interactive shells.
case $- in
  *i*) ;;
  *) return ;;
esac

_path_prepend() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

_source_if_exists() {
  # shellcheck source=/dev/null
  [ -r "$1" ] && . "$1"
}

# History
HISTCONTROL=ignoreboth
HISTSIZE=50000
HISTFILESIZE=100000
shopt -s histappend
shopt -s checkwinsize

# Completion and colors
if [ -x /usr/bin/lesspipe ]; then
  eval "$(SHELL=/bin/sh lesspipe)"
fi

if command -v dircolors >/dev/null 2>&1; then
  if [ -r "$HOME/.dircolors" ]; then
    eval "$(dircolors -b "$HOME/.dircolors")"
  else
    eval "$(dircolors -b)"
  fi
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
fi

if ! shopt -oq posix; then
  _source_if_exists /usr/share/bash-completion/bash_completion
  _source_if_exists /etc/bash_completion
fi

# Base paths. Keep these before mise so mise can take precedence at the end.
_path_prepend "$HOME/.local/bin"
_path_prepend /opt/homebrew/bin
_path_prepend /usr/local/bin

bld() {
  if [ ! -e ./CMakeLists.txt ]; then
    echo "There is no CMakeLists.txt in the current directory." >&2
    return 1
  fi

  mkdir -p build
  (
    cd build || exit
    cmake ..
    make -j
  )
}

ssh-activate() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: ssh-activate <ssh-key>" >&2
    return 1
  fi

  eval "$(ssh-agent)"
  ssh-add "$1"
}

to-gif() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: to-gif <input-file>" >&2
    return 1
  fi

  local outputfile
  outputfile=$(basename "$1")
  ffmpeg -i "$1" "${outputfile%.*}.gif"
}

to-mp4() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: to-mp4 <input-file>" >&2
    return 1
  fi

  local outputfile
  outputfile=$(basename "$1")
  ffmpeg -i "$1" -vcodec copy "${outputfile%.*}.mp4"
}

to-x10() {
  if [ "$#" -lt 1 ]; then
    echo "Usage: to-x10 <input-file> [speed]" >&2
    return 1
  fi

  local speed outputfile
  speed="${2:-10}"
  outputfile=$(basename "$1")
  ffmpeg -i "$1" -filter:v "setpts=PTS/${speed}" "${outputfile%.*}-x${speed}.mp4"
}

# Optional ROS workspaces.
if [ -r /opt/ros/noetic/setup.bash ]; then
  # shellcheck source=/dev/null
  . /opt/ros/noetic/setup.bash
fi

if [ -d "$HOME/works" ]; then
  for setup in "$HOME"/works/*/devel/setup.bash; do
    # shellcheck source=/dev/null
    [ -r "$setup" ] && . "$setup"
  done
fi

# Optional CUDA.
if [ -d /usr/local/cuda ]; then
  _path_prepend /usr/local/cuda/bin
  if [ -d /usr/local/cuda/lib64 ]; then
    case ":${LD_LIBRARY_PATH:-}:" in
      *":/usr/local/cuda/lib64:"*) ;;
      *) LD_LIBRARY_PATH="/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" ;;
    esac
    export LD_LIBRARY_PATH
  fi
fi

# Optional Cargo.
_source_if_exists "$HOME/.cargo/env"

export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-R'
export PATH

# mise owns language/runtime tools. Keep activation late so managed tools win.
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

# fzf shell integration, available in recent fzf builds.
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash 2>/dev/null || true)"
fi

# User aliases should load after mise so aliases can see managed tools.
_source_if_exists "$HOME/.bash_aliases"

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi
