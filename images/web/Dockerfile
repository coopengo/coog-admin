from node:8-alpine

RUN mkdir /web
COPY ./web /web
WORKDIR /web/coog-api

RUN apk add --no-cache --virtual .build-deps wget ca-certificates make gcc g++ python linux-headers musl-dev \
    && npm i --production \
    && npm cache clean --force \
    && rm -rf /root/.node-gyp \
    && apk del .build-deps

VOLUME ["/web/coog-app"]
ENTRYPOINT ["node", "svc"]
EXPOSE 3000
