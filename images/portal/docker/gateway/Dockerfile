FROm node:10.15-alpine

RUN mkdir -p workspace/gateway

COPY ./dist/coog-portal/gateway .

RUN yarn --production

USER node
WORKDIR workspace/gateway

EXPOSE 8000
CMD ['yarn', 'start']
