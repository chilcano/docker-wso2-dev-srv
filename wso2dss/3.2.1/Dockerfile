# Dockerfile to create a WSO2 Data Services Server
#
# Usage:
#
#   Previous steps:
#     1) $ git clone https://github.com/chilcano/docker-wso2-dev-srv.git
#     2) $ cd docker-wso2-dev-srv
#     3) Download '<WSO2_BUNDLE_NAME>.zip' and copy it into '<WSO2_FOLDER_NAME>/<WSO2_VERSION>/assets/_downloads'
#
#   Build image:
#     $ docker build --rm -t chilcano/wso2-dss:3.2.1 wso2dss/3.2.1
#
#   Run container:
#     $ docker run -d -t --name=<WSO2_FOLDER_NAME> -p 19446:9443 chilcano/wso2-dss:3.2.1
# 
#	Check WSO2 server:
#	  $ docker exec -i -t <WSO2_FOLDER_NAME> bash
#	  root@3031f21fcad3:/opt/<WSO2_FOLDER_NAME>/bin# tail -f ../repository/logs/wso2carbon.log
#
#	  $ curl -v -k https://<IP_ADDRESS>:19446/services/Version
#

# Base image with Java
FROM java:openjdk-7

MAINTAINER Roger CARHUATOCTO <chilcano at intix dot info>

ENV WSO2_BUNDLE_NAME=wso2dss-3.2.1
ENV WSO2_FOLDER_NAME=wso2dss01a
ENV JAVA_HOME=/usr

# Copy, unzip and remove WSO2 zip to/of container
COPY assets/_downloads/${WSO2_BUNDLE_NAME}.zip /opt/
RUN unzip /opt/${WSO2_BUNDLE_NAME}.zip -d /opt/ > /opt/${WSO2_FOLDER_NAME}.listfiles
RUN mv /opt/${WSO2_BUNDLE_NAME} /opt/${WSO2_FOLDER_NAME}
RUN rm /opt/${WSO2_BUNDLE_NAME}.zip

# Copy WSO2 custom config files to container
#   Modifications in 'carbon.xml': Offset, ServerName, additional ServerRole
COPY assets/_files/${WSO2_FOLDER_NAME}/repository/conf/carbon.xml /opt/${WSO2_FOLDER_NAME}/repository/conf/carbon.xml
#   Modifications in 'web.xml': SessionTimeout 600mins
COPY assets/_files/${WSO2_FOLDER_NAME}/repository/conf/tomcat/carbon/WEB-INF/web.xml /opt/${WSO2_FOLDER_NAME}/repository/conf/tomcat/carbon/WEB-INF/web.xml

# Carbon ports (Offset +0)
EXPOSE 9443 9763 8243 8280

# Expose WSO2 repository folder to Host
VOLUME ["/opt/${WSO2_FOLDER_NAME}/repository/deployment/server"]
VOLUME ["/opt/${WSO2_FOLDER_NAME}/repository/components/dropins"]
VOLUME ["/opt/${WSO2_FOLDER_NAME}/repository/components/lib"]
VOLUME ["/opt/${WSO2_FOLDER_NAME}/repository/resources/security"]

# Working Directory in Container
WORKDIR /opt/${WSO2_FOLDER_NAME}/bin/

# Start WSO2
CMD sh ./wso2server.sh
