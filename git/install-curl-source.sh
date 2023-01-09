#!/bin/bash

set -e

# usage
usage(){
    cat <<- _EOF_
Download and install libcurl from source.
We must install libcurl because git using this lib.

OPTION:
    -d, --dest      Path to folder to download libcurl source code
                    (default: current directory)
    -j, --jobs      Number of jobs to run parallel
                    (default: 1)
    -p, --prefix    Path to folder to install libcurl
                    (default: /usr/local)
    -v, --version   Version of libcurl
                    (default: 7.87.0)
    -h, --help      Print usage message and exit
_EOF_
}

# default options
PREFIX="/usr/local"
DEST="$(pwd)"
VERSION="7.87.0"
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
            "-v" | "--version")
                shift
                VERSION="$1"
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

# download source code of libcurl
wget --no-check-certificate https://curl.se/download/curl-"$VERSION".tar.gz
tar -xzvf curl-"$VERSION".tar.gz
rm -rf curl-"$VERSION".tar.gz

# configure
cd "$DEST/curl-$VERSION"
./configure --with-openssl --prefix="$PREFIX"

# make and install
cd "$DEST/curl-$VERSION"
make -j "$NJOBS" && make install
