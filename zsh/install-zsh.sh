#!/bin/bash

set -e

# usage
usage() {
    cat <<- _EOF_
Install zsh from source

OPTION:
    -p, --prefix    Path to folder to install zsh (default: /usr/local)
    -d, --dest      Path to folder to clone zsh source code
                    zsh source code will be in \$DEST/zsh folder
    -j, --jobs      Number of jobs (default: 1)
        --ncursesw  Path to ncursesw installed folder (default: /usr/local)
    -h, --help      Print this message and exit
_EOF_
}

# default options
PREFIX="/usr/local"
NCURSESW="/usr/local"
DEST="$(pwd)"
JOBS=1

# parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            "-p" | "--prefix")
                shift
                PREFIX="$1"
                ;;
            "-d" | "--dest")
                shift
                DEST="$1"
                ;;
            "-j" | "--jobs")
                shift
                JOBS="$1"
                ;;
            "--ncursesw")
                shift
                NCURSESW="$1"
                ;;
            "-h" | "--help")
                usage
                exit 0
                ;;
            *)
                echo "$0 option $1 not found"
                exit 1
                ;;
        esac
        shift
    done
}

parse_args $@

# zsh require ncurses, default searching for ncurses library in
# $HOME/.local folder. If you have different ncurses library folder, export
# its path to $NCURSES_LIB environment variable. If ncurses is not installed,
# install it using distro package manager or install it from source by running
# 'install-ncurses.sh' file

if [[ ! -d $PREFIX ]]; then
    mkdir -p "$PREFIX"
fi

if [[ ! -d $DEST ]]; then
    mkdir -p "$DEST"
fi

# download zsh source code
URL="git://git.code.sf.net/p/zsh/code"

if [[ ! -d $DEST/zsh-source ]]; then
    git clone $URL "$DEST/zsh-source"
else
    cd "$DEST/zsh-source"
    git checkout master
    git pull
fi

# config
cd "$DEST/zsh-source"

# uninstall old version
make uninstall && make clean && make distclean

if [[ ! -x "configure" ]]; then
    ./Util/preconfig
fi

# configure
./configure --prefix="$PREFIX" \
    --with-term-lib=ncursesw \
    CXXFLAGS="-fPIC" CFLAGS="-fPIC" \
    LDFLAGS="-L$NCURSESW/lib" CPPFLAGS="-I$NCURSESW/include" \
    LD_LIBRARY_PATH="$NCURSESW/lib:$LD_LIBRARY_PATH"

# install
make -j$JOBS && make install

# change zsh to default shell
# if [[ -e $HOME/.bash_profile ]]; then
#     echo "export SHELL=\$(which zsh)" >> "$HOME/.bash_profile"
#     echo 'exec "$SHELL" -l' >> "$HOME/.bash_profile"
# elif [[ -e $HOME/.profile ]]; then
#     echo "export SHELL=\$(which zsh)" >> "$HOME/.profile"
#     echo 'exec "$SHELL" -l' >> "$HOME/.profile"
# fi
