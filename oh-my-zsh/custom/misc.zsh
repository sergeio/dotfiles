export EDITOR=`which vim`
# source `brew --prefix`/etc/profile.d/z.sh
source ~/code/z/z.sh

autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line
