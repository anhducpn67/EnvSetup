# Install git from source
Git using two lib: libcurl && zlib. So, to install git, we also have to install libcurl && zlib
1. With sudo (eg. In local machine) \
`./install-zlib-source.sh` \
`./install-curl-source.sh` \
`./install-git-source.sh`
2. Without sudo (eg. In server) \
`./install-zlib-source.sh -p $HOME/.local` \
`./install-curl-source.sh -p $HOME/.local` \
`./install-git-source.sh -p $HOME/local --zlib $HOME/local --curl $HOME/.local`