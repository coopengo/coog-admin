FROM python:2-slim
MAINTAINER Coopengo <support@coopengo.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc \
        vim \
        libpq-dev \
        libldap2-dev \
        libsasl2-dev \
        libreoffice-writer \
        libreoffice-calc \
        unoconv \
        redis-tools \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install \
        pyflakes \
        dateutils \
        num2words \
        lxml \
        python-sql \
        psycopg2 \
        polib \
        Genshi \
        relatorio \
        pydot \
        pyparsing \
        python-stdnum \
        unidecode \
        intervaltree \
        filelock \
        wrapt \
        werkzeug \
        simpleeval \
        ldap3 \
        requests \
        raven \
        redis \
        hiredis \
        msgpack-python \
        numpy \
        scipy \
        uwsgi \
        "celery<4" \
        rq \
    && rm -rf /root/.cache

RUN mkdir /workspace && mkdir /workspace/data
# coog-related repositories
COPY ./workspace /workspace
# entrypoint
COPY ./ep /workspace/

RUN ln -s /workspace/trytond/bin/trytond /usr/local/bin
RUN ln -s /workspace/trytond/bin/trytond-admin /usr/local/bin
RUN ln -s /workspace/trytond/bin/trytond-cron /usr/local/bin
RUN ln -s /workspace/ep /usr/local/bin/ep
RUN ep link

VOLUME ["/coog/sao", "/coog/coog-bench"]

ENTRYPOINT ["ep"]
EXPOSE 8000
