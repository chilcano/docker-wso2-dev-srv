# Docker Containers to develop (micro)services with WSO2

A set of Docker scripts useful to compose Systems/Architectures containers layouts for (Micro)services development purpose using WSO2 and other products as ActiveMQ, Qpid, RabbitMQ, Monitoring tools, etc.

## Containers

The configuration/functionalities not changed for each WSO2 container are:

* Log4j configuration
* The User/Password for Admin Web Carbon Console
* H2 database

The idea is creating several base docker images where we can compose complex architecture to implement (micro)services.
Then, the available scripts to create a base docker images are:

1. [WSO2 Enterprise Server Bus](http://wso2.com/products/enterprise-service-bus)
  * version 4.8.1
  * version 4.9.0
2. [WSO2 API Manager](http://wso2.com/api-management/try-it)
  * version 1.8.0
  * version 1.9.1
3. WSO2 Governance Registry (wip)
  * version 5.1.0
4. WSO2 Microservice Server (wip)
  * version 1.0.0-alpha
5. Message Broker (wip)
  * RabbitMQ
  * WSO2 Message Broker
  * Apache ActiveMQ
  * Apache Qpid
6. Data Persistence (wip)
  * MySQL
  * PostgreSQL
  * Redis
  * Cassandra
7. [WSO2 Business Activity Monitor](http://wso2.com/more-downloads/business-activity-monitor)
  * version 2.5.0
8. WSO2 Data Analytics Server (wip)
  * version 3.0.0
9. Wiremock Server (wip)
  * version 3.0.0


![WSO2 Development Server - Docker Containers Map](https://github.com/docker-wso2-dev-srv/blob/master/chilcano-wso2-dev-srv-docker-containers-map.png "WSO2 Development Server - Docker Containers Map")


## Getting starting

In each WSO2 container are being copied the carbon.xml and web.xml files, where carbon.xml has updated parameters and they are a new ServerRole, Offset and ServerName. Change them if you require it.


### Building and Running base images.

__1) Download docker scripts:__
```bash
$ git clone https://github.com/chilcano/docker-wso2-dev-srv.git
$ cd docker-wso2-dev-srv
```

__2) Create an image:__
```bash
$ docker build --rm -t chilcano/wso2-esb:4.8.1 wso2esb/4.8.1
```
Where:
- `chilcano/wso2-esb:4.8.1` is the tag of the new image
- `wso2esb/4.8.1` is the `PATH` where Dockerfile is located

__3) Check created images:__
```bash
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
chilcano/wso2-esb   4.8.1               254476f8c58e        6 seconds ago       1.393 GB
java                openjdk-7           a93511e8921b        12 days ago         589.7 MB
```

__4) Create, run, attach and stop a new container:__

Create and run new container:
```bash
$ docker run --detach -t --name=wso2esb01a -p 19449:9443 chilcano/wso2-esb:4.8.1
d1f5628233cfe25bdf7331d8c79d7f49bdb6375bb52c2f13f0d25708c1d46c38
```

Where:
- `--detach` or `-d` means to run the container in detached mode
- `wso2esb01a` is the name of container
- `19449` is the external port for the port `9443`
- `chilcano/wso2-esb:4.8.1` is the tag of image
- `-t` creates a pseudo-TTY, if this parameter is not provided, then when attaching the running container you will neve can release the shell session.

Stop a running container:
```bash
$ docker stop wso2esb01a
wso2esb01a

```
Check if container is running:
```bash
$ docker ps -a
CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS                       PORTS               NAMES
259a3d3eb8e0        chilcano/wso2-esb:4.8.1   "/bin/sh -c 'sh ./wso"   26 minutes ago      Exited (137) 3 minutes ago                       wso2esb01a
```

Now, restart the existing container:
```bash
$ docker start wso2esb01a
wso2esb01a
```

... and check again if container is running:
```bash
$ docker ps -a
CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS              PORTS                               NAMES
259a3d3eb8e0        chilcano/wso2-esb:4.8.1   "/bin/sh -c 'sh ./wso"   36 minutes ago      Up 32 seconds       8286/tcp, 0.0.0.0:19449->9443/tcp   wso2esb01a

```

__5) Go to WSO2 Carbon Web Console__

If container is running, just open this URL (`https://<WSO2_HOST_IP>:19449/carbon`) in a browser.
The `<WSO2_HOST_IP>` in my case is `192.168.99.102`. You can get it running this command:
```bash
$ docker-machine ls
NAME           ACTIVE   DRIVER       STATE     URL                         SWARM   ERRORS
default        *        virtualbox   Running   tcp://192.168.99.102:2376
machine-dev    -        virtualbox   Running   tcp://192.168.99.100:2376
machine-test   -        virtualbox   Running   tcp://192.168.99.101:2376
```

