# Dockerfile to create a WSO2 DAS (Data Analytics Server) Container
#
# Usage:
#
#   Previous steps:
#     1) $ git clone https://github.com/chilcano/docker-wso2-dev-srv.git
#     2) $ cd docker-wso2-dev-srv
#     3) Download '<WSO2_BUNDLE_NAME>.zip' and copy it into '<WSO2_PRODUCT>/<WSO2_VERSION>/assets/'
#
#   Build image:
#     $ docker build --rm -t chilcano/wso2-das wso2das/latest
#
#   Run container:
#     $ docker run -d -t --name=wso2das02a -p 9445:9443 -p 7713:7711 chilcano/wso2-das
# 
#	Check the WSO2 server:
#	  $ docker exec -i -t wso2das02a bash
#	  root@4178f21fcad3:/opt/wso2das02a/bin# tail -f ../repository/logs/wso2carbon.log
#
#	  // opening and exposing the 7713 port to public network
#	  $ docker-machine ssh default -f -N -L <PUBLIC_IP>:7713:localhost:7713
#
#	  // checking remotelly if WSO2 DAS is running
#	  $ nc -vzw 3 <PUBLIC_IP> 7713
#	  $ curl -Ivsk https://<PUBLIC_IP>:9445/carbon/admin/login.jsp -o /dev/null
#

# Base image with Java
FROM java:openjdk-7

MAINTAINER Roger CARHUATOCTO <chilcano at intix dot info>

ENV WSO2_BUNDLE_VER=3.0.1
ENV WSO2_BUNDLE_NAME=wso2das-${WSO2_BUNDLE_VER}
ENV WSO2_FOLDER_NAME=wso2das02a
ENV JAVA_HOME=/usr

# Copy, unzip and remove WSO2 zip to/of container
#COPY assets/${WSO2_BUNDLE_NAME}.zip /opt/
# Disable the next line and enable the above one if you want to copy the ZIP file manually.
RUN wget --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" -U testuser -q -P /opt http://product-dist.wso2.com/products/data-analytics-server/${WSO2_BUNDLE_VER}/${WSO2_BUNDLE_NAME}.zip

RUN unzip /opt/${WSO2_BUNDLE_NAME}.zip -d /opt/ > /opt/${WSO2_FOLDER_NAME}.listfiles
RUN mv /opt/${WSO2_BUNDLE_NAME} /opt/${WSO2_FOLDER_NAME}
RUN rm /opt/${WSO2_BUNDLE_NAME}.zip

# Modifications in 'carbon.xml': Offset, ServerName and additional ServerRole
COPY assets/${WSO2_FOLDER_NAME}/repository/conf/carbon.xml /opt/${WSO2_FOLDER_NAME}/repository/conf/carbon.xml
# Modifications in 'web.xml': SessionTimeout 600mins
COPY assets/${WSO2_FOLDER_NAME}/repository/conf/tomcat/carbon/WEB-INF/web.xml /opt/${WSO2_FOLDER_NAME}/repository/conf/tomcat/carbon/WEB-INF/web.xml

# WSO2 DAS ports (Offset +0)
# https://docs.wso2.com/display/DAS301/WSO2+DAS+Specific+Ports

# WSO2 DAS - Ports available for all modes (Local, Cluster and Client mode)
#spark.ui.port: 			 4040
#spark.history.ui.port: 	 18080
#spark.blockManager.port: 	 12000
#spark.broadcast.port: 		 12500
#spark.driver.port: 		 13000
#spark.executor.port: 		 13500
#spark.fileserver.port: 	 14000
#spark.replClassServer.port: 14500

# WSO2 DAS - Ports available for the Cluster mode
#spark.master.port: 		7077
#spark.master.rest.port: 	6066
#spark.master.webui.port: 	8081
#spark.worker.port:			11000
#spark.worker.webui.port: 	11500

EXPOSE 9443 9763 
EXPOSE 7711 7611
EXPOSE 4040 18080
EXPOSE 6066 8081 11500

# Expose WSO2 repository folder to Host
VOLUME ["/opt/${WSO2_FOLDER_NAME}/repository/deployment/server"]
VOLUME ["/opt/${WSO2_FOLDER_NAME}/repository/components/dropins"]
VOLUME ["/opt/${WSO2_FOLDER_NAME}/repository/components/lib"]
VOLUME ["/opt/${WSO2_FOLDER_NAME}/repository/resources/security"]

# Working Directory in Container
WORKDIR /opt/${WSO2_FOLDER_NAME}/bin/

# Start WSO2
CMD sh ./wso2server.sh
