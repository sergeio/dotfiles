PROMPT_COLOR=$fg[green]
PROMPT_ERROR=$fg[red]
PR_NO_COLOR="%{$terminfo[sgr0]%}"

PROMPT='$(get_exit_code_color)%2c%{$reset_color%}%(!.#.$) '
RPROMPT='$(check_git_status) $(parse_git_branch)'
