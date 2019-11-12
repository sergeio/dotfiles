f () {
    find . -iname $(sed 's/\(.\)/\1*/g' <<< $1) \
        -not \( -path './genfiles/*' -prune \) \
        -not \( -path './.git/*' -prune \) \
        -not \( -name '*.pyc' \)
}

difiles () {
    git status --porcelain | awk '{print $2}'
}

g-() {
    if [[ -z "$*" ]]; then
        git checkout -
    else
        git checkout @{-$1}
    fi
}

pg() {
    (
        cd ~/fun/funraise-orchestra;
        if [[ $1 ]]; then
            docker-compose exec platformdb psql -U postgres funraise -c "$1;"
        else
            docker-compose exec platformdb psql -U postgres funraise
        fi
    )
}

alarm () {
    osascript -e "set Volume 2.4"
    sleep_until $1
    while sleep 4; do
        say wake
    done
}

pycd () {
    # cd to a Python package's source directory
    cd `python -c "import os.path, $1; print(os.path.dirname($1.__file__))"`;
}

tloop () {
    difiles | watchfiles "clear; date; ./tools/runtests.py $1"
}

todo_2 () {
    # Usage: todo <name> <optional flag string eg. STOPSHIP>`
    # All of a user's TODOs, ordered by date
    _groupby_grep_file_output () {
        # Groups filename:1\nfilename:2 into filename:1,2
        awk -F: '{if ($1 in arr)
                      arr[$1] = (arr[$1] "," $2)
                  else
                      arr[$1] = $2}
                  END {
                      for (key in arr) printf("%s:%s\n", key, arr[key])
                 }'
    }

    _nums_to_blame_opts () {
        # Turn "1,2,3" into "-L 1,1 -L 2,2 -L 3,3"
        opts=""
        for num in $(sed 's/,/ /g' <<< $1); do
            opts="$opts -L $num,$num"
        done
        echo "$opts"
    }

    _grep_to_blame () {
        while read LINE; do
            filename=$(cut -d: -f1 <<< $LINE)
            line_nums=$(cut -d: -f2 <<< $LINE)
            blame_line_opts=$(_nums_to_blame_opts $line_nums)
            eval "git blame --show-name --show-number $blame_line_opts $filename"
        done
    }

    _transform_blame_line () {
        # Replace hash with date, remove committer name
        while read blame_line; do
            hsh=$(cut -d' ' -f1 <<< $blame_line)
            rest=$(cut -d' ' -f2- <<< $blame_line)
            # Remove '(Committer M. Name 2020-01-01 99:99 -7000 123)    '
            rest=$(sed 's/([^)]*) *//' <<< $rest)
            date=$(git show -s --format='%ad' --date=short $hsh)
            echo "$date $rest"
        done
    }

    git grep -n "${2:-TODO}($1)" \
        | _groupby_grep_file_output \
        | _grep_to_blame \
        | _transform_blame_line \
        | sort
}

