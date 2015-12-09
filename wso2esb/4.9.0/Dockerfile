# ==================================================================================== #
# DOCKERFILE FOR WSO2 ESB 4.9.0                                                        #
# ------------------------------------------------------------------------------------ #
# Instructions:                                                                        #
#   1) $ git clone https://github.com/chilcano/docker-wso2-dev-srv.git                 #
#	2) $ cd docker-wso2-dev-srv                                                        #
#   3) Download wso2esb-4.9.0.zip and copy it into 'wso2esb/4.9.0/assets/_downloads'   #
# Build image:                                                                         #
#   $ docker build --rm -t chilcano/wso2-esb:4.9.0 wso2esb/4.9.0                       #
# Run container:                                                                       #
#   $ docker run -d -t --name=wso2esb01a -p 19449:9443 chilcano/wso2-esb:4.9.0         #
# ==================================================================================== #

# Base image with Java
FROM java:openjdk-7

MAINTAINER Roger CARHUATOCTO <chilcano at intix dot info>

ENV WSO2_BUNDLE_NAME=wso2esb-4.9.0
ENV WSO2_FOLDER_NAME=wso2esb01a
ENV JAVA_HOME=/usr

# Copy, unzip and remove WSO2 zip to/of container
COPY assets/_downloads/${WSO2_BUNDLE_NAME}.zip /opt/
RUN unzip /opt/${WSO2_BUNDLE_NAME}.zip -d /opt/ > /opt/${WSO2_FOLDER_NAME}.listfiles
RUN mv /opt/${WSO2_BUNDLE_NAME} /opt/${WSO2_FOLDER_NAME}
RUN rm /opt/${WSO2_BUNDLE_NAME}.zip

# Copy WSO2 custom config files to container
# Modifications in 'carbon.xml': Offset +6, ServerName 'WSO2ESB01A', additional ServerRole 'ESB_FRONT_ROLE'
COPY assets/_files/${WSO2_FOLDER_NAME}/repository/conf/carbon.xml /opt/${WSO2_FOLDER_NAME}/repository/conf/carbon.xml
# Modifications in 'web.xml': SessionTimeout 600mins
COPY assets/_files/${WSO2_FOLDER_NAME}/repository/conf/tomcat/carbon/WEB-INF/web.xml /opt/${WSO2_FOLDER_NAME}/repository/conf/tomcat/carbon/WEB-INF/web.xml

# Carbon ports (Offset +0)
EXPOSE 9443
EXPOSE 8280

# Expose WSO2 repository folder to Host
VOLUME ["/opt/${WSO2_FOLDER_NAME}/repository/deployment/server"]
VOLUME ["/opt/${WSO2_FOLDER_NAME}/repository/components/dropins"]
VOLUME ["/opt/${WSO2_FOLDER_NAME}/repository/components/lib"]
VOLUME ["/opt/${WSO2_FOLDER_NAME}/repository/resources/security"]

# Working Directory in Container
WORKDIR /opt/${WSO2_FOLDER_NAME}/bin/

# Start WSO2
CMD sh ./wso2server.sh
