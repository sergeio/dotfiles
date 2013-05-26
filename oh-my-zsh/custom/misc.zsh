export EDITOR=`which vim`
source ~/code/bk/bk.zsh
source `brew --prefix`/etc/profile.d/z.sh

autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line
