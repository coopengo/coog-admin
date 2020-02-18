FROM alpine:3.7
MAINTAINER Coopengo <support@coopengo.com>

RUN addgroup -g 1003 coog \
    && adduser -u 1003 -G coog -s /bin/sh -D coog \
    && mkdir /workspace

RUN adduser \
    -D \
    -g "" \
    -G coog \
    -H \
    -u 1000 \
    coog_saas


RUN apk add --no-cache \
        bash python3 redis graphviz libmagic coreutils \
        py3-lxml py3-psycopg2 py3-redis py3-ldap3 uwsgi-python3 vim git \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && pip3 install \
        "Genshi" \
        "kombu==4.6.3" \
        "celery==4.3.0" \
        "dateutils" \
        "fastjsonschema==2.13" \
        "filelock" \
        "intervaltree" \
        "ipaddress" \
        "ldap3" \
        "mock" \
        "msgpack-python" \
        "num2words" \
        "passlib" \
        "phonenumbers" \
        "polib" \
        "pydot" \
        "pyflakes" \
        "pyjwt" \
        "pyparsing" \
        "PyPDF2" \
        "python-magic" \
        "python-sql" \
        "python-stdnum" \
        "raven" \
        "redis>=3" \
        "relatorio" \
        "requests" \
        "rq" \
        "simpleeval" \
        "unidecode" \
        "werkzeug==0.14.1" \
        "wrapt" \
    && rm -rf /root/.cache \
    && find / -name "__pycache__" -prune -exec rm -rf {} \;

COPY dist/trytond/ /workspace/trytond/
COPY dist/trytond-modules/ /workspace/trytond-modules/ 
COPY dist/coog/ /workspace/coog/
COPY dist/proteus/ /workspace/proteus/

ARG ep
COPY docker/coog/${ep} /workspace/bin/ep


RUN ln -s /workspace/trytond/bin/trytond /workspace/bin/trytond \
    && ln -s /workspace/trytond/bin/trytond-admin /workspace/bin/trytond-admin \
    && ln -s /workspace/trytond/bin/trytond-cron /workspace/bin/trytond-cron \
    && /workspace/bin/ep link

RUN chown -R coog:coog /workspace
RUN chmod -R 771 /workspace
USER coog

ENV PATH="/workspace/bin:${PATH}"

ENTRYPOINT ["ep"]
EXPOSE 8000
