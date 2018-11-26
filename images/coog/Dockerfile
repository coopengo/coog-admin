FROM alpine:3.7
MAINTAINER Coopengo <support@coopengo.com>

# RUN addgroup -S -g 1306 coog && adduser -S -u 1306 -G coog coog \
#     && mkdir /workspace && chown coog:coog /workspace \
RUN mkdir /workspace \
    && apk add --no-cache \
        bash python3 redis graphviz libmagic py-hiredis \
        py3-lxml py3-psycopg2 py3-redis py3-ldap3 uwsgi-python3 vim \
    # && ln -s /usr/bin/python3 /usr/bin/python \
    && pip3 install \
        "pyflakes" \
        "ipaddress" \
        "dateutils" \
        "num2words" \
        # "lxml" \
        "python-sql" \
        # "psycopg2" \
        "polib" \
        "Genshi" \
        "relatorio" \
        "python-magic" \
        # "pydot" \
        "pyparsing" \
        "python-stdnum" \
        "unidecode" \
        "intervaltree" \
        "filelock" \
        "wrapt" \
        "werkzeug" \
        "simpleeval" \
        "ldap3" \
        "requests" \
        "raven" \
        "redis<3" \
        # "hiredis" \
        "msgpack-python" \
        # "uwsgi" \
        "celery" \
        "rq" \
        "mock" \
        "phonenumbers" \
        "passlib" \
    && rm -rf /root/.cache \
    && find / -name "__pycache__" -prune -exec rm -rf {} \;

ENV PATH="/workspace/bin:${PATH}"

# USER coog:coog

# RUN mkdir /workspace/bin \
#     && echo '#!/bin/sh' >> /workspace/bin/uwsgi \
#     && echo '/usr/sbin/uwsgi --plugin /usr/lib/uwsgi/python3_plugin.so "$@"' >> /workspace/bin/uwsgi \
#     && chmod u+x /workspace/bin/uwsgi

COPY dist /workspace
COPY ep /workspace/bin

RUN echo $PATH
RUN ls /workspace/bin
RUN ln -s /workspace/trytond/bin/trytond /usr/local/bin \
    && ln -s /workspace/trytond/bin/trytond-admin /usr/local/bin \
    && ln -s /workspace/trytond/bin/trytond-cron /usr/local/bin \
    && ln -s /workspace/ep /usr/local/bin/ep \
    && /workspace/bin/ep link \
    && ln -sf /dev/stderr /tmp/coog.log

VOLUME ["/workspace/sao", "/workspace/coog-bench", "/workspace/coog-doc"]
ENTRYPOINT ["ep"]
EXPOSE 8000
