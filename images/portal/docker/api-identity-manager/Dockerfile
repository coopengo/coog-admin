FROM node:10.15-alpine

WORKDIR workspace/api-identity-manager

COPY ./dist/coog-portal/api-identity-manager .

RUN yarn --production; \
  yarn global add nodemon

USER node

EXPOSE 3000
CMD yarn start
