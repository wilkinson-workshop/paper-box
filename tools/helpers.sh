#!/bin/bash
# Series of snippets and shortcuts to make life
# easier.

build() {
    for tag in $@
    do
        sudo docker build . --tag=wilkinsonk/paper-mc-proxy:$tag --target=proxy
        sudo docker build . --tag=wilkinsonk/paper-mc-server:$tag --target=server
    done
}

clean() {
    sudo docker compose rm
    sudo rm -rf services/
    find paper-box-configs -type f -iname "*.jar" | grep "plugins/" | xargs rm
}

init() {
    sudo docker compose create
    start

    sleep 10 # Wait for containers to fully start.
    tools/install_plugins.sh server survival
    update_all
}

start() {
    sudo docker compose start
}

stop() {
    sudo docker compose stop
}

update_all() {
    sync_config proxy 0x00
    sync_config nginx 0x00
    sync_config survival 0x00

    # Force restart of all services to lock in
    # config updates.
    sudo docker compose restart
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
            sudo docker compose restart "web-proxy${name}"
        else
            sudo docker compose restart "${1}${name}"
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