KNIFEPROD (){
  knife "$@" -c ~/.chef_PROD/knife.rb
}
sssh (){
    ssh -t $* 'tmux -2 attach || tmux -2 new';
}
vssh () {
    ssh -q -F ~/repos/infrastructure_services/.ssh_config $1 -t 'sudo su -'
}
pull_request(){
    # If no remote specified, default to 'aweber'
    if (( $# == 0 )); then 1="aweber"; fi
    open http://github.colo.lair/$1/$(pwd | sed 's/.*\///')/pull/new/$(parse_git_branch)
}

testfileo(){
    ulimit -n 1024
    project=$(pwd | sed -e 's/.*\///' -e 's/-/_/g')
    upper_project=$(echo $project | tr a-z A-Z)
    find $project tests -type f -name '*.py' | watchfiles "source bin/activate; eval ${upper_project}_CONF=$(find . -name 'development.conf') bin/nosetests $@"
}

testfile(){
    ulimit -n 1024
    project=$(pwd | sed -e 's/.*\///' -e 's/-/_/g')
    upper_project=$(echo $project | tr a-z A-Z)
    find $project tests -type f -name '*.py' | watchfiles "source bin/activate; eval ${upper_project}_CONF=../configuration/development.conf bin/nosetests ${@/tests\//}"
}

wiki(){
    dig +short txt "$@".wp.dg.cx;
}

notified_complaint_ratios_login(){
    curl -s 'reputation/v1/reputations?sort=date:desc&limit=61&filter=list_id:'`get_one_most_recently_notified_list_id_for_account $1` |
    python ~/bin/complaint_ratios.py |
    xargs spark
}

notified_complaint_ratios_aid(){
    local LOGIN=`convert account_id login_name $1`
    local LIST=`get_one_most_recently_notified_list_id_for_account $LOGIN`
    curl -s 'reputation/v1/reputations?sort=date:desc&limit=61&filter=list_id:'$LIST |
    python ~/bin/complaint_ratios.py |
    xargs spark
}

accounts_notified_days_ago(){
    curl -s 'reputation/v1/notifications?filter=date:'`date -v-$1d '+%Y-%m-%d'`'&limit=1000&filter=notified:notified' |
    python -c 'import json; print "\n".join([str(int(n["account_id"])) for n in json.loads(raw_input())["content"]])'
}

times_notified_aid(){
    curl -s 'reputation/v1/notifications?filter=account_id:'$1 |
    python -c 'import json; print len(json.loads(raw_input())["content"])'
}

graph_notified_days_ago(){
    accounts_notified_days_ago $1 | graph_aids
}

graph_diff_notified_yesterday_16_days_ago(){
    accounts_notified_16_days_ago_but_not_yesterday | graph_aids
}

old_graph_notified_days_ago(){
    for aid in `accounts_notified_days_ago $1`
    do
        echo $(convert account_id login_name $aid) \#$(times_notified_aid $aid)
        notified_complaint_ratios_aid $aid
    done
}


graph_aids(){
    while read aid
    do
        echo $(convert account_id login_name $aid) \#$(times_notified_aid $aid)
        notified_complaint_ratios_aid $aid
        echo
    done
}

lookup(){
    curl -s 'http://puppet-bridge.colo.lair:11003/v1/reputations'$1 |
    python -c 'import pprint, json; pprint.pprint(json.loads(raw_input())["content"])'
}

aid_from_login(){
    curl -s 'reputation/v1/reputations?filter=login_name:'$1'&limit=1' |
    python -c 'import json; print json.loads(raw_input())["content"][0]["account_id"]'
}

accounts_notified_16_days_ago_but_not_yesterday(){
    diff <(accounts_notified_days_ago 16 | sort) <(accounts_notified_days_ago 1 | sort) |
    grep '^<' |
    sed 's/^< //'
}

# convert(){
#     curl -s 'http://puppet-bridge.colo.lair:11003/v1/reputations?filter='$1':'$3'&limit=1' |
#     python -c "import json; print json.loads(raw_input())['content'][0][\\"$2\\"]"
# }

get_one_most_recently_notified_list_id_for_account(){
    curl -s 'reputation/v1/notifications?sort=date:desc&limit=1&filter=notified:notified&filter=account_id:'`aid_from_login $1` |
    python -c 'import json; print json.loads(raw_input())["content"][0]["lists"][0]'
}


show(){
    # download and open image that matches args
    args=$*
    TMPDIR=/tmp/pictures
    ((curl -q ${args// /%20}.jpg.to 2>/dev/null |
    sed -e 's/<img .*src="//' -e 's/" \/>//' |
    xargs wget -q -O $TMPDIR/${args// /_}.jpg &&
        ristretto $TMPDIR/${args// /_}.jpg) &)
}

rprompt_on() {
    export IGNOREGIT=''
}
rprompt_off() {
    export IGNOREGIT=y
}
on () { rprompt_on }
off () { rprompt_off }

rprompt() {
    if [ -z "$IGNOREGIT" ]; then
        echo "$(check_git_status) $(parse_git_branch)"
    fi
}

# check_git_status() {
# This is nice, but no faster than my original function
# # http://stackoverflow.com/questions/2657935/checking-for-a-dirty-index-or-untracked-files-with-git
    # local EVERYTHING_COMMITTED
    # local NO_UNTRACKED
    # EVERYTHING_COMMITTED=$(git diff-index --quiet HEAD)
    # NO_UNTRACKED=$(test -z "$(git ls-files --others --exclude-standard)")
    # if $EVERYTHING_COMMITTED && $NO_UNTRACKED; then
        # echo "%{$fg[red]%}+%{$reset_color%}"
    # fi
# }

check_git_status() {
    if [[ ! -d .git/ ]]; then
        return
    fi
    if [[ ! -z $(git status -s) ]]; then
        echo "%{$fg[red]%}+%{$reset_color%}"
    fi
}

parse_git_branch() {
    git branch --no-color 2> /dev/null |
    sed -e '/^  /d' -e 's/* \(.*\)/\1/'
}

get_exit_code_color() {
    if [[ $? != 0 ]]; then
        COLOR=$PROMPT_ERROR
    else
        COLOR=$PROMPT_COLOR
    fi
    echo %{$COLOR%}
}

function percent_charge () {
    if [[ `uname` == 'Linux' ]]; then
      current_charge=$(cat /proc/acpi/battery/BAT0/state | grep 'remaining capacity' | awk '{print $3}')
      total_charge=$(cat /proc/acpi/battery/BAT0/info | grep 'last full capacity' | awk '{print $4}')
    else
      battery_info=`ioreg -rc AppleSmartBattery`
      current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | awk '{print $3}')
      total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | awk '{print $3}')
    fi

    percent=`echo "$current_charge/$total_charge * 100" | bc -l | cut -d '.' -f 1`
    echo $percent%
}

function eg(){
    if [[ `uname` == 'Linux' ]]; then
        MAN_KEEP_FORMATTING=1 man "$@" 2>/dev/null \
            | sed --quiet --expression='/^E\(\x08.\)X\(\x08.\)\?A\(\x08.\)\?M\(\x08.\)\?P\(\x08.\)\?L\(\x08.\)\?E/{:a;p;n;/^[^ ]/q;ba}' \
            | ${MANPAGER:-${PAGER:-pager -s}}
    else
        man $1 | grep '^EXAMPLES' -A 1000 #| grep '^[A-Z]' -m 2 -B 1000 -A 0 | sed '$d' | $PAGER
    fi
}



copy_paste_tmux() {
    (
        (
            if test -n "`tmux showb 2> /dev/null`"; then
                tmux saveb - | pbcopy
            fi
        ) &
    ) 2> /dev/null
}

# copy_paste_tmux() {
    # (
        # (
            # while true; do
                # if test -n "`tmux showb 2> /dev/null`"; then
                    # tmux saveb - | pbcopy
                # fi
                # sleep 0.5
            # done
        # ) &
    # ) 2> /dev/null
# }

start_reputation_tmux() {
    local BASE="$HOME/repos"
    local KEY="~/.ssh/ubuntu_rsa"
    tmux start-server

    tmux new-session -d -s rep -n main
    tmux send-keys -t rep:0 "cd $BASE/reputation" C-m
    tmux split-window -t rep:0 -p 15
    tmux send-keys -t rep:0 "cd $BASE/reputation; make tdd" C-m

    tmux new-window -t rep:1 -n i-s
    tmux send-keys -t rep:1 "cd $BASE/infrastructure_services; vs; v up evo" C-m

    tmux new-window -t rep:4 -n STAGING
    tmux send-keys -t rep:4 "ssh -i $KEY ubuntu@s-reputation-worker1" C-m
    tmux split-window -t rep:4
    tmux send-keys -t rep:4 "ssh -i $KEY ubuntu@s-reputation-mongo1" C-m

    tmux select-window -t rep:0
    tmux select-pane -t 0
    tmux attach-session -t rep
}
