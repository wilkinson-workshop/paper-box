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

$@
