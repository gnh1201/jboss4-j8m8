FROM centos:7 
MAINTAINER Go Namhyeon <gnh1201@gmail.com>
# RUN useradd -m -d /opt/jboss -s /bin/bash jboss

# install oracle jdk8
RUN yum update -y && \
yum install -y wget && \
wget --no-cookies --no-check-certificate \
  --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
   "http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-x64.rpm" && \
yum localinstall -y jdk-8u102-linux-x64.rpm && \
rm -f jdk-8u102-linux-x64.rpm && \
yum clean all

RUN yum -y install vim
RUN yum -y install nano
RUN yum update -y && yum -y install xmlstarlet saxon augeas bsdtar unzip && yum clean all

RUN groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss && \
    chmod 755 /opt/jboss

# user jboss
USER jboss
RUN cd $home && wget http://sourceforge.net/projects/jboss/files/JBoss/JBoss-4.2.3.GA/jboss-4.2.3.GA.zip && unzip jboss-4.2.3.GA.zip && rm jboss-4.2.3.GA.zip

# Enable remote debugging 
ENV JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8000

# Expose the ports we're interested in
# Webserver is running on 8080 
# Adminserver is running on 9990
# Remote debug port can be accessed on 8000
EXPOSE 8080 9990 8000 1098 1099 3873 4444 4445 4446 8009 8083 8090 8092 8093

# Configurations
ENV JBOSS_HOME=/opt/jboss/jboss-4.2.3.GA
ADD ejb3/jboss-service.xml /opt/jboss/jboss-4.2.3.GA/server/default/deploy/ejb3.deployer/META-INF/jboss-service.xml

# install mysql
USER root
ENV PACKAGE_URL https://repo.mysql.com/yum/mysql-8.0-community/docker/x86_64/mysql-community-server-minimal-8.0.0-0.1.dmr.el7.x86_64.rpm

# Install server
RUN rpmkeys --import http://repo.mysql.com/RPM-GPG-KEY-mysql \
  && yum install -y $PACKAGE_URL \
  && yum install -y libpwquality \
  && rm -rf /var/cache/yum/*
RUN mkdir /docker-entrypoint-initdb.d

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

USER jboss
ADD run.sh /opt/run.sh
# Set the default command to run on boot
CMD ["/bin/bash", "/opt/run.sh"]
