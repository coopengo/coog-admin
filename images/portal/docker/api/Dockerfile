FROM node:10.23.1-alpine

RUN mkdir -p workspace/api
WORKDIR workspace/api

COPY ./dist/coog-portal/api .

RUN yarn --production
RUN yarn global add nodemon

USER node

EXPOSE 3000
CMD yarn start
