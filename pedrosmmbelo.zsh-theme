host_machine () {
    if [ -n "$SSH_CLIENT" ]; then
        host_color="yellow"
    else
        host_color="green"
    fi
    echo "%B%F{$host_color}%n@%m ";
}

path () {
    echo "%B%F{blue}%10c ";
}

git_branch () {
    echo "%B%F{red}$(git_prompt_info)$(git_remote_status)";
}

arrow () {
    echo "%B%F{cyan}❯"
}

PROMPT='
$(host_machine) $(path) $(git_branch)
$(arrow) '

RPROMPT='${return_status}%{$reset_color%}'
