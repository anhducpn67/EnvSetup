#!/bin/bash

# create built-in plugin manager folder structure
plugins_folder="$VIM/pack/plugins/start"
mkdir -p "$plugins_folder"

# read plugins list file
declare -a plugins_list=()
while IFS= read -r line
do
    # remove comment/empty line
    if [[ $line == \#* || -z $line ]]; then
        continue
    fi
    plugins_list+=("$line")
done < "$DIR/plugins.plg"

cd "$plugins_folder"
for line in "${plugins_list[@]}"; do
    plugin_name=$(echo $line | cut -d/ -f2)
    printf "Installing plugin $GREEN$plugin_name$NORMAL\n"

    # clone code
    git clone https://github.com/$line
    echo
done

# install helptags
for name in $plugins_folder/*; do
    plugin_name=$(echo $name | rev | cut -d/ -f1 | rev)
    vim -c "helptags $plugin_name/doc" -c q
done

printf "${GREEN}SUCCESSFUL$NORMAL\n"
