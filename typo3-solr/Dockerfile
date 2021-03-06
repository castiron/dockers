FROM ubuntu

#Download stuff
RUN apt-get install -y curl
RUN curl -L http://mirrors.ibiblio.org/apache/lucene/solr/4.8.0/solr-4.8.0.tgz | tar -xzv
RUN mv /solr-4.8.0 /usr/local/src/
RUN curl -L http://mirror.metrocast.net/apache//commons/logging/binaries/commons-logging-1.1.3-bin.tar.gz | tar -xzv
RUN mv commons-logging-1.1.3 /usr/local/src/
RUN curl -L http://www.slf4j.org/dist/slf4j-1.7.7.tar.gz | tar -xzv
RUN mv /slf4j-1.7.7 /usr/local/src/

# Instal repo packages
RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update -y
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN apt-get install -y oracle-java7-installer tomcat7
RUN apt-get install -y tomcat7-admin

RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> /etc/environment

# Get commons logging dependency for solr
RUN cp /usr/local/src/commons-logging-1.1.3/commons-logging-*.jar /usr/share/tomcat7/lib/

# Get slf4j dependency for solr
RUN cp /usr/local/src/slf4j-1.7.7/slf4j-*.jar /usr/share/tomcat7/lib/
RUN rm -rf /usr/share/tomcat7/lib/slf4j-android-*.jar
RUN chown -R tomcat7:tomcat7 /var/lib/tomcat7

# Get TYPO3 Solr
RUN apt-get install -y unzip
ADD config/install-solr.sh /opt/install-solr.sh
RUN chmod 777 /opt/install-solr.sh && ./opt/install-solr.sh
RUN mv /opt/solr-tomcat/solr /home/solr
RUN rm -rf /opt/solr-tomcat
RUN chown -R tomcat7 /home/solr

# Start tomcat and update the solr config file. Starting Tomcat matters because it will setup
# the webapps/solr directory, etc.
RUN /etc/init.d/tomcat7 restart
ADD config/web.xml /var/lib/tomcat7/webapps/solr/WEB-INF/web.xml
ADD config/tomcat-users.xml /etc/tomcat7/tomcat-users.xml
RUN chown -R tomcat7:tomcat7 /var/lib/tomcat7/webapps/solr/WEB-INF/web.xml
RUN chown -R tomcat7:tomcat7 /etc/tomcat7/tomcat-users.xml
RUN /etc/init.d/tomcat7 stop

# Add the tomcat startup script
ADD config/run.sh /opt/run.sh
RUN chmod 777 /opt/run.sh

EXPOSE 8080
CMD ["/opt/run.sh"]
