FROM node:10.15-alpine

RUN mkdir /web
COPY ./dist /portal
WORKDIR /portal/coog-portal

RUN yarn global add serve

COPY ./ep /portal/
RUN ln -s /portal/ep /usr/local/bin/ep

ENTRYPOINT ["ep"]
EXPOSE 5000
