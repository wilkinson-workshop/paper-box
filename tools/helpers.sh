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
    update_all
}

start() {
    docker compose start
}

update_all() {
    update proxy 0x00
    update nginx 0x00
    update survival 0x00
}

update() {
    if [[ $# -lt 2 ]]; then
        echo -e "sync_config expects 2 argument got $#"
        exit 1
    fi

    sync_config $@

    ARGS=($@)
    for name in "${ARGS[@]:1}"
    do
        if [[ $1 -eq "nginx" ]]; then
            docker compose restart "web-proxy${name}"
        else
            docker compose restart "${1}${name}"
        fi
    done
}

sync_config() {
    if [[ $# -lt 2 ]]; then
        echo -e "sync_config expects 2 argument got $#"
        exit 1
    fi

    # If dir doesn't exist, make it.
    [[ ! -d services/$1 ]] && mkdir -p services/$1

    ARGS=($@)
    for name in "${ARGS[@]:1}"
    do
        sudo rsync -a paper-box-configs/$1/* services/$1/$name/
    done
}

$@
