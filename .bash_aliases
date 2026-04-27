# Navigation
alias cdd='cd "$HOME/dotfiles"'
alias cdw='cd "$HOME/works"'
alias cdp='cd ..'
alias cdpp='cd ../..'
alias cds='cd -'

# Listing
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ks='ls'
alias sl='ls'

# Editors
alias vi='vim'
alias v='vim'

# Git
alias g='git'
alias gs='git status --short'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --decorate --graph --all'

# Language/runtime shortcuts
alias py='python3'
alias pip='python3 -m pip'
alias gpp='g++'
alias g11='g++ -std=c++11'
alias g14='g++ -std=c++14'
alias g17='g++ -std=c++17'

# Safer removal when trash-cli is installed.
if command -v trash-put >/dev/null 2>&1; then
  alias rm='trash-put'
fi

# Clipboard helpers.
if command -v pbcopy >/dev/null 2>&1; then
  alias clipboard='pbcopy'
  alias paste='pbpaste'
elif command -v xsel >/dev/null 2>&1; then
  alias clipboard='xsel --clipboard --input'
  alias paste='xsel --clipboard --output'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
fi

if command -v delta >/dev/null 2>&1; then
  alias diff='delta'
fi

if command -v fzf >/dev/null 2>&1; then
  alias fzfp='fzf --preview "bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null || sed -n '\''1,200p'\'' {}"'
fi
