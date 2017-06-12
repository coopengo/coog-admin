#!/bin/bash
# vim: set ft=sh:
# This script helps doing with coog app image

get_dir() {
        local script_path; script_path=$(readlink -f "$0")
        local script_dir; script_dir=$(dirname "$script_path")
        echo "$script_dir"
}

_args() {
        local args
        args="$args --link $API_CONTAINER:coog-api"
        args="$args -p 80$NGINX_PUB_PORT:80"
        echo "$args"

}

_run() {
        docker run \
                $DOCKER_DAEMON_OPTS \
                --name "$APP_CONTAINER" \
                $(_args) "$APP_IMAGE" "$@"
}

_docker() {
        docker "$@" "$APP_CONTAINER"
}

usage() {
        echo
        echo Available commands
        echo
        echo "  run       -> runs an app docker image"
        echo "  <action>  -> calls docker action on app container"
        echo
}

main() {
        source "$(get_dir)/config"
        #
        [ -z "$1" ] && usage && return 0
        local cmd; cmd="$1"; shift
        #
        [ "$cmd" = "run" ] && { _run "$@"; return $?; }
        _docker "$cmd" "$@"
}

main "$@"
