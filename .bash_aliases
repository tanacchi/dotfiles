alias ble='bundle'
alias cb='catkin build'
alias cdd='cd ${HOME}/dotfiles'
alias cdp='cd ../'
alias cdpp='cd ../../'
alias cds='cd -'
alias cdw='cd ~/works'
alias clipboard='xsel --clipboard --input'
alias cm='catkin_make'
alias cpd='cd ../'
alias cpdp='cd ../../'
alias cwd='cdw'
alias ec='emacsclient ./'
alias eixt='exit'
alias em='emacs'
alias ew='emacs -nw'
alias flatten='xsel --clipboard --output | tr "\n"" "  " | xsel --clipboard --input'
alias g11='g++ -std=c++11'
alias g14='g++ -std=c++14'
alias g17='g++ -std=c++17'
alias gosh='rlwrap gosh'
alias gpp='g++'
alias grep='grep -n --color=auto'
alias ic="ibmcloud"
alias ks='ls'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias paste='xsel --clipboard --output'
alias pip2='pip'
alias pip='pip3'
alias py2='python2.7'
alias py='python3'
alias remove='rm'
alias rls='rails'
alias rm='trash-put'
alias rusti='evcxr'
alias s='ls -CF'
alias shutdown='shutdown -h now'
alias sl='ls'

# trash-cli
# Clone from 'https://github.com/andreafrancia/trash-cli'
if type trash-put &> /dev/null
then
    alias rm=trash-put
fi

if type emacsclient &> /dev/null; then
  alias vi='emacsclient -nw -a ""'
else
  alias vi='vim'
fi
