#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '
alias vim='nvim'

shopt -s autocd
shopt -s cdspell
shopt -s cmdhist
# shopt -s expand_aliases

alias tb="nc termbin.com 9999"

alias grep='grep --color=auto'
alias ls='ls --color=auto'

alias vim="nvim"
alias config='/usr/bin/git --git-dir=/home/www/.dotfiles/ --work-tree=/home/www'

#set -o vi
alias vimrc="nvim ~/.config/nvim/init.vim"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
alias ll='exa -lF --color=always --group-directories-first'
alias ls='exa -lF --color=always --group-directories-first'

source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash
