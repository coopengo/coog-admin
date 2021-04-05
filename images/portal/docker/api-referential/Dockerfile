FROM node:10.23-alpine

RUN mkdir -p workspace/api-referential
WORKDIR workspace/api-referential

COPY ./dist/coog-portal/api-referential .

RUN yarn --production
RUN yarn global add nodemon

USER node

EXPOSE 3000
CMD yarn start
