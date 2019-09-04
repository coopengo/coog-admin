FROM node:10.15-alpine

RUN yarn global add serve

RUN mkdir /web
COPY ./dist/coog-portal/portal /portal/coog-portal
WORKDIR /portal/coog-portal

COPY docker/portal/ep /portal/
COPY docker/portal/serve.json /portal/
RUN ln -s /portal/ep /usr/local/bin/ep

USER node

ENTRYPOINT ["ep"]
EXPOSE 5000
