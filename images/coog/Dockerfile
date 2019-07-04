FROM python:2-slim
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
        git \
        openssh-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install \
        "pyflakes==1.6.0" \
        "dateutils==0.6.6" \
        "num2words==0.5.5" \
        "lxml==3.8.0" \
        "python-sql==0.9" \
        "psycopg2==2.7.3.1" \
        "polib==1.0.8" \
        "Genshi==0.7" \
        "relatorio==0.8.1" \
        "python-magic==0.4.15" \
        "pydot==1.2.3" \
        "pyparsing==2.2.0" \
        "python-stdnum==1.6" \
        "unidecode==0.4.21" \
        "intervaltree==2.1.0" \
        "filelock==2.0.12" \
        "wrapt==1.10.11" \
        "werkzeug==0.12.2" \
        "simpleeval==0.9.5" \
        "ldap3==2.5.1" \
        "requests==2.18.4" \
        "raven==6.1.0" \
        "hiredis==0.2.0" \
        "msgpack-python==0.4.8" \
        "uwsgi==2.0.15" \
        "celery[redis]==4.3.0" \
        "rq==0.13" \
        "mock==2.0.0" \
    && rm -rf /root/.cache

RUN mkdir /workspace
COPY ./dist /workspace
COPY ./ep /workspace/

RUN ln -s /workspace/trytond/bin/trytond /usr/local/bin
RUN ln -s /workspace/trytond/bin/trytond-admin /usr/local/bin
RUN ln -s /workspace/trytond/bin/trytond-cron /usr/local/bin
RUN ln -s /workspace/ep /usr/local/bin/ep
RUN ep link

VOLUME ["/workspace/sao", "/workspace/coog-bench", "/workspace/coog-doc"]
ENTRYPOINT ["ep"]
EXPOSE 8000
