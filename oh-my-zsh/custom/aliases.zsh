alias search='grep -r -i --binary-files=without-match'
alias agg='ag --ignore tags'
alias agt="ag --ignore=third_party --ignore=tags --ignore='*_test.*'"
alias ag='ag --ignore=third_party --ignore=tags'
alias agp="ag --ignore=third_party --ignore=tags --ignore=third_party --ignore='*.(js)(jsx)(html)(less)(css)'"

# alias workoff='deactivate'
alias tmux='tmux -2'
alias j=z
alias jj='cd ~/khan/webapp'
alias v='vagrant'
alias vs='vagrant status | grep -v -e "Current VM" -e "This environment" -e "above with" -e "VM, run" | sed "/^$/d" | sort'
alias vss="vs | grep -v 'not created'"
alias vsshh="ssh -q -F ./.ssh_config"
alias vu='vagrant up'
alias vd='vagrant destroy'
alias updatedb='sudo /usr/libexec/locate.updatedb'
alias t='./tools/runtests.py'
alias tsat='./tools/runtests.py api.internal.test.sat_test sat'

alias gs=''

alias g='git'
alias gr="GIT_EDITOR=\"vim -c \\\"1,'}-1s/\n/\rx git diff origin\/master | pep8 --diff --count --exclude \\\"__init__.py\\\"\r/g | nohlsearch \\\"\" git rebase -i"

alias mfiles='git diff master --name-only --diff-filter=ACMR'
alias dlint='(mfiles | grep -v "^tests/" | grep ".py$" | xargs bin/pylint); (mfiles | grep "^tests/" | grep ".py$" | xargs bin/pylint | grep 'Unused')'
alias dpep8='mfiles | grep ".py$" | xargs bin/pep8 -r'
alias dint='make integration-coverage 2>&1 | egrep `mfiles | sed "s/\//\./g" | sed "s/\.py$//g" | xargs | sed "s/ /|/g"` | grep -v "100%"'
alias dcov='make coverage 2>&1 | egrep `mfiles | sed "s/\//\./g" | sed "s/\.py$//g" | xargs | sed "s/ /|/g"` | grep -v "100%"'
alias num_lines='git diff master | grep -E "^[+-]([^+-]|$)" | wc -l'

alias resolutionl='cp ~/Documents/movewindows/resolutionLaptop ~/Documents/movewindows/resolution'
alias resolutione='cp ~/Documents/movewindows/resolutionExternal ~/Documents/movewindows/resolution'

alias webshare='python -m SimpleHTTPServer'

# alias -g G='| grep'

alias mi='make integration-test'
alias mtdd='make tdd 2>&1| lolcat'
alias mt='make test'
alias mu='make unit-test'
