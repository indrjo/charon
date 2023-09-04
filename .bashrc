#!/usr/bin/env sh

#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

# Set the commandline prompt.
#PS1='[\u@\h \W]\$ '
PS1='(\u@\h \w)\$ '

# Do not include commands starting with a space to the history of commands.
export HISTIGNORE='pwd: *:git status:git diff *'

# !!! Write on ~/.bash_aliases all your stuff !!!
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

