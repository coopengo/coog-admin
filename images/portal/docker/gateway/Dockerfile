FROM node:10.15-alpine

WORKDIR workspace/gateway

COPY ./dist/coog-portal/gateway /workspace/gateway

RUN yarn --production \
    yarn global add nodemon
    
USER node

EXPOSE 8000
