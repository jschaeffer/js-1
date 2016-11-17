#!/bin/bash

PROG=`basename $0`
USAGE="$PROG: start|stop"

[ $# -ne 1 ] && echo $USAGE && exit 1
what=$1

# Configuration details
APPHOME_DIR=$(cd $(dirname $0); pwd)
PID_FILE=$APPHOME_DIR/pid.file
source $APPHOME_DIR/conf/setenv.sh

# Execute the command
case "$what" in
     start)
          [ -f ${PID_FILE} ] && echo -e "\nNOTICE: Application already started.\n" && exit 3

          nohup $JAVA_HOME/bin/java $JAVA_OPTS -jar ${APP_JAR} &

          # snag proccess id
          JAVAPID=$!

          # write out pid number to pid file
          echo "PID ${JAVAPID}"
          echo ${JAVAPID} > ${PID_FILE}
	  echo -e "\nNOTICE: Application STARTED.\n"
     ;;
     stop)
          [ ! -f ${PID_FILE} ] && echo -e "\nNOTICE: PID file NOT found.\n" && exit 4

          # read in pid number then kill
          PID=`cat ${PID_FILE}`
          kill $PID
          echo -e "\nNOTICE: Application STOPPED.\n"
          rm -f ${PID_FILE}
     ;;
     *)
	echo -e "\n$USAGE\n"
     ;;
esac
exit 0