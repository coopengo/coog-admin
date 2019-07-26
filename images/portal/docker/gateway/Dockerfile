FROm node:10.15-alpine

RUN mkdir -p workspace/gateway
WORKDIR workspace/gateway

COPY ./dist/coog-portal/gateway .

RUN yarn --production

EXPOSE 8000
CMD ['yarn', 'start']
