FROM python:3-slim
MAINTAINER Coopengo <support@coopengo.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc \
        vim \
        libpq-dev \
        libldap2-dev \
        libsasl2-dev \
        redis-tools \
        graphviz \
        libmagic1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install \
        "pyflakes" \
        "ipaddress" \
        "dateutils" \
        "num2words" \
        "lxml" \
        "python-sql" \
        "psycopg2-binary" \
        "polib" \
        "Genshi" \
        "relatorio" \
        "python-magic" \
        "pydot" \
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
        "redis" \
        "hiredis" \
        "msgpack-python" \
        "uwsgi" \
        "celery" \
        "rq" \
        "mock" \
        "phonenumbers" \
        "passlib" \
    && rm -rf /root/.cache

RUN mkdir /workspace
COPY ./dist /workspace
COPY ./ep /workspace/

RUN ln -s /workspace/trytond/bin/trytond /usr/local/bin \
    && ln -s /workspace/trytond/bin/trytond-admin /usr/local/bin \
    && ln -s /workspace/trytond/bin/trytond-cron /usr/local/bin \
    && ln -s /workspace/ep /usr/local/bin/ep \
    && ep link \
    && ln -sf /dev/stderr /tmp/coog.log

VOLUME ["/workspace/sao", "/workspace/coog-bench", "/workspace/coog-doc"]
ENTRYPOINT ["ep"]
EXPOSE 8000