Where `default` is the active machine (is marked with `*`), then the `192.168.99.102` will be the IP Address to be used as `<WSO2_HOST_IP>`.

__6) Attach to a running container:__


```bash
$ docker attach --no-stdin=false wso2esb01a

```

Where `--no-stdin=false` means to enable the pseudo-TTY and to release shell, just send Ctrl+C.

__7) Get a Shell/SSH session from a running container:__

```bash
$ docker exec -i -t wso2esb01a bash
root@4689e1574550:/opt/wso2esb01a/bin#
root@4689e1574550:/opt/wso2esb01a/bin# ls
README.txt	carbondump.sh  ciphertool.bat  java2wsdl.sh			    tcpmon.bat		    version.txt    wso2carbon-version.txt  wso2server.bat
build.xml	chpasswd.bat   ciphertool.sh   org.wso2.carbon.bootstrap-4.2.0.jar  tcpmon.sh		    wsdl2java.bat  wso2esb-samples.bat	   wso2server.sh
carbondump.bat	chpasswd.sh    java2wsdl.bat   tcpmon-1.0.jar			    tomcat-juli-7.0.34.jar  wsdl2java.sh   wso2esb-samples.sh	   yajsw
```

... and tailing the wso2carbon.log:

```bash
root@4689e1574550:/opt/wso2esb01a/bin# tail -f ../repository/logs/wso2carbon.log
TID: [0] [ESB] [2015-12-09 15:13:39,596]  INFO {org.apache.synapse.transport.passthru.PassThroughHttpSSLListener} -  Pass-through HTTPS Listener started on 0:0:0:0:0:0:0:0:8249 {org.apache.synapse.transport.passthru.PassThroughHttpSSLListener}
TID: [0] [ESB] [2015-12-09 15:13:39,597]  INFO {org.apache.synapse.transport.passthru.PassThroughHttpListener} -  Starting Pass-through HTTP Listener... {org.apache.synapse.transport.passthru.PassThroughHttpListener}
TID: [0] [ESB] [2015-12-09 15:13:39,597]  INFO {org.apache.synapse.transport.passthru.PassThroughHttpListener} -  Pass-through HTTP Listener started on 0:0:0:0:0:0:0:0:8286 {org.apache.synapse.transport.passthru.PassThroughHttpListener}
TID: [0] [ESB] [2015-12-09 15:13:39,600]  INFO {org.apache.tomcat.util.net.NioSelectorPool} -  Using a shared selector for servlet write/read {org.apache.tomcat.util.net.NioSelectorPool}
TID: [0] [ESB] [2015-12-09 15:13:39,683]  INFO {org.apache.tomcat.util.net.NioSelectorPool} -  Using a shared selector for servlet write/read {org.apache.tomcat.util.net.NioSelectorPool}
TID: [0] [ESB] [2015-12-09 15:13:39,719]  INFO {org.wso2.carbon.registry.eventing.internal.RegistryEventingServiceComponent} -  Successfully Initialized Eventing on Registry {org.wso2.carbon.registry.eventing.internal.RegistryEventingServiceComponent}
TID: [0] [ESB] [2015-12-09 15:13:39,792]  INFO {org.wso2.carbon.core.init.JMXServerManager} -  JMX Service URL  : service:jmx:rmi://localhost:11117/jndi/rmi://localhost:10005/jmxrmi {org.wso2.carbon.core.init.JMXServerManager}
TID: [0] [ESB] [2015-12-09 15:13:39,792]  INFO {org.wso2.carbon.core.internal.StartupFinalizerServiceComponent} -  Server           :  WSO2ESB01A-4.8.1 {org.wso2.carbon.core.internal.StartupFinalizerServiceComponent}
TID: [0] [ESB] [2015-12-09 15:13:39,793]  INFO {org.wso2.carbon.core.internal.StartupFinalizerServiceComponent} -  WSO2 Carbon started in 28 sec {org.wso2.carbon.core.internal.StartupFinalizerServiceComponent}
TID: [0] [ESB] [2015-12-09 15:13:40,112]  INFO {org.wso2.carbon.ui.internal.CarbonUIServiceComponent} -  Mgt Console URL  : https://172.17.0.2:9443/carbon/ {org.wso2.carbon.ui.internal.CarbonUIServiceComponent}
TID: [0] [ESB] [2015-12-09 15:14:26,563]  INFO {org.wso2.carbon.core.services.util.CarbonAuthenticationUtil} -  'admin@carbon.super [-1234]' logged in at [2015-12-09 15:14:26,562+0000] {org.wso2.carbon.core.services.util.CarbonAuthenticationUtil}

```


## References

1. [Using Docker registry for WSO2 images](http://www.juancarlosgpelaez.com/wso2-in-docker-registry-en)
2. [The Docker user guide](https://docs.docker.com/engine/userguide)
3. [The Docker commands](https://docs.docker.com/engine/reference/commandline)

