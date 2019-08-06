from nginx:1.17-alpine

RUN mkdir workspace
workdir workspace

copy ./docker/coog-static/nginx.conf /etc/nginx/nginx.conf

copy ./dist/sao sao
copy ./dist/coog-bench bench
copy ./dist/coog-doc doc

USER nginx

Expose 8000
