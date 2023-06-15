#!/bin/bash
# Series of snippets and shortcuts to make life
# easier.

userown() {
    # Sets recursively the ownership of the items
    # in a directory.
    if [[ $# -ne 2 ]]; then
        echo -e "userown expects 2 argument got $#"
        exit 1
    fi

    if [[ ! -d $2 ]]; then
        echo -e "argument 2 must be a directory"
        exit 2
    fi

    find $2 | xargs sudo chown $1:$1
}

build() {
    for tag in $@
    do
        docker build . --tag=wilkinsonk/paper-mc-proxy:$tag --target=proxy
        docker build . --tag=wilkinsonk/paper-mc-server:$tag --target=server
    done
}

init() {
    docker compose start
    update
}

update() {
    sync_config proxy
    sync_config survival
    docker compose restart
}

sync_config() {
    if [[ $# -ne 1 ]]; then
        echo -e "sync_config expects 1 argument got $#"
    fi

    find services/$1 -maxdepth 1 -mindepth 1 -type d | xargs -I {} sudo rsync -a config/$1 {}
}

$@
