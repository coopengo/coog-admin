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
        git clone -q --recurse-submodules "$3" "$1/$2" || return 1
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

repo_cp() { # <dd> <repo> <branch>
    local d; d=$(git diff --stat HEAD | wc -l)
    [ "$d" -ne 0 ] && echo "repo $2 not clean" >&2 && return 1
    local rev; rev=$(guess_rev "$3")

    mkdir "$1/$2" || return 1

    if [ -d build ]
    then
        echo "  build and copy"
        ./build/build "$rev" > /dev/null \
            && cp -R ./dist/* "$1/$2/" \
            || return 1
    else
        echo "  copy"
        git archive HEAD | tar x -C "$1/$2" || return $?
        git submodule foreach "git archive HEAD | tar x -C $1/$2/\$path" || return $?
    fi
    if [ -d doc ] && [ -f doc/build ]
    then
        echo "build and copy doc"
        ./doc/build > /dev/null && cp -R "doc/dist/html" "$1/$2-doc"
    fi

    git clean -d -f -X
}

build() { # <image-tag> <repositories> -- [docker-build-arg*]
    local script_path; script_path=$(readlink -f "$0")
    local wd; wd=$(dirname "$script_path")
    local dd; dd="$wd/dist"
    local clones; clones="$wd/clones"

    touch "$wd/repos.custom"
    mkdir -p "$clones" || return 1
    mkdir "$dd" || return 1

    local image; image="$1"
    shift

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
        (cd "$clones/$repo" && repo_cp "$dd" "$repo" "$branch") || return 1
        shift
    done

    find "$dd" -name ".git" | xargs rm -rf
    docker build -t "$image" "$@" "$wd"

    rm -rf "$dd"
}
