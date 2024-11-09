# Use Oracle Linux 9 as the base image
FROM oraclelinux:9

# Set environment variables for Tomcat
ENV TOMCAT_VERSION=10.1.31
ENV CATALINA_HOME=/opt/tomcat
ENV PATH="$CATALINA_HOME/bin:$PATH"

# Install required packages
RUN yum install -y java-11-openjdk openssl curl && \
    yum clean all

# Download and extract Tomcat
RUN curl -O https://downloads.apache.org/tomcat/tomcat-10/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz && \
    mkdir -p /opt/tomcat && \
    tar xvf apache-tomcat-$TOMCAT_VERSION.tar.gz -C /opt/tomcat --strip-components=1 && \
    rm apache-tomcat-$TOMCAT_VERSION.tar.gz

# Create the tomcat user and group
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat

# Copy the custom server.xml configuration file
COPY server.xml $CATALINA_HOME/conf/

# Copy SSL cert generation script and make it executable
COPY generate-cert.sh /generate-cert.sh
RUN chmod +x /generate-cert.sh

# Expose SSL port
EXPOSE 4041

# Copy the sample web application into the webapps directory
RUN curl -o $CATALINA_HOME/webapps/sample.war https://tomcat.apache.org/tomcat-10.0-doc/appdev/sample/sample.war

# Set ENTRYPOINT to generate SSL certs and start Tomcat
ENTRYPOINT ["/bin/bash", "-c", "/generate-cert.sh && catalina.sh run"]
# Run the SSL cert generation and start Tomcat when the container runs.