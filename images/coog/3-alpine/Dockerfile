FROM alpine:3.7
MAINTAINER Coopengo <support@coopengo.com>

RUN addgroup -S -g 1306 coog && adduser -S -u 1306 -G coog coog \
    && mkdir /workspace && chown coog:coog /workspace \
    && apk add --no-cache \
        python3 redis graphviz libmagic \
        py3-lxml py3-psycopg2 py3-redis py3-ldap3 uwsgi-python3 \
    && ln -s /usr/bin/python3 /usr/bin/python \
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
        "rq~=0.8.2" \
        "mock~=2.0.0" \
    && rm -rf /root/.cache \
    && find / -name "__pycache__" -prune -exec rm -rf {} \;

ENV PATH="/workspace/bin:${PATH}"

USER coog:coog

RUN mkdir /workspace/bin \
    && echo '#!/bin/sh' >> /workspace/bin/uwsgi \
    && echo '/usr/sbin/uwsgi --plugin /usr/lib/uwsgi/python3_plugin.so "$@"' >> /workspace/bin/uwsgi \
    && chmod u+x /workspace/bin/uwsgi

COPY --chown=coog:coog dist /workspace
COPY --chown=coog:coog ep /workspace/bin

RUN 2to3 --no-diffs -w -n /workspace 2> /dev/null \
    && ln -s /workspace/trytond/bin/trytond /workspace/bin \
    && ln -s /workspace/trytond/bin/trytond-admin /workspace/bin \
    && ln -s /workspace/trytond/bin/trytond-cron /workspace/bin \
    && ep link \
    && ln -sf /dev/stderr /tmp/coog.log

VOLUME ["/workspace/sao", "/workspace/coog-bench", "/workspace/coog-doc"]
ENTRYPOINT ["ep"]
EXPOSE 8000
