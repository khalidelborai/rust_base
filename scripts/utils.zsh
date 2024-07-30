#!/bin/zsh

# Import colors
# shellcheck source=colors.zsh
PATH_TO_COLORS=$(dirname "$0")/colors.zsh
source "$PATH_TO_COLORS"

column_width() {
    columns=$(tput cols)
    width=$((columns / $1))
    echo $width
}

print_line() {
    # if arg 0 is passed, print bold using $BOLD
    bold=$1
    columns=$(tput cols)
    if [ "$bold" = "0" ]; then
        printf "%${columns}s\n" | tr ' ' '-'
    else
        printf "${BOLD}%${columns}s${RESET}\n" | tr ' ' '-'
    fi
}

print_header() {
    names=($@)
    print_line 1
    col_width=$(column_width ${#names[@]})

    for name in "${names[@]}"; do
        printf "%-*s" $col_width " $(printf "%*s" $(((${#name} + col_width) / 2)) "$name")"
    done
    printf "\n"
    print_line 1
}

print_row() {
    values=($@)
    col_width=$(column_width ${#values[@]})
    for value in "${values[@]}"; do
        printf "%-*s" $col_width " $(printf "%*s" $(((${#value} + col_width) / 2)) "$value")"
    done
    print_line 0
}

export column_width
export print_line
export print_header
export print_row
