function theme_precmd {
    local TERMWIDTH
    TERMWIDTH=${COLUMNS}-1

    # Truncate the path if it's too long.

    PR_FILLBAR=""
    PR_PWDLEN=""

    local promptsize=${#${(%):---(%n@%m-%~)---()---}}
    local datesize=${#${(%):-%D}}

    if [[ "$promptsize + $datesize" -gt $TERMWIDTH ]]; then
        PR_PWDLEN=$TERMWIDTH - $promptsize
    else
        PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $datesize)))..${PR_HBAR}.)}"
    fi

}

setprompt () {
    ###
    # Need this so the prompt will work.

    setopt prompt_subst

    ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[red]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX=" "

    ###
    # See if we can use colors.

    autoload zsh/terminfo
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE GREY; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	(( count = $count + 1 ))
    done
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"

	PR_SET_CHARSET=""
	PR_SHIFT_IN=""
	PR_SHIFT_OUT=""
	PR_HBAR="─"
    PR_ULCORNER="┌"
    PR_LLCORNER="└"
    PR_LRCORNER="┘"
    PR_URCORNER="┐"

    if [ -n "$SSH_CLIENT" ]; then
        PR_HOST_COLOR=$PR_YELLOW
    else
        PR_HOST_COLOR=$PR_GREEN
    fi

    ###
    # Finally, the prompt.

    PROMPT='
$PR_CYAN$PR_ULCORNER$PR_HBAR\
 $PR_HOST_COLOR%n@%m$PR_WHITE:\
$PR_BLUE%$PR_PWDLEN<...<%~%<<\
 $PR_CYAN$PR_HBAR$PR_HBAR${(e)PR_FILLBAR}$PR_HBAR\
 $PR_YELLOW%D{%a,%b%d} \
$PR_CYAN$PR_HBAR$PR_URCORNER\

$PR_CYAN$PR_LLCORNER$PR_HBAR\
$PR_RED%{$reset_color%}`git_prompt_info``git_prompt_status`$PR_CYAN$PR_HBAR$PR_HBAR\
❯$PR_NO_COLOUR '

    RPROMPT=' $return_code$PR_CYAN$PR_HBAR$PR_HBAR\
 $PR_YELLOW%* $PR_CYAN$PR_HBAR$PR_LRCORNER$PR_NO_COLOUR'
}

setprompt

autoload -U add-zsh-hook
add-zsh-hook preexec theme_preexec
