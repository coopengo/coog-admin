FROM alpine:edge
MAINTAINER Coopengo <support@coopengo.com>

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo '#!/bin/sh' >> /usr/local/bin/uwsgi \
    && echo '/usr/sbin/uwsgi --plugin /usr/lib/uwsgi/python3_plugin.so "$@"' >> /usr/local/bin/uwsgi \
    && chmod u+x /usr/local/bin/uwsgi \
    && apk add --no-cache \
        python3 cifs-utils redis graphviz \
        py3-lxml py3-psycopg2 py3-redis py-hiredis py3-ldap3 py3-scipy uwsgi-python3 \
    && pip3 install \
        "pyflakes~=1.6.0" \
        "dateutils~=0.6.6" \
        "num2words~=0.5.5" \
        "python-sql~=0.9" \
        "polib~=1.0.8" \
        "Genshi~=0.7" \
        "relatorio~=0.7.0" \
        "python-magic~=0.4.15" \
        "pydot~=1.2.3" \
        "pyparsing~=2.2.0" \
        "python-stdnum~=1.6" \
        "unidecode~=0.4.21" \
        "intervaltree~=2.1.0" \
        "filelock~=2.0.12" \
        "wrapt~=1.10.11" \
        "werkzeug~=0.12.2" \
        "simpleeval~=0.9.5" \
        "requests~=2.18.4" \
        "raven~=6.1.0" \
        "msgpack-python~=0.4.8" \
        "celery~=4.1.0" \
        "rq~=0.8.2"

RUN mkdir /workspace

COPY ./dist /workspace
COPY ./ep /workspace/

RUN 2to3 --no-diffs -w -n /workspace > /dev/null \
    && ln -s /workspace/trytond/bin/trytond /usr/local/bin \
    && ln -s /workspace/trytond/bin/trytond-admin /usr/local/bin \
    && ln -s /workspace/trytond/bin/trytond-cron /usr/local/bin \
    && ln -s /workspace/ep /usr/local/bin/ep \
    && ep link

VOLUME ["/workspace/sao", "/workspace/coog-bench", "/workspace/coog-doc"]
ENTRYPOINT ["ep"]
EXPOSE 8000
