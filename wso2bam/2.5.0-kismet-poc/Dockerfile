# Dockerfile to create a WSO2 BAM container for WIFI Traffic capture PoC
#
# This container has: 
# - WSO2 BAM 2.5.0
# - WIFI Traffic capture Toolbox (Simple Dashboard in JavaScritp to view captured WIFI traffic)
# - A set of Streams and Execution Plan definitions of WSO2's Siddhi (Complex Event Processor)
#
# Usage:
#
# $ cd docker-wso2-dev-srv/
# $ docker build --rm -t chilcano/wso2-bam:2.5.0-kismet-poc wso2bam/2.5.0-kismet-poc
# $ docker run -dt --name=wso2bam-kismet-poc -p 9445:9443/tcp -p 7713:7711/tcp chilcano/wso2-bam:2.5.0-kismet-poc
# $ docker exec -it wso2bam-kismet-poc bash
# root@4178f21fcad3:/opt/wso2bam-kismet-poc/bin# tail -f ../repository/logs/wso2carbon.log
#
# $ curl -v -k https://<IP_ADDRESS>:9443/services/Version
#
# $ ssh docker@$(docker-machine ip default) -f -N -L 192.168.1.43:7713:localhost:7713 (user/pwd: docker/tcuser)
#
# $ cd wso2bam-wifi-thrift-cassandra-poc/wso2bam_toolbox/
# $ find . -name '*.DS_Store' -type f -delete
# $ zip -r kismet_wifi_realtime_traffic.tbox kismet_wifi_realtime_traffic
# $ docker cp kismet_wifi_realtime_traffic.tbox wso2bam-kismet:/opt/wso2bam02a/repository/deployment/server/bam-toolbox/.


# Chilcano's base image for WSO2 BAM
FROM chilcano/wso2-bam:2.5.0

MAINTAINER Roger CARHUATOCTO <chilcano at intix dot info>

ENV WSO2_FOLDER_NAME=wso2bam02a

# Deploy set of Streams, Execution Plan, CEP Siddhi scripts and new Real Time Dashboard
#RUN git clone https://github.com/chilcano/wso2bam-wifi-thrift-cassandra-poc
COPY assets/wso2bam-wifi-thrift-cassandra-poc/wso2bam_toolbox/kismet_wifi_realtime_traffic.tbox /opt/${WSO2_FOLDER_NAME}/repository/deployment/server/bam-toolbox
COPY assets/wso2bam-wifi-thrift-cassandra-poc/wso2bam_defns/repository/deployment/server/. /opt/${WSO2_FOLDER_NAME}/repository/deployment/server

