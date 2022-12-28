#!/bin/bash

set -e

# usage
usage() {
    cat <<- _EOF_
Download oh-my-zsh installtion script and install.

OPTION:
        --download-only     Only download script
    -h, --help              Print this message and exit
_EOF_
}

# parsing commandline arguments
parse_args() {
    while (( $# > 0 )); do
        case $1 in
            "--download-only")
                INSTALL=false
                ;;
            "-h" | "--help")
                usage
                exit 0
                ;;
        esac
        shift
    done
}

parse_args $@

# download oh-my-zsh installation script
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh\
    -qO install.sh

# install oh-my-zsh and zsh syntax highlighting plugin
if [[ -z $INSTALL ]]; then
    chmod u+x install.sh
    ./install.sh --unattended
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    rm install.sh
fi

# turn-on plugins
cp $(pwd)/.zshrc $HOME/.zshrc