#!/bin/bash
 
# Script name: 
#       wiremock.sh
# Description: 
#       This shell script starts, stops and restarts Wiremock server. 
#       If you run this script, then the container will stop.
#       In other words, use it if you want stop the wiremock process, 
#       exit of the shell session and stop the container.
#

PRODUCT_CODE="wiremock"
USER="root"

MOCK_BUNDLE="wiremock-2.0.6-standalone.jar"
MOCK_HOME="/opt/${PRODUCT_CODE}"
MOCK_PORT_HTTP="8080"
MOCK_PORT_HTTPS="8443"

LOCK_FILE="${MOCK_HOME}/bin/wiremock.lck"
LOG_FILE="${MOCK_HOME}/logs/wiremock.log"
STUBS_PATH="${MOCK_HOME}/stubs"

MOCK_ARGS="--root-dir ${MOCK_HOME}/stubs --port ${MOCK_PORT_HTTP} --https-port ${MOCK_PORT_HTTPS} --verbose"

CMD_START="cd ${MOCK_HOME}/bin ; java -jar ${MOCK_BUNDLE} ${MOCK_ARGS}"
CMD_STOP="kill -9"
JAVA_HOME="/usr/java/latest"

export JAVA_HOME=$JAVA_HOME

# Status the service
status() {
  PID=`ps axww | grep 8443 | grep wiremock | grep -v grep | awk '{print $1}'`
  ps -fp $PID > /dev/null 2>&1
  PIDVAL=$?
  if [ $PIDVAL -eq 0 ]
    then
      echo "[$PRODUCT_CODE] server is running (pid "$PID")"
    else
      echo "[$PRODUCT_CODE] server is stopped (pid not found)"
  fi
  return $PIDVAL
}

# Start Wiremock
start() {
  PID=`ps axww | grep 8443 | grep wiremock | grep -v grep | awk '{print $1}'`
  ps -fp $PID > /dev/null 2>&1
  PIDVAL=$?
  if [ $PIDVAL -eq 0 ]
    then
      echo "[$PRODUCT_CODE] server is running (pid "$PID")"
    else
      echo -n "[$PRODUCT_CODE] server starting ... "
      touch $LOCK_FILE
      su - $USER -c "$CMD_START > $LOG_FILE 2>&1 &"
      sleep 5
      PID=`ps axww | grep 8443 | grep wiremock | grep -v grep | awk '{print $1}'`
      ps -fp $PID > /dev/null 2>&1
      PIDVAL=$?
      if [ $PIDVAL -eq 0 ]
        then
          echo "success (pid "$PID")"
        else
          echo "failure (pid "$PID")"
      fi
  fi
  return $PIDVAL
}


# Stop Wiremock
stop() {
  PID=`ps axww | grep 8443 | grep wiremock | grep -v grep | awk '{print $1}'`
  ps -fp $PID > /dev/null 2>&1
  PIDVAL=$?
  if [ $PIDVAL -eq 0 ]
      then
         echo -n "[$PRODUCT_CODE] server ... "
         su - $USER -c "$CMD_STOP $PID > /dev/null 2>&1 &"
         rm -f $LOCK_FILE
         sleep 10
         PID=`ps axww | grep 8443 | grep wiremock | grep -v grep | awk '{print $1}'`
         ps -fp $PID > /dev/null 2>&1
         PIDVAL=$?
         if [ $PIDVAL -eq 0 ]
             then
                echo "failure (pid "$PID")"
                PIDVAL=2
             else
                echo "success (pid "$PID")"
                PIDVAL=0
         fi
      else
         echo "[$PRODUCT_CODE] server is not running (pid not found)"
         PIDVAL=0
  fi
  return $PIDVAL
}

### Main logic ###
case "$1" in
start)
    start
    ;;
stop)
    stop
    ;;
status)
    status
    ;;
restart)
    stop
    start
    ;;
*)
   echo $"Usage: $0 {start|stop|restart|status}"
   exit 1
esac
exit $?