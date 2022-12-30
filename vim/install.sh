#!/bin/bash

VIM="$HOME/.vim"
DIR=$(pwd)

cd "$DIR" && . utils.sh
cd "$DIR" && . install-plugins.sh
cd "$DIR" && . install-color-scheme.sh

cp "$DIR"/.vimrc "$HOME"/.vimrc
