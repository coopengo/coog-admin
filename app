#!/bin/bash
# vim: set ft=sh:
# This script helps doing with coog app image

get_dir() {
        local script_path; script_path=$(readlink -f "$0")
        local script_dir; script_dir=$(dirname "$script_path")
        echo "$script_dir"
}

_run() {
        docker run \
                $DOCKER_DAEMON_OPTS \
                --network "$NETWORK_NAME" \
                --name "$NETWORK_NAME-app" \
                -p "80$NGINX_PUB_PORT:80" \
                "$APP_IMAGE" \
                sh -c "sed -i s/NETWORK_NAME/$NETWORK_NAME/g /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
}

_docker() {
        docker "$@" "$NETWORK_NAME-app"
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
        [ "$cmd" = "run" ] && { _run; return $?; }
        _docker "$cmd" "$@"
}

main "$@"
