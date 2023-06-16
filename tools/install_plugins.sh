server() {
    if [[ $# -ne 1 ]]; then
        echo -e "server [type]"
        echo -e "server command expects 1 arguments got $#"
        exit 1
    fi

    TARGET_DIR=paper-box-configs/$1/plugins
    if [[ ! -d $TARGET_DIR ]]; then
        echo -e "$TARGET_DIR is not a directory"
        exit 1
    fi

    survival() {
        # BetterSleeping
        wget -q https://github.com/Nuytemans-Dieter/BetterSleeping/releases/download/v4.0.2/BetterSleeping.jar
        # BlueMap
        wget -q https://github.com/BlueMap-Minecraft/BlueMap/releases/download/v3.14/BlueMap-3.14-spigot.jar
        # Discord Linker
        wget -q https://github.com/MC-Linker/Discord-Linker/releases/download/Discord-Linker-3.1.3/Discord-Linker-3.1.3.jar
        # GSit
        wget -q https://github.com/Gecolay/GSit/releases/download/1.4.5/GSit-1.4.5.jar
        # SilkSpawners
        wget -q https://github.com/timbru31/SilkSpawners/releases/download/silkspawners-7.4.0/SilkSpawners.jar
    }

    pushd $TARGET_DIR
    $1
    popd
}

$@
