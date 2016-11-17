#!/bin/bash

##############
# Execute a command and exit on failure.
##############
executeCommand() {
    
    if [ ${VERBOSE} -eq 1 ] ; then
        echo "Executing : $1"
    fi
    
    eval $1
    
    if [ $? -ne 0 ] ; then
        echo "ERROR: Error executing $1"
        exit 1
    fi
}

#############
# Usage message
#############
usage() {
    cat << EOF
usage: $0 options

This script stops an application server.

OPTIONS:
  -h   Show this message
  -a   Required. Application name. ex. oss_bar
  -v   Verbose
EOF
}

######################################################################
#                       Main script
######################################################################

VERBOSE=${VERBOSE-0}

while getopts "ha:v" OPTION
do
    case $OPTION in
      a)
        APP=${OPTARG}
        ;;
      h)
        usage
        exit 1
        ;;
      v)
        VERBOSE=1
        ;;
      ?)
        usage
        exit
        ;;
    esac
done

# Ensure required parameters are entered
if [ -z ${APP} ] ; then
    usage
    exit 1
fi

export APPSERVER_BASE="/opt/tcserver/instances/${APP}"
export PROC_KEY=OSS_BAR_CONFIG        # Key used to find the tcServer process to stop.

#####
# Stop tomcat
####
#sudo /sbin/service tcserver stop=oss_bar
${APPSERVER_BASE}/bin/tcruntime-ctl.sh stop

# Give tomcat up to 8 seconds to die, then hard kill
COUNTER=8
until [ $COUNTER -eq 0 ]; do
    echo $COUNTER
    #????? What should the key for a given tcServer instance.
    if [ `ps -ef | grep -v grep | grep -c ${PROC_KEY}` = 1 ]; then
        echo "tcserver alive"
        sleep 1
        let COUNTER-=1
    else 
        echo "tcserver shutdown"
        COUNTER=0
    fi
done

# if tcserver is still alive, kill it
if [ `ps -ef | grep -v grep | grep -c ${PROC_KEY}` = 1 ]; then
    echo 'killing tomcat'
    kill -9 `ps -ef | grep -v grep | grep ${PROC_KEY} | awk '{ print $2 }'`
fi

if [ `ps -ef | grep -v grep | grep -c ${PROC_KEY}` = 1 ]; then
    echo 'Failed to shutdown tcServer.'
    exit 1
fi

exit 0
