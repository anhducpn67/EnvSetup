#!/bin/bash

set -e

# usage
usage(){
    cat <<- _EOF_
Download and install git from source.

OPTION:
    -d, --dest      Path to folder to download git source code 
                    (default: current directory)
    -j, --jobs      Number of jobs to run parallel
                    (default: 1)
    -p, --prefix    Path to folder to install git
                    (default: /usr/local)
    --zlib          Path to zlib
                    (default: /usr/)
    --curl          Path to curl directory
                    (default: /usr/)
    -v, --version   Git version to install
                    (default: latest)
    -h, --help      Print usage message and exit
_EOF_
}

# default options
PREFIX="/usr/local"
DEST="$(pwd)"
ZLIB="/usr/"
CURLDIR="/usr/"
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
            "--zlib")
                shift
                ZLIB="$1"
                ;;
            "--curl")
                shift
                CURLDIR="$1"
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
                printf "$0 option $1 not found\n"
                exit 1
                ;;
        esac
        shift
    done
}
parse_args "$@"

# check if download folder is exist
if [[ ! -d $DEST ]]; then
    mkdir -p "$DEST"
fi

# check if installation folder is exist
if [[ ! -d $PREFIX ]]; then
    mkdir -p "$PREFIX"
fi

# check if git source code is already download
URL="https://github.com/git/git.git"
if [[ ! -d $DEST/git ]]; then
    git clone $URL "$DEST/git"
else
    cd "$DEST/git"
    # uninstall old version
    make clean && make distclean
    git checkout master
    git pull origin master
fi

# config git
cd "$DEST/git"

if [[ -n $VERSION ]]; then
    git checkout "$VERSION"
fi

# create configure file
if [[ ! -x configure ]]; then
    make configure
fi

./configure --prefix="$PREFIX" \
            --with-zlib="$ZLIB" \
	    --with-curl	\
	    CURLDIR="$CURLDIR"

# make and install
cd "$DEST/git"
make -j "$NJOBS" && make install
