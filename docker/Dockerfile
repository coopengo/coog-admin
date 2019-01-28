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
        graphviz \
        cifs-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install \
        "pyflakes==2.0.0" \
        "dateutils==0.6.6" \
        "num2words==0.5.7" \
        "lxml==4.2.5" \
        "python-sql==0.9" \
        "psycopg2==2.7.5" \
        "polib==1.1.0" \
        "Genshi==0.7.1" \
        "relatorio~=0.6.4" \
        "pydot==1.2.4" \
        "pyparsing==2.2.1" \
        "python-stdnum==1.9" \
        "unidecode==1.0.22" \
        "intervaltree==2.1.0" \
        "filelock==3.0.8" \
        "wrapt==1.10.11" \
        "werkzeug==0.14.1" \
        "simpleeval==0.9.5" \
        "ldap3<2.0" \
        "requests==2.19.1" \
        "raven==6.9.0" \
        "redis==2.10.6" \
        "hiredis==0.2.0" \
        "msgpack-python==0.5.6" \
        "numpy==1.15.1" \
        "scipy==1.1.0" \
        "uwsgi==2.0.17.1" \
        "celery<4" \
        "rq==0.12.0" \
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

VOLUME ["/workspace/sao", "/workspace/coog-bench"]

ENTRYPOINT ["ep"]
EXPOSE 8000
