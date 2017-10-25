FROM java:jre

ENV BI_RELEASE=7.1 \
	BI_VERSION=7.1.0.0-12 \
	PENTAHO_HOME=/opt/pentaho 
ENV PENTAHO_SERVER=${PENTAHO_HOME}/pentaho-server

RUN curl -L -o /tmp/pentaho-server-ce-${BI_VERSION}.zip https://sourceforge.net/projects/pentaho/files/Business%20Intelligence%20Server/${BI_RELEASE}/pentaho-server-ce-${BI_VERSION}.zip/download \
    && unzip -q /tmp/pentaho-server-ce-${BI_VERSION}.zip -d $PENTAHO_HOME \
	&& rm /tmp/pentaho-server-ce-${BI_VERSION}.zip

ENV PENTAHO_JAVA_HOME $JAVA_HOME

RUN apt-get -qq update && apt-get install -qq -y netcat postgresql-client
RUN apt-get install strace
RUN rm ${PENTAHO_SERVER}/tomcat/lib/postgresql-9.3-1102-jdbc4.jar \
	&& curl -L -o ${PENTAHO_SERVER}/tomcat/lib/postgresql-9.4.1212.jar https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar

# Disable daemon mode for Tomcat
RUN sed -i -e 's/\(exec ".*"\) start/\1 run/' ${PENTAHO_SERVER}/tomcat/bin/startup.sh

EXPOSE 8080

COPY dist/coog-bi/server/scripts ${PENTAHO_HOME}/scripts
COPY dist/coog-bi/server/config ${PENTAHO_HOME}/config
COPY dist/coog-bi/server/default ${PENTAHO_HOME}/default

ENTRYPOINT ["sh", "-c", "$PENTAHO_HOME/scripts/run.sh"]
