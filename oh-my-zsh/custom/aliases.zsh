# alias ls='ls -G'
# alias getw='wget -r -np'
alias search='grep -r -i --binary-files=without-match'
# alias grep='grep --color=auto'

# alias workoff='deactivate'
alias v='vagrant'
alias vs='vagrant status'
alias vu='vagrant up'
alias vd='vagrant destroy'
alias updatedb='sudo /usr/libexec/locate.updatedb'

alias gs=''

alias g='git'

alias mfiles='git diff master --name-only --diff-filter=ACMR'
alias dlint='(mfiles | grep -v "^tests/" | grep ".py$" | xargs bin/pylint); (mfiles | grep -e "^tests/" -e ".py$" | xargs bin/pylint | grep 'Unused')'
alias dpep8='mfiles | grep ".py$" | xargs bin/pep8 -r'
alias dint='make integration-coverage 2>&1 | egrep `mfiles | sed "s/\//\./g" | sed "s/\.py$//g" | xargs | sed "s/ /|/g"` | grep -v "100%"'
alias dcov='make coverage 2>&1 | egrep `mfiles | sed "s/\//\./g" | sed "s/\.py$//g" | xargs | sed "s/ /|/g"` | grep -v "100%"'
alias num_lines='git diff master | grep -E "^[+-]([^+-]|$)" | wc -l'

alias resolutionl='cp ~/Documents/movewindows/resolutionLaptop ~/Documents/movewindows/resolution'
alias resolutione='cp ~/Documents/movewindows/resolutionExternal ~/Documents/movewindows/resolution'

alias webshare='python -m SimpleHTTPServer'

alias -g G='| grep'

alias mi='make integration-test'
alias mtdd='make tdd 2>&1| lolcat'
alias mt='make test'
alias mu='make unit-test'
