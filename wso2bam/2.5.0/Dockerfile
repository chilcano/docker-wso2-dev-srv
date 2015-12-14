# Dockerfile to create a WSO2 Business Activity Monitor container
#
# Usage:
#
#   Previous steps:
#     1) $ git clone https://github.com/chilcano/docker-wso2-dev-srv.git
#     2) $ cd docker-wso2-dev-srv
#     3) Download '<WSO2_BUNDLE_NAME>.zip' and copy it into '<WSO2_PRODUCT>/<WSO2_VERSION>/assets/_downloads'
#
#   Build image:
#     $ docker build --rm -t chilcano/wso2-bam:2.5.0 wso2bam/2.5.0
#
#   Run container:
#     $ docker run -d -t --name=wso2bam02a -p 19443:9443 chilcano/wso2-bam:2.5.0
# 
#	Check the WSO2 server:
#	  $ docker exec -i -t wso2bam02a bash
#	  root@4178f21fcad3:/opt/wso2bam02a/bin# tail -f ../repository/logs/wso2carbon.log
#
#	  $ curl -v -k https://<IP_ADDRESS>:19443/services/Version
#


# Base image with Java
FROM java:openjdk-7

MAINTAINER Roger CARHUATOCTO <chilcano at intix dot info>

ENV WSO2_BUNDLE_NAME=wso2bam-2.5.0
ENV WSO2_FOLDER_NAME=wso2bam02a
ENV JAVA_HOME=/usr

# Copy, unzip and remove WSO2 zip to/of container
##COPY assets/_downloads/${WSO2_BUNDLE_NAME}.zip /opt/
# Disable the next line and enable the above one if you have downloaded and copied the ZIP file manually.
RUN wget -q -P /opt https://s3-us-west-2.amazonaws.com/wso2-stratos/${WSO2_BUNDLE_NAME}.zip
RUN unzip /opt/${WSO2_BUNDLE_NAME}.zip -d /opt/ > /opt/${WSO2_FOLDER_NAME}.listfiles
RUN mv /opt/${WSO2_BUNDLE_NAME} /opt/${WSO2_FOLDER_NAME}
RUN rm /opt/${WSO2_BUNDLE_NAME}.zip

# Copy WSO2 custom config files to container
#   Modifications in 'carbon.xml': Offset, ServerName and additional ServerRole
COPY assets/_files/${WSO2_FOLDER_NAME}/repository/conf/carbon.xml /opt/${WSO2_FOLDER_NAME}/repository/conf/carbon.xml
#   Modifications in 'web.xml': SessionTimeout 600mins
COPY assets/_files/${WSO2_FOLDER_NAME}/repository/conf/tomcat/carbon/WEB-INF/web.xml /opt/${WSO2_FOLDER_NAME}/repository/conf/tomcat/carbon/WEB-INF/web.xml

# Carbon ports (Offset +0)
EXPOSE 9443 9763 9160 7711 7611 21000

# Expose WSO2 repository folder to Host
VOLUME ["/opt/${WSO2_FOLDER_NAME}/repository/deployment/server"]
VOLUME ["/opt/${WSO2_FOLDER_NAME}/repository/components/dropins"]
VOLUME ["/opt/${WSO2_FOLDER_NAME}/repository/components/lib"]
VOLUME ["/opt/${WSO2_FOLDER_NAME}/repository/resources/security"]

# Working Directory in Container
WORKDIR /opt/${WSO2_FOLDER_NAME}/bin/

# Start WSO2
CMD sh ./wso2server.sh
