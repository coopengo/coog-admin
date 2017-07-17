from alpine:3.6

RUN apk add --no-cache rsync inotify-tools

COPY ep /bin/ep

ENTRYPOINT ["/bin/ep"]
