# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="sergei"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

# Report CPU usage for commands running longer than X seconds
REPORTTIME=2

source $ZSH/oh-my-zsh.sh

# PATH
export PATH=/usr/local/bin:/opt/local/Library/Frameworks/Python.framework/Versions/2.6/bin:~/bin:/opt/local/bin:$PATH:/bin:/sbin
export PATH="/usr/local/opt/node@12/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/node@12/lib"
export CPPFLAGS="-I/usr/local/opt/node@12/include"


export NPM_TOKEN="c77a3e20-4165-443b-966e-cacf0e312779"
export FUNRAISE="/Users/sergei/fun"
export GOPATH="/Users/sergei/go"

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

alias -g csv2=packages/campaign-site-v2

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/sergei/.sdkman"
[[ -s "/Users/sergei/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/sergei/.sdkman/bin/sdkman-init.sh"

export ASDF_DIR=$(brew --prefix asdf)
# . $HOME/.asdf/asdf.sh
# . $HOME/.asdf/completions/asdf.bash

. /usr/local/opt/asdf/asdf.sh
