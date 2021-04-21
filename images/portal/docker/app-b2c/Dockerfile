FROM node:10.23.0-alpine

RUN yarn global add serve

RUN mkdir /app
COPY ./dist/coog-portal/app-b2c /app/app-b2c
WORKDIR /app/app-b2c

COPY docker/app-b2c/ep /app/
COPY docker/app-b2c/serve.json /app/
RUN ln -s /app/ep /usr/local/bin/ep

USER node

ENTRYPOINT ["ep"]
EXPOSE 5000
