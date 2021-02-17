#!/bin/sh

echo \
"Host github
  HostName github.com
  User git
  IdentityFile ~/.ssh/github
  IdentitiesOnly yes
  TCPKeepAlive yes" >> "${HOME}/.ssh/config"
