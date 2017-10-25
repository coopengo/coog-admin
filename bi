#!/bin/bash
# vim: set ft=sh:

get_dir() {
    local script_path; script_path=$(readlink -f "$0")
    local script_dir; script_dir=$(dirname "$script_path")
    echo "$script_dir"
}

_build(){
    (cd "$(get_dir)/images/bi_server" && ./build bi_server "$@")
}

_run(){
    docker run \
        --name biserver \
        -d --net ${NETWORK_NAME} \
        -e PGHOST=${NETWORK_NAME}-postgres-dw \
        -e PGUSER=$DW_TARGET_DB_USER \
        -e PGPASSWORD=$DW_TARGET_DB_PASSWORD \
        --privileged=true \
        -p ${BI_SERVER_PORT}:8080 bi_server
}

usage() {
    echo
    echo "  Available commands "
    echo
    echo "  build               -> Build bi server image"
    echo "  run                 -> Run bi server container"
    echo "  <action>            -> Call docker action on bi server container"
    echo
}

main(){
    source "$(get_dir)/config"
    #
    [ -z "$1" ] && usage && return 0

    local cmd; cmd="$1"; shift
    #
    [ "$cmd" = "run" ] && { _run $@; return $?; }
    [ "$cmd" = "build" ] && { _build $@; return $?; }
    [ "$cmd" = "import" ] && { _import; return $?; }

    docker $cmd biserver $@

}

main "$@"
