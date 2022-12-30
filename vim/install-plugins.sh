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

# shellcheck disable=SC2164
cd "$plugins_folder"
for line in "${plugins_list[@]}"; do
    plugin_name=$(echo "$line" | cut -d/ -f2)
    # shellcheck disable=SC2059
    printf "Installing plugin $GREEN$plugin_name$NORMAL\n"

    # clone code
    if [[ ! -d $line ]]; then
      git clone https://github.com/"$line"
    fi
    echo
done

# install help tags
# shellcheck disable=SC2231
for name in $plugins_folder/*; do
    plugin_name=$(echo "$name" | rev | cut -d/ -f1 | rev)
    vim -c "help tags $plugin_name/doc" -c q
done

# shellcheck disable=SC2059
printf "${GREEN}SUCCESSFUL$NORMAL\n"
