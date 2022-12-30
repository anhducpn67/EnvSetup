#!/bin/bash

set -e

usage() {
    cat <<- _EOF_
Install vim from source.

OPTIONS:
    -p, --prefix                Path to install VIM to (default: /usr/local)
    -d, --dest                  Path to folder to clone VIM source code. VIM
                                    source code will be stored in \$DEST/vim
                                    folder
        --python3-command       Python 3 command in system, normally it's
                                    'python3' or 'python'
    -j, --jobs                  Number of jobs (default: 1)
        --ncursesw              Path to ncursesw installed folder
                                    (default: /usr/local)
    -v, --version               Specific VIM version to install
                                    (default use latest version)
    -h, --help                  Print this message and exit
_EOF_
}

# default options
PREFIX="/usr/local"
DEST="$(pwd)"
PYTHON3_COMMAND="python3"
NCURSESW="/usr/local"
JOBS=1

# parse command line arguments
parse_args() {
    while (( $# > 0 )); do
        case $1 in
            "-p" | "--prefix")
                shift
                PREFIX="$1"
                ;;
            "-d" | "--dest")
                shift
                DEST="$1"
                ;;
            "--python3-command")
                shift
                PYTHON3_COMMAND=$1
                ;;
            "-j" | "--jobs")
                shift
                JOBS="$1"
                ;;
            "--ncursesw")
                shift
                NCURSESW="$1"
                ;;
            "-v" | "--version")
                shift
                VERSION=$1
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

parse_args "$@"

if [[ ! -d $DEST ]]; then
    mkdir -p "$DEST"
fi

if [[ ! -d $DEST/vim ]]; then
    cd "$DEST"
    git clone https://github.com/vim/vim.git
else
    cd "$DEST/vim"
    git checkout master
    git pull origin master
fi

# uninstall old version
cd "$DEST/vim"
make uninstall && make clean && make distclean

# install vim
cd "$DEST/vim"
./configure --prefix="$PREFIX" \
    --with-features=huge --enable-multibyte \
    --enable-python3interp=yes \
    --with-python3-command="$PYTHON3_COMMAND" \
    --with-tlib=ncursesw \
    CFLAGS="-fPIC" \
    LDFLAGS="-L$NCURSESW/lib" \
    LD_LIBRARY_PATH="$NCURSESW/lib:$LD_LIBRARY_PATH"
make -j"$JOBS"
make install

# symbolic link
cd "$PREFIX/bin"
rm -rf vi
ln -s vim vi
