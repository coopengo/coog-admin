FROm node:10.15-alpine

RUN mkdir -p workspace/api
WORKDIR workspace/api

COPY ./dist/coog-portal/api .

RUN yarn --production
RUN yarn global add nodemon

EXPOSE 3000
CMD ['yarn', 'start']
