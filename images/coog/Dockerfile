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
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && rm -rf /root/.cache

RUN mkdir /workspace
COPY ./dist /workspace
COPY ./ep /workspace/

RUN ls /workspace/coog
RUN pip install /workspace/coog/requirements.txt
RUN ln -s /workspace/trytond/bin/trytond /usr/local/bin
RUN ln -s /workspace/trytond/bin/trytond-admin /usr/local/bin
RUN ln -s /workspace/trytond/bin/trytond-cron /usr/local/bin
RUN ln -s /workspace/ep /usr/local/bin/ep
RUN ep link

VOLUME ["/workspace/sao", "/workspace/coog-bench", "/workspace/coog-doc"]
ENTRYPOINT ["ep"]
EXPOSE 8000
