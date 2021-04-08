FROM node:10.24.0-alpine

RUN mkdir -p workspace/api-b2c
WORKDIR workspace/api-b2c

COPY ./dist/coog-portal/api-b2c .

RUN yarn --production
RUN yarn global add nodemon

USER node

EXPOSE 3000
CMD yarn start
