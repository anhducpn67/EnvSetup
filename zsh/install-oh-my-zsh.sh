#!/bin/bash

set -e

# usage
usage() {
    cat <<- _EOF_
Install oh-my-zsh and some useful plugins.

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

parse_args "$@"

# download oh-my-zsh installation script
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh\
    -qO install.sh

# install oh-my-zsh and some useful plugins
if [[ -z $INSTALL ]]; then
    chmod u+x install.sh
    ./install.sh --unattended
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
    rm install.sh
fi

# turn-on plugins
cp "$(pwd)/.zshrc" "$HOME/.zshrc"
