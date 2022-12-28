# Install Zsh and some useful plugins
1. With sudo (eg. In local machine) \
`sudo ./install-ncurses.sh` \
`sudo ./install-zsh.sh` \
`sudo ./install-oh-my-zsh.sh`
2. Without sudo (eg. In server) \
`./install-ncurses.sh -p $HOME/.local` \
`./install-zsh.sh -p $HOME/.local --ncursesw $HOME/.local` \
`./install-oh-my-zsh.sh`