from node:8-alpine

RUN mkdir /web
COPY ./dist /web
WORKDIR /web/coog-api

RUN apk add --no-cache --virtual .build-deps wget ca-certificates make gcc g++ python linux-headers musl-dev \
    && apk add -qU openssh git \
    && npm i --production \
    && npm cache clean --force \
    && rm -rf /root/.node-gyp \
    && apk del .build-deps

COPY ./ep /web/
RUN ln -s /web/ep /usr/local/bin/ep
RUN ep link

VOLUME ["/web/coog-app"]
ENTRYPOINT ["ep"]
EXPOSE 3000
