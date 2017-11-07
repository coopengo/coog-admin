#!/bin/bash

if [ -z "$COOG_CODE_DIR" ] || [ -z "$COOG_DATA_DIR" ]
then
    echo "COOG_CODE_DIR or COOG_DATA_DIR not set" >&2 && exit 1
fi

_build() {
    (cd "$COOG_CODE_DIR/images/bi" && ./build "$@")
}

_import() {
    docker run \
        $DOCKER_INTERACTIVE_OPTS \
        --network "$NETWORK_NAME" \
        -e BI_SERVER="$NETWORK_NAME-bi" \
        --entrypoint "/opt/pentaho/scripts/import_file.sh" \
        "$BI_IMAGE"
}

set_args() {
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

_run() {
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
    echo "  import              -> Import default Coog reports"
    echo "  <action>            -> Call docker action on bi container"
    echo
}

main() {
    source "$COOG_CODE_DIR/config"
    [ -z "$1" ] && usage && return 0
    local cmd; cmd="$1"; shift
    [ "$cmd" = "run" ] && { _run "$@"; return $?; }
    [ "$cmd" = "build" ] && { _build "$@"; return $?; }
    [ "$cmd" = "import" ] && { _import; return $?; }
    docker "$cmd" "$@" "$NETWORK_NAME-bi"
}

main "$@"
