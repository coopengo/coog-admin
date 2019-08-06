FROM node:10.15-alpine

RUN mkdir -p workspace/api

COPY ./dist/coog-portal/api .

RUN yarn --production
RUN yarn global add nodemon

USER node
WORKDIR workspace/api

EXPOSE 3000
CMD yarn start
