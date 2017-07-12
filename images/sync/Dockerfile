from alpine:3.6

RUN apk add --no-cache rsync inotify-tools

COPY sync /bin/coog-sync

ENTRYPOINT ["/bin/coog-sync"]
