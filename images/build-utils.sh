repo_remote() { # <wd> <repo>
    cat "$1/repos.vendor" "$1/repos.custom" | grep -P "^$2;" | tail -1 | cut -d ";" -f 2
}

repo_fetch() { # <clones> <repo> <remote>
    if [ -d "$1/$2" ]
    then
        echo "  fetch"
        (cd "$1/$2" \
            && git remote set-url origin "$3" \
            && git fetch -p -q --recurse-submodules) || return 1
    else
        echo "  clone"
        git clone -q --config core.autocrlf=input --recurse-submodules "$3" "$1/$2" || return 1
    fi
}

guess_rev() {
    git rev-parse --verify "origin/$1" > /dev/null 2>&1
    if [ $? -eq 0 ]
    then
        echo "origin/$1"
    else
        echo "$1"
    fi
}

repo_checkout() { # <dd> <repo> <branch>
    local rev; rev=$(guess_rev "$3")
    echo "  checkout $rev"
    git checkout -q "$rev" \
        && git submodule update -q --init \
        && echo "$2:$3:$(git rev-parse HEAD)" >> "$1/.version" \
        || return 1
}

pre_repo_cp() {
    local d; d=$(git diff --stat HEAD | wc -l)
    [ "$d" -ne 0 ] && echo "repo $2 not clean" >&2 && return 1
    local rev; rev=$(guess_rev "$3")

    mkdir "$1/$2" || return 1

    echo "$rev"
}

post_repo_cp() {
    if [ -d doc ]
    then
        if [ -f doc/docker-compose.yml ]
        then
            echo "Dockerize doc generation and copy doc"
            docker-compose -f doc/docker-compose.yml up
            docker-compose -f doc/docker-compose.yml down -v --rmi all
            chown -R ${USER}:${USER} doc/dist/
            echo "Down ok"
        elif [ -f doc/build ]
        then
            echo "build and copy doc"
            ./doc/build
        fi
        cp -R "doc/dist/html" "$1/$2-doc"
    fi
    echo "Git clean"
    git clean -d -f -X
}

repo_cp_archive() {
    echo "  copy"
    git archive HEAD | tar x -C "$1/$2" || return $?
    git submodule foreach "git archive HEAD | tar x -C $1/$2/\$path" || return $?
}

repo_cp_build() {
    echo "  build and copy"
    ./build/build "$rev" \
        && cp -R ./dist/* "$1/$2/" \
        || return 1
}

repo_cp_customer() {
    local rev; rev=$(pre_repo_cp "$@");
    if [ -z "$BUILD_STEP" ]
    then
        repo_cp_archive "$@";
    else
        repo_cp_build "$@";
    fi
    post_repo_cp "$@";
}

repo_cp() { # <dd> <repo> <branch>
    local rev; rev=$(pre_repo_cp "$@");
    if [ -d build ]
    then
        repo_cp_build "$@";
    else
        repo_cp_archive "$@";
    fi
    post_repo_cp "$@";
}

_docker_build() {
    cd "$wd"
    if [ -f 'docker-compose.yml' ]
    then
        docker-compose build --no-cache --force-rm --parallel
    else
        docker build -t "$image" "$@" "."
    fi
    if [ -n "$CUSTOMER" ]
    then
        if [ -e "docker-compose-customer.yml" ]
        then
            docker-compose -f docker-compose-customer.yml build  --no-cache --force-rm --parallel
        fi
    fi
    cd -
}

build_loop() {
    while [ ! -z "$1" ]
    do
        [ "$1" = "--" ] && shift && break
        local repo; repo=$(echo "$1" | cut -d ":" -f 1)
        local branch; branch=$(echo "$1" | cut -d ":" -f 2)
        local remote; remote=$(repo_remote "$wd" "$repo")
        echo "workon $repo:$branch from $remote"
        [ -z "$remote" ] \
            && echo "repo $repo unknown" >&2 \
            && return 1
        repo_fetch "$clones" "$repo" "$remote" || return 1
        (cd "$clones/$repo" && repo_checkout "$dd" "$repo" "$branch") || return 1
        if [ "$repo" = "customers" ]
        then
            (cd "$clones/$repo" && repo_cp_customer "$dd" "$repo" "$branch") || return 1
        else
            (cd "$clones/$repo" && repo_cp "$dd" "$repo" "$branch") || return 1
        fi
        shift
    done
}

build_static_finalize() {
    cd "$clones/$MAIN_DIRECTORY" && repo_cp_build "$dd" "$repo"
}

post_build() {
    find "$dd" -name ".git" | xargs rm -rf
    _docker_build
    rm -rf "$dd"
}

build() { # <image-tag> <repositories> -- [docker-build-arg*]
    local script_path; script_path=$(readlink -f "$0")
    local wd; wd=$(dirname "$script_path")
    local dd; dd="$wd/dist"
    local clones; clones="$wd/clones"

    touch "$wd/repos.custom"
    mkdir -p "$clones" || return 1
    rm -rf "$dd"
    mkdir "$dd" || return 1

    local image; image="$1"
    shift
    if [ -n "$MAIN_DIRECTORY" ]
    then
        (export BUILD_STEP=1 && build_loop "$@";) || return 1;
        (export BUILD_STEP=2 && build_static_finalize;) || return 1;
    else
        build_loop "$@" || return 1
    fi
    post_build;
}
