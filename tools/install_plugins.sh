#!/bin/bash

cached_wget() {
    if [[ $# -ne 1 ]]; then
        echo -e "cached_wget expects 1 argument got $#"
        exit 1
    fi

    wget -qN $1
}

cached_wget_iter() {
    if [[ $# -lt 1 ]]; then
        echo -3 "cached_wget_iter expects at least 1 argument got $#"
        exit 1
    fi

    for url in $@
    do
        cached_wget $url
    done
}

server() {
    if [[ $# -ne 1 ]]; then
        echo -e "server [type]"
        echo -e "server command expects 1 arguments got $#"
        exit 1
    fi

    TARGET_DIR=paper-box-configs/$1
    if [[ ! -d $TARGET_DIR ]]; then
        echo -e "$TARGET_DIR is not a directory"
        exit 1
    fi
    [[ ! -d $TARGET_DIR/plugins ]] && mkdir $TARGET_DIR/plugins

    survival() {

        # BetterSleeping
        cached_wget_iter \
            https://github.com/Nuytemans-Dieter/BetterSleeping/releases/download/v4.0.2/BetterSleeping.jar \
            https://github.com/BlueMap-Minecraft/BlueMap/releases/download/v3.14/BlueMap-3.14-spigot.jar \
            https://github.com/MC-Linker/Discord-Linker/releases/download/Discord-Linker-3.1.3/Discord-Linker-3.1.3.jar \
            https://github.com/Gecolay/GSit/releases/download/1.4.5/GSit-1.4.5.jar \
            https://github.com/timbru31/SilkSpawners/releases/download/silkspawners-7.4.0/SilkSpawners.jar
    }

    pushd $TARGET_DIR/plugins
    $1
    popd
}

$@
