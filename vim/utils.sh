#!/bin/bash

set -e

# colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;36m"
NORMAL="\033[0m"

# function to create backup file
create_backup(){
    while true; do
        read -p "Do you want to create a backup [y/yes/Y/n/no/N]: " answer
        case $answer in
            "y" | "Y" | "yes")
                printf "Backup ${GREEN}%s${NORMAL}\n" "$1"
                # remove old backup file/folder and create a new one
                if [[ -e $1.bak ]]; then
                    rm -rf "$1.bak"
                fi
                mv "$1" "$1.bak"
                break
                ;;
            "n" | "N" | "no")
                printf "Do not backup ${GREEN}%s${NORMAL}\n" "$1"
                rm -rf "$1"
                break
                ;;
            *)
                ;;
        esac
    done
}
