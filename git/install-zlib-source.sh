#!/bin/bash

set -e

# usage
usage(){
    cat <<- _EOF_
Download and install zlib from source.
We must install zlib because git using this lib.

OPTION:
    -d, --dest      Path to folder to download zlib source code
                    (default: current directory)
    -j, --jobs      Number of jobs to run parallel
                    (default: 1)
    -p, --prefix    Path to folder to install zlib
                    (default: /usr/local)
    -h, --help      Print usage message and exit
_EOF_
}

# default options
PREFIX="/usr/local"
DEST="$(pwd)"
NJOBS=1

# parse command line arguments
parse_args(){
    while (( $# > 0 )); do
        case $1 in
            "-d" | "--dest")
                shift
                DEST="$1"
                ;;
            "-j" | "--jobs")
                shift
                NJOBS=$1
                ;;
            "-p" | "--prefix")
                shift
                PREFIX="$1"
                ;;
            "-h" | "--help")
                usage
                exit 0
                ;;
            *)
                printf "$0 option $1 not found\n"
                exit 1
                ;;
        esac
        shift
    done
}
parse_args "$@"

# check if $DEST folder is exist
if [[ ! -d $DEST ]]; then
    mkdir -p "$DEST"
fi

# check if $PREFIX folder is exist
if [[ ! -d $PREFIX ]]; then
    mkdir -p "$PREFIX"
fi

# check if git source code is already download
URL="https://github.com/madler/zlib.git"
if [[ ! -d $DEST/zlib ]]; then
    git clone $URL "$DEST/zlib"
else
    cd "$DEST/zlib"
    # uninstall old version
    make clean && make distclean
    git checkout master
    git pull origin master
fi

cd "$DEST/zlib"
./configure --prefix="$PREFIX"

# make and install
cd "$DEST/zlib"
make -j $NJOBS && make install
