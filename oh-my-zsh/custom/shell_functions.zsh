pull_request(){
    # If no remote specified, default to 'aweber'
    if (( $# == 0 )); then 1="aweber"; fi
    open http://github.colo.lair/$1/$(pwd | sed 's/.*\///')/pull/new/$(parse_git_branch)
}

testfile(){
    ulimit -n 1024
    project=$(pwd | sed -e 's/.*\///' -e 's/-/_/g')
    upper_project=$(echo $project | tr a-z A-Z)
    find $project tests -type f -name '*.py' | watchfiles "source bin/activate; eval ${upper_project}_CONF=configuration/development.conf bin/nosetests $@"
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
    curl -s 'reputation/v1/reputations'$1 |
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

convert(){
    curl -s 'http://puppet-bridge.colo.lair:11003/v1/reputations?filter='$1':'$3'&limit=1' |
    python -c "import json; print json.loads(raw_input())['content'][0][\"$2\"]"
}

get_one_most_recently_notified_list_id_for_account(){
    curl -s 'reputation/v1/notifications?sort=date:desc&limit=1&filter=notified:notified&filter=account_id:'`aid_from_login $1` |
    python -c 'import json; print json.loads(raw_input())["content"][0]["lists"][0]'
}


show(){
    # download and open image that matches args
    args=$*
    ((curl -q ${args// /%20}.jpg.to 2>/dev/null |
    sed -e 's/<img .*src="//' -e 's/" \/>//' |
    xargs wget -q -O $TMPDIR/${args// /_}.jpg &&
        open $TMPDIR/${args// /_}.jpg) &)
}

check_git_status() {
    local ST
    ST=$(git status 2> /dev/null)
    if [[ $? != 0 ]] then
        return
    fi
    echo $ST | grep '^nothing to commit' 1> /dev/null
    if [[ $? == 1 ]] then
        echo "%{$fg[red]%}+%{$reset_color%}"
    fi
}

parse_git_branch() {
    git branch --no-color 2> /dev/null |
    sed -e '/^  /d' -e 's/* \(.*\)/\1/'
}

get_exit_code_color() {
    if [[ $? != 0 ]] then
        COLOR=$PROMPT_ERROR
    else
        COLOR=$PROMPT_COLOR
    fi
    echo %{$COLOR%}
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
