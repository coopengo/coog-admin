FROM alpine:3.7
MAINTAINER Coopengo <support@coopengo.com>

RUN mkdir /workspace \
    && apk add --no-cache \
        bash python3 redis graphviz libmagic coreutils \
        py3-lxml py3-psycopg2 py3-redis py3-ldap3 uwsgi-python3 vim git \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && rm -rf /root/.cache \
    && find / -name "__pycache__" -prune -exec rm -rf {} \;

ENV PATH="/workspace/bin:${PATH}"

COPY dist /workspace
COPY ep /workspace/bin/

RUN echo $PATH
RUN ls /workspace/coog
RUN pip3 install /workspace/coog/requirements.txt
RUN ls /workspace/bin
RUN ln -s /workspace/trytond/bin/trytond /usr/local/bin \
    && ln -s /workspace/trytond/bin/trytond-admin /usr/local/bin \
    && ln -s /workspace/trytond/bin/trytond-cron /usr/local/bin \
    && ln -s /workspace/ep /usr/local/bin/ep \
    && /workspace/bin/ep link

VOLUME ["/workspace/sao", "/workspace/coog-bench", "/workspace/coog-doc"]
ENTRYPOINT ["ep"]
EXPOSE 8000
