#!/bin/bash

CONFIG=$1
CONFIG_PLACEHOLDER=">>config<<"

function alter_target_file() {
    for FILE in "web/app/web/index.html" "web/index.html"
    do
        sed -i "s/$1/$2/" $FILE
    done
}

if [ $CONFIG == "restore" ]; then
    alter_target_file "'config', '.*'" "'config', '$CONFIG_PLACEHOLDER'"
else
    alter_target_file $CONFIG_PLACEHOLDER $CONFIG
fi
