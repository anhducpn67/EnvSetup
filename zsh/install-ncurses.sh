#!/bin/bash

set -e

# usage
usage() {
    cat <<- _EOF_
Install ncurses library from source.

OPTION:
    -p, --prefix    Folder to install ncurses to (default: /usr/local)
    -j, --jobs      Number of jobs (default: 1)
    -v, --version   ncurses version to download and install (default: 6.3)
    -h, --help      Print this message and exit
_EOF_
}

# default options
VERSION=6.3
PREFIX="/usr/local"
JOBS=1

# parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            "-p" | "--prefix")
                shift
                PREFIX="$1"
                ;;
            "-j" | "--jobs")
                shift
                JOBS="$1"
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

parse_args $@

# download ncurses and create install directory
if [[ ! -d ncurses-$VERSION ]]; then
    if [[ ! -f ncurses-$VERSION.tar.gz ]]; then
        wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-$VERSION.tar.gz
        tar -xzvf ncurses-$VERSION.tar.gz
        rm ncurses-$VERSION.tar.gz
    fi
fi

if [[ ! -d $PREFIX ]]; then
    mkdir -p "$PREFIX"
fi

# config
cd ncurses-$VERSION

# uninstall old version
make uninstall && make clean && make distclean

if [[ -z $NCURSES ]]; then
    NCURSES="$(pwd)"
fi

# configure
./configure --prefix "$PREFIX" \
    --with-shared \
    --without-debug \
    --enable-widec \
    CXXFLAGS="-fPIC" CFLAGS="-fPIC" \
    CPPFLAGS="-I$NCURSES/include" LDFLAGS="-L$NCURSES/lib"

# install
make -j$JOBS && make install
