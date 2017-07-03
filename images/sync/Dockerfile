from node:8-alpine

COPY sync.js /root/sync.js

WORKDIR /root

RUN npm i node-watch minimist && npm cache clean --force && rm -rf /root/.node-gyp

ENTRYPOINT ["node", "/root/sync.js"]
