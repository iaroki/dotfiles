#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1="\[\033[33;1m\]\w\[\033[m\] \[\033[34;1m\]\$(git branch 2>/dev/null | grep '^*' | colrm 1 2) \[\033[31;1m\]>\[\033[33;1m\]>\[\033[32;1m\]>\[\033[m\] "
PS2="\[\033[34;1m\]== \[\033[31;1m\]>\[\033[33;1m\]>\[\033[32;1m\]>\[\033[m\] "

alias ls='ls --color=auto'
alias ll='ls -la'

