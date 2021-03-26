FROM node:10-alpine

RUN mkdir -p workspace/api-b2b-config
WORKDIR workspace/api-b2b-config

COPY ./dist/coog-portal/api-b2b-config .

RUN yarn --production
RUN yarn global add nodemon

USER node

EXPOSE 3000
CMD yarn start
