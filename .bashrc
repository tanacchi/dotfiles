# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=6000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    # PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias sl='ls'
alias ks='ls'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias s='ls -CF'
alias cdw='cd ~/works'
alias cwd='cdw'
alias cdp='cd ../'
alias cpd='cd ../'
alias cdpp='cd ../../'
alias cpdp='cd ../../'
alias cds='cd -'
alias cdd='cd ${HOME}/dotfiles'
alias remove='rm'
alias rm='trash-put'
alias em='vim'
alias ew='emacs -nw'
alias ec='emacsclient ./'
alias cm='catkin_make'
alias clipboard='xsel --clipboard --input'
alias gpp='g++'
alias g11='g++ -std=c++11'
alias g14='g++ -std=c++14'
alias g17='g++ -std=c++17'
alias bld='mkdir build -p ;cd build ;cmake .. ;make ;cd -'
alias py='python3'
alias gosh='rlwrap gosh'
alias py2='python2.7'
alias rls='rails'
alias ble='bundle'
alias arduino='cd ${HOME}/Documents/arduino-1.8.5 ;source arduino ;cd -'
alias eixt='exit'
alias shutdown='shutdown -h now'

# trash-cli
# Clone from 'https://github.com/andreafrancia/trash-cli'
if type trash-put &> /dev/null
then
    alias rm=trash-put
fi


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Functions about ssh
function ssh-activate() {
    if [ $# -ne 1 ]; then
        echo "Prease set one ssh-key"
        return
    fi
    eval `ssh-agent`
    ssh-add $1
}

function kyutech-login() {
    username="q111026d"
    hostname="remote-t.isc.kyutech.ac.jp"
    ssh -l "${username}" ${hostname}
}

function kyutech-pull() {
    if [ $# -ne 1 ]; then
        echo "Prease set file or directory which you want."
        return
    fi
    username="q111026d"
    hostname="remote-t.isc.kyutech.ac.jp"
    scp -r "${username}@${hostname}:/home/t/${username}/$1" ${PWD}
}

function kyutech-push() {
    if [ $# -ne 1 ]; then
        echo "Prease set file or directory which you want."
        return
    fi
    username="q111026d"
    hostname="remote-t.isc.kyutech.ac.jp"
    scp -r ${PWD} "${username}@${hostname}:/home/t/${username}/$1"
}

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#ROS workspace
ros_kinetic="/opt/ros/kinetic/setup.bash"

catkin_ws=(
    ${ros_kinetic}
    "${HOME}/*/*/*/opencv3mixsing/devel/setup.bash"
    "${HOME}/*/ros_practice/devel/setup.bash"
    "${HOME}/*/fourth_robot_ws/devel/setup.bash"
    "${HOME}/*/*/ros_homosapi_ws/devel/setup.bash"
    "${HOME}/works/slambot_ws/devel/setup.bash"
    "${HOME}/*/fifth_robot_pkg/devel/setup.bash"
    "${HOME}/works/imu_filter_ws/devel/setup.bash"
    "${HOME}/works/cartographer_ws/install_isolated/setup.bash"
    "${HOME}/works/blam/internal/devel/setup.bash"
) 
for target in ${catkin_ws[@]}; do
    if [ -e ${target} ]; then
        source ${target}
    fi
done
export EDITOR='emacs'

# Ruby on Rails
export PATH=$HOME/.rbenv/bin:$PATH
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

if [ `which rbenv` ]; then
  eval "$(rbenv init -)"
fi

# For point_cloud_viewer
# source $HOME/.cargo/env
# export PATH="$HOME/.cargo/bin:$PATH"

# Greeting
echo -e "\e[32;1m${USER}@${HOSTNAME}\e[m:\e[34;1m~\e[m$"
echo -e "\e[1m Hi, ${USER} !!\e[m"
