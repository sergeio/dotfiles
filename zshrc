# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="sergei"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
# export PATH=~/bin:/opt/local/bin:/usr/local/bin:/Users/sergeio/bin:/opt/local/Library/Frameworks/Python.framework/Versions/2.6/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/opt/local/bin:/Users/sergeio/bin:/opt/local/Library/Frameworks/Python.framework/Versions/2.6/bin
# export PATH=/opt/local/Library/Frameworks/Python.framework/Versions/Current/bin:~/bin:/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin
export PATH=/usr/local/bin:/opt/local/Library/Frameworks/Python.framework/Versions/2.6/bin:~/bin:/opt/local/bin:$PATH:/bin:/sbin
export PATH="/usr/local/opt/node@12/bin:$PATH"
export NPM_TOKEN="c77a3e20-4165-443b-966e-cacf0e312779"
export FUNRAISE="/Users/sergei/fun"

export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

if [ -f ~/bin/tmuxinator.zsh ]; then
    source ~/bin/tmuxinator.zsh
fi

if [[ ! $TERM =~ screen ]]; then
    exec tmux
fi

if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
    ssh-add ~/.ssh/*_rsa
    clear
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
