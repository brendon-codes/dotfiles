#!/usr/bin/zsh

##
## History
##
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

##
## Use Emacs Keybindings
##
bindkey -e

##
## Basic Completion options
##
zstyle :compinstall filename "${HOME}/.zshrc"
autoload -Uz compinit
compinit

##
## Various Console Options
##
setopt EXTENDED_GLOB
setopt AUTO_LIST
unsetopt MENU_COMPLETE
unsetopt AUTO_MENU

##
## Custom Prompt
##
export PS1=$'%K{4}%F{7} %? | %D{%Y-%m-%d %H:%M:%S} | %n@%M \n %~ %f%k\n'

##
## Custom Aliases
##
alias sudo="sudo "
alias emacs="/usr/bin/emacs -nw"
alias e="${HOME}/local/bin/ls.py"
alias ef="${HOME}/local/bin/ls.py --full"

##
## Basic Command Exports/Settings
##
export PATH="${PATH}:${HOME}/local/bin:${HOME}/.local/bin"
export EDITOR="/usr/bin/emacs -nw"
export LESS="--RAW-CONTROL-CHARS --quit-at-eof --quit-if-one-screen --no-init"
export PAGER="/usr/bin/less --RAW-CONTROL-CHARS --quit-at-eof --quit-if-one-screen --no-init"
