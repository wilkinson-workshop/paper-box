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

clean() {
    docker compose rm
    sudo rm -rf services/
}

init() {
    docker compose create
    start

    sleep 5 # Wait for containers to start.
    update
}

start() {
    docker compose start
}

update() {
    sync_config proxy '0x00'
    sync_config survival '0x00'
    docker compose restart
}

sync_config() {
    if [[ $# -ne 2 ]]; then
        echo -e "sync_config expects 2 argument got $#"
    fi

    ARGS=($@)
    for name in "${ARGS[@]:1}"
    do
        sudo rsync -a paper-box-configs/$1/* services/$1/$name/
    done
}

$@
