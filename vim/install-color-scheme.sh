#!/bin/bash

set -e

# add color scheme
mkdir -p "$VIM/colors"

# symbol link
for file in colors/*.vim; do
    color=$(echo "$file" | cut -d/ -f2)
    # shellcheck disable=SC2059
    printf "Install color $GREEN$color$NORMAL...\n"
    ln -s "$(pwd)/colors/$color" "$VIM/colors/$color"
    echo
done

# shellcheck disable=SC2059
printf "${GREEN}SUCCESSFUL$NORMAL\n"
