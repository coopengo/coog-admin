FROM alpine:3.7
MAINTAINER Coopengo <support@coopengo.com>

RUN mkdir /workspace \
    && apk add --no-cache \
        bash python3 redis graphviz libmagic coreutils \
        py3-lxml py3-psycopg2 py3-redis py3-ldap3 uwsgi-python3 vim git \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && pip3 install \
        "pyflakes==2.0.0" \
        "ipaddress==1.0.22" \
        "dateutils==0.6.6" \
        "num2words==0.5.8" \
        "python-sql==1.0.0" \
        "polib==1.1.0" \
        "Genshi==0.7.1" \
        "relatorio==0.8.1" \
        "python-magic==0.4.15" \
        "pydot==1.3.0" \
        "pyparsing==2.3.0" \
        "python-stdnum==1.10" \
        "unidecode==0.4.21" \
        "intervaltree==3.0.2" \
        "filelock==3.0.10" \
        "wrapt==1.10.11" \
        "werkzeug==0.14.1" \
        "simpleeval==0.9.8" \
        "ldap3==2.5.1" \
        "requests==2.20.1" \
        "raven==6.9.0" \
        "msgpack-python==0.5.6" \
        "celery[redis]==4.3.0" \
        "rq==0.12.0" \
        "mock==2.0.0" \
        "phonenumbers==8.10.0" \
        "passlib==1.7.1" \
    && rm -rf /root/.cache \
    && find / -name "__pycache__" -prune -exec rm -rf {} \;

ENV PATH="/workspace/bin:${PATH}"

COPY dist /workspace
COPY ep /workspace/bin/

RUN echo $PATH
RUN ls /workspace/bin
RUN ln -s /workspace/trytond/bin/trytond /usr/local/bin \
    && ln -s /workspace/trytond/bin/trytond-admin /usr/local/bin \
    && ln -s /workspace/trytond/bin/trytond-cron /usr/local/bin \
    && ln -s /workspace/ep /usr/local/bin/ep \
    && /workspace/bin/ep link

VOLUME ["/workspace/sao", "/workspace/coog-bench", "/workspace/coog-doc"]
ENTRYPOINT ["ep"]
EXPOSE 8000
