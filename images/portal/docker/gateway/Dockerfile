FROM node:10.24.1-alpine

WORKDIR workspace/gateway

COPY ./dist/coog-portal/gateway /workspace/gateway

RUN yarn --production; \
    yarn global add nodemon;
    
USER node

CMD yarn start

EXPOSE 8000
