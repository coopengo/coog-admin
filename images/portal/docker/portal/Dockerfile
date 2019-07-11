FROM node:10.15-alpine

RUN mkdir /web
COPY ./dist/coog-portal/portal /portal
WORKDIR /portal/coog-portal

RUN yarn global add serve

COPY docker/portal/ep /portal/
RUN ln -s /portal/ep /usr/local/bin/ep

EXPOSE 5000
