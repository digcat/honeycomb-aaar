FROM java:7

MAINTAINER Digcat info@digcat.com
#MAINTAINER Wellington Marinho wpmarinho@globo.com

# Init ENV
ENV BISERVER_VERSION 6.0 
ENV BISERVER_TAG 6.0.1.0-386
ENV TAPA_VERSION 0.3.1
ENV SAIKU_VERSION 6-3.7
ENV PIVOT4J_VERSION 1.0-SNAPSHOT 
ENV AAAR_VERSION 4.2

ENV PENTAHO_HOME /opt/pentaho

# Apply JAVA_HOME
RUN . /etc/environment
ENV PENTAHO_JAVA_HOME $JAVA_HOME
ENV PENTAHO_JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64

# Install Dependences
RUN apt-get update; apt-get install zip netcat -y; \
    apt-get install wget unzip git postgresql-client-9.4 vim -y; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    curl -O https://bootstrap.pypa.io/get-pip.py; \
    python get-pip.py; \
    pip install awscli; \
    rm -f get-pip.py

RUN mkdir ${PENTAHO_HOME}; useradd -s /bin/bash -d ${PENTAHO_HOME} pentaho; chown pentaho:pentaho ${PENTAHO_HOME}
RUN chown -R pentaho:pentaho /opt

USER pentaho

# Download Pentaho BI Server
RUN /usr/bin/wget --progress=dot:giga http://downloads.sourceforge.net/project/pentaho/Business%20Intelligence%20Server/${BISERVER_VERSION}/biserver-ce-${BISERVER_TAG}.zip -O /tmp/biserver-ce-${BISERVER_TAG}.zip; \
    /usr/bin/unzip -q /tmp/biserver-ce-${BISERVER_TAG}.zip -d  $PENTAHO_HOME; \
    rm -f /tmp/biserver-ce-${BISERVER_TAG}.zip $PENTAHO_HOME/biserver-ce/promptuser.sh; \
    sed -i -e 's/\(exec ".*"\) start/\1 run/' $PENTAHO_HOME/biserver-ce/tomcat/bin/startup.sh; \
    chmod +x $PENTAHO_HOME/biserver-ce/start-pentaho.sh

RUN /usr/bin/wget --progress=dot:giga http://downloads.sourceforge.net/project/pentaho/Data%20Integration/${BISERVER_VERSION}/pdi-ce-${BISERVER_TAG}.zip -O /tmp/pdi-ce-${BISERVER_TAG}.zip; \
    /usr/bin/unzip -q /tmp/pdi-ce-${BISERVER_TAG}.zip -d /opt; \
    rm -f /tmp/pdi-ce-${BISERVER_TAG}.zip ; \
    chown -R pentaho:pentaho /opt/data-integration

RUN /usr/bin/wget --progress=dot:giga http://meteorite.bi/downloads/saiku-plugin-p${SAIKU_VERSION}.zip -O /tmp/saiku-pluginp${SAIKU_VERSION}.zip && \
    /usr/bin/unzip -q /tmp/saiku-pluginp${SAIKU_VERSION}.zip -d /opt/pentaho/biserver-ce/pentaho-solutions/system && \
    chown -R pentaho:pentaho /opt/pentaho/biserver-ce/pentaho-solutions/system/saiku

RUN /usr/bin/wget --progress=dot:giga http://ci.greencatsoft.com/job/Pivot4J/lastSuccessfulBuild/artifact/pivot4j-pentaho/target/pivot4j-pentaho-${PIVOT4J_VERSION}-plugin.zip -O /tmp/pivot4j-pentaho-${PIVOT4J_VERSION}-plugin.zip && \
    /usr/bin/unzip -q /tmp/pivot4j-pentaho-${PIVOT4J_VERSION}-plugin.zip -d /opt/pentaho/biserver-ce/pentaho-solutions/system && \ 
    chown -R pentaho:pentaho /opt/pentaho/biserver-ce/pentaho-solutions/system/pivot4j

#RUN /usr/bin/wget --progress=dot:giga https://github.com/marpontes/tapa/releases/download/v${TAPA_VERSION}/tapa-${TAPA_VERSION}-pentaho6.zip -O /tmp/tapa-${TAPA_VERSION}-pentaho6.zip && /usr/bin/unzip -q /tmp/tapa-${TAPA_VERSION}-pentaho6.zip -d /opt/pentaho/biserver-ce/pentaho-solutions/system && chown -R pentaho:pentaho /opt/pentaho/biserver-ce/pentaho-solutions/system/tapa 

COPY files/tmp/tapa-${TAPA_VERSION}-pentaho6.zip /tmp/tapa-${TAPA_VERSION}-pentaho6.zip
 
RUN  /usr/bin/unzip -q /tmp/tapa-${TAPA_VERSION}-pentaho6.zip -d /opt/pentaho/biserver-ce/pentaho-solutions/system && \
     chown -R pentaho:pentaho /opt/pentaho/biserver-ce/pentaho-solutions/system/tapa
RUN /usr/bin/wget --progress=dot:giga https://beecon.orderofthebee.org/assets/AAARBig.png -O /tmp/AAARBig.png
USER root
#RUN cp /tmp/AAARBig.png ${PENTAHO_HOME}/biserver-ce/pentaho-solutions/system/AAAR/static/custom/img/AAARBig.png
COPY files/pentaho-transparent-authentication-mappings.json ${PENTAHO_HOME}/biserver-ce/pentaho-solutions/system/pentaho-transparent-authentication-mappings.json 
RUN  chown pentaho:pentaho $PENTAHO_HOME/biserver-ce/pentaho-solutions/system/pentaho-transparent-authentication-mappings.json
USER pentaho
COPY files/config $PENTAHO_HOME/config
COPY files/scripts $PENTAHO_HOME/scripts
COPY files/addons/AAAR_v4.2.zip /tmp/AAAR_v4.2.zip
COPY files/log4j.xml /opt/data-integration/system/log4j.xml
COPY files/repositories.xml /opt/pentaho/repositories.xml
RUN  /usr/bin/unzip -q /tmp/AAAR_v4.2.zip -d $PENTAHO_HOME/biserver-ce/pentaho-solutions/system
COPY files/addons/saiku-olap-util-3.7-SNAPSHOT.jar $PENTAHO_HOME/biserver-ce/tomcat/webapps/pentaho/WEB-INF/lib/saiku-olap-util-3.7-SNAPSHOT.jar
RUN mkdir /opt/logs
RUN chmod +x $PENTAHO_HOME/biserver-ce/pentaho-solutions/system/AAAR/endpoints/kettle/script/AAAR_*.sh
COPY files/getextractandpublish.sh $PENTAHO_HOME/biserver-ce/pentaho-solutions/system/AAAR/endpoints/kettle/script/getextractandpublish.sh
WORKDIR /opt/pentaho 
EXPOSE 8080 
CMD ["sh", "scripts/run.sh"]
