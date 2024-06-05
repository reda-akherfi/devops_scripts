#!/use/bin/env bash


# COLORS
ncolors=$(command -v tput > /dev/null && tput colors) # supports color
if [[ -n $ncolors && -z $NO_COLOR ]]; then
    TERMCOLS=$(tput cols)
    CLEAR="$(tput sgr0)"
    
    # 4 bit colors 
    if test $ncolors -ge 8; then 
        # Normal 
        BLACK="$(tput setaf 0)"
        RED="$(tput setaf 1)"
        GREEN="$(tput setaf 2)"
        YELLOW="$(tput setaf 3)"
        BLUE="$(tput setaf 4)"
        MAGENTA="$(tput setaf 5)"
        CYAN="$(tput setaf 6)"
        GREY="$(tput setaf 7)"
    fi

    # >4 bit colors 
    if test $ncolors -gt 8; then 
        # High intensity 
        BLACK_I="$(tput setaf 8)"
        RED_I="$(tput setaf 9)"
        GREEN_I="$(tput setaf 10)"
        YELLOW_I="$(tput setaf 11)"
        BLUE_I="$(tput setaf 12)"
        MAGENTA_I="$(tput setaf 13)"
        CYAN_I="$(tput setaf 14)"
        WHITE="$(tput setaf 15)"
    else
        BLACK_I=$BLACK
        RED_I=$RED
        GREEN_I=$GREEN
        YELLOW_I=$YELLOW
        BLUE_I=$BLUE
        MAGENTA_I=$MAGENTA
        CYAN_I=$CYAN
        WHITE=$GREY
    fi

    # Styles
    UNDERLINE="$(tput smul)"
    STANDOUT="$(tput smso)"
    BOLD="$(tput bold)"
fi

