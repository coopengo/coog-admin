FROM node:10.15-alpine

RUN mkdir -p workspace/gateway
RUN mkdir -p workspace/api-identity-manager

COPY ./docker/gateway/launcher workspace/

COPY ./dist/coog-portal/gateway workspace/gateway
COPY ./dist/coog-portal/api-identity-manager workspace/api-identity-manager

RUN cd workspace/gateway \
    && yarn --production \
    && cd ../api-identity-manager \
    && yarn --production

USER node
WORKDIR workspace/

USER node
WORKDIR workspace/gateway

EXPOSE 8000
ENTRYPOINT ["/workspace/launcher"]
