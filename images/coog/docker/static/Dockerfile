FROM node:10.23.1-alpine

RUN mkdir workspace
WORKDIR workspace

COPY ./docker/static/serve.json .
RUN yarn global add serve

COPY ./dist/sao sao
COPY ./dist/coog-bench bench
COPY ./dist/coog-doc doc

USER node

CMD serve

EXPOSE 5000
