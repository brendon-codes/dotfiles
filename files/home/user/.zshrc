#!/usr/bin/zsh

##
## Misc Shell
##
HISTFILE="${HOME}/.histfile"
HISTSIZE=100000
SAVEHIST=100000
zstyle :compinstall filename "${HOME}/.zshrc"
fpath=(~/.zfunc $fpath)
autoload -Uz compinit
compinit
setopt EXTENDED_GLOB
setopt AUTO_LIST
setopt globdots
zstyle ':completion:*' special-dirs true
unsetopt MENU_COMPLETE
unsetopt AUTO_MENU
setopt HIST_IGNORE_SPACE

##
## Vim Mode
##
bindkey -v
bindkey -M vicmd "/" history-incremental-pattern-search-backward
zle -N history-incremental-pattern-search-backward
bindkey -M vicmd 'gk' vi-end-of-line
bindkey -M vicmd 'gj' vi-beginning-of-line
bindkey '^?' backward-delete-char

##
## Prompt
##
P_S_NL=$'\n'
P_C_B1="%{$(tput setaf 39)%}"
P_C_B2="%{$(tput setaf 81)%}"
P_C_G1="%{$(tput setaf 77)%}"
P_C_Y1="%{$(tput setaf 226)%}"
P_C_X="%{$(tput sgr0)%}"
P_F_DAT="%D{%Y-%m-%d %I:%M:%S%p %z %Z}"
P_F_USR="%n"
P_F_HST="%M"
P_F_PTH="%~"
export PS1="${P_C_B1}${P_F_DAT} | ${P_C_B2}${P_F_USR}${P_C_G1}@${P_F_HST}${P_S_NL}${P_C_Y1}${P_F_PTH}${P_C_X}${P_S_NL}"

##
## Aliases
##
alias g="/usr/bin/git"
alias ga="g a"
alias ga-p="g a-p"
alias gb="g b"
alias gd="g d"
alias gf="g f"
alias gss="g ss"
alias gch="g ch"
alias gco="g co"
alias gl="g l"
alias gm="g m"
alias gpul="g pul"
alias gpul-f="g pul-f"
alias gpus="g pus"
alias gpus-f="g pus-f"
alias gres="g res"
alias gres-h="g res-h"
alias gref="g ref"
alias greb="g reb"
alias emacs="/usr/bin/emacs -nw"
alias e="${HOME}/local/bin/els"
alias ef="${HOME}/local/bin/els --full"
alias vi="/usr/bin/nvim"

##
## Path
##
export PATH="${PATH}:${HOME}/local/scripts:${HOME}/local/bin:${HOME}/.local/bin:${HOME}/.npm-global/bin"

##
## Defaults
##
export EDITOR="/usr/bin/nvim"
export LESS="--RAW-CONTROL-CHARS --quit-at-eof --quit-if-one-screen --no-init"
export PAGER="/usr/bin/less --RAW-CONTROL-CHARS --quit-at-eof --quit-if-one-screen --no-init"

