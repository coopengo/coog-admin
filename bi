#!/bin/bash
# vim: set ft=sh:

get_dir() {
    local script_path; script_path=$(readlink -f "$0")
    local script_dir; script_dir=$(dirname "$script_path")
    echo "$script_dir"
}

_build(){
    (cd "$(get_dir)/images/bi" && ./build "$@")
}

set_args(){
    local args
    if [ ! -z "$BI_DB_HOST" ]
    then
        args="$args -e PGHOST=$BI_DB_HOST"
        if [ ! -z "$BI_DB_PORT" ]
        then
            args="$args -e PGPORT=$BI_DB_PORT"
        else
            args="$args -e PGPORT=5432"
        fi
    else
        args="$args -e PGHOST=$NETWORK_NAME-dwh -e PGPORT=5432"
    fi
    args="$args -e PGUSER=$BI_DB_USER"
    args="$args -e PGPASSWORD=$BI_DB_PASSWORD"
    args="$args -e PGDATABASE=$BI_DB_NAME"
    echo "$args"
}

_run(){
    docker run \
        $DOCKER_DAEMON_OPTS \
        --network "$NETWORK_NAME" \
        --name "$NETWORK_NAME-bi" \
        -p "$BI_PORT:8080" \
        $(set_args) \
        "$BI_IMAGE"
}

usage() {
    echo
    echo "  Available commands "
    echo
    echo "  build               -> Build bi image"
    echo "  run                 -> Run bi image"
    echo "  <action>            -> Call docker action on bi container"
    echo
}

main(){
    source "$(get_dir)/config"
    #
    [ -z "$1" ] && usage && return 0

    local cmd; cmd="$1"; shift
    #
    [ "$cmd" = "run" ] && { _run "$@"; return $?; }
    [ "$cmd" = "build" ] && { _build "$@"; return $?; }
    docker "$@" "$NETWORK_NAME-bi"
}

main "$@"
