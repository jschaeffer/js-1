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

##############
# Execute a command. Do not fail on exit.
##############
executeCommandNoFail() {

    if [ ${VERBOSE} -eq 1 ] ; then
        echo "Executing : $1"
    fi

    RESULT=`eval "$1"`

    if [ ${VERBOSE} -eq 1 ] ; then
        echo "Result : $RESULT"
    fi
}

##############
# Execute a command. Do not fail on exit.
##############
executeCommandNoFailNoPrint() {

    if [ ${VERBOSE} -eq 1 ] ; then
        echo "Executing : $1"
    fi

    RESULT=`eval "$1"`
}

purge_logs() {

        echo "Purging Log files"
        cd /opt/tcserver/instances/$INSTANCE/logs
        pwd
        for clean in $(find . -maxdepth 1 -type f | sed -e 's/^.\///');
                do rm -f $clean;
                echo "removing $clean";
        done

}


clean_work() {

        echo "Cleaning work directory for $INSTANCE"
        cd /opt/tcserver/instances/$INSTANCE/work
        rm -rf Catalina

}


clean_webapps() {

        echo "Cleaning webapps for $INSTANCE"
        cd /opt/tcserver/instances/$INSTANCE/webapps

        for app in $(awk -F= '/Context path/ { print $2 }' /opt/tcserver/instances/$INSTANCE/conf/server.xml | sed -e 's/^"\///' -e 's/".*//'); do executeCommandNoFail "rm -rf $app"; echo "Removed $app directory"; done
#        for app in $(awk -F= '/Context path/ { echo "$2" }' /opt/tcserver/instances/$INSTANCE/conf/server.xml | sed -e 's/^"\///' -e 's/".*//'); do rm -rf $app; echo "Removed $app directory"; done

}

#############
# Usage message
#############
usage() {
    cat << EOF
usage: $0 options

This script deploys an application to a specified environment.

OPTIONS:
  -h   Show this message
  -a   Required. Application name. ex. oss_bar
  -t   Required.  Application tar file name
  -r   Required. Application version. ex. 2.0.0_2
  -i   Required.  Instance name to deploy to
  -v   Verbose
EOF
}

######################################################################
#                       Main script
######################################################################

VERBOSE=${VERBOSE-0}

while getopts "ha:t:r:i:s:v" OPTION
do
    case $OPTION in
      a)
        APP=${OPTARG}
        ;;
      t)
        TAR=${OPTARG}
        ;;
      h)
        usage
        exit 1
        ;;
      r)
        VERSION=${OPTARG}
        ;;
      i)
        INSTANCE=${OPTARG}
        ;;
     s)
        TARGENV=${OPTARG}
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
if [ -z ${APP} -o -z ${TAR} -o -z ${VERSION} -o -z ${INSTANCE} ] ; then
    usage
    exit 1
fi


echo "INSTANCE - $INSTANCE"
echo "APP - $APP"
export APPSERVER_BASE=${APPSERVER_BASE-/opt/tcserver/instances/$\{INSTANCE\}}
export APPSERVER_INSTALLED="/opt/tcserver"
export APPSERVER_HOME="${APPSERVER_INSTALLED}/instances/$INSTANCE"
export APPSERVER_WAR_DIR="${APPSERVER_BASE}/war"
export APPSERVER_BIN="${APPSERVER_BASE}/bin"
export APPSERVER_CONF="${APPSERVER_INSTALLED}/instances/$INSTANCE/conf"
export WORKING_DIR=${WORKING_DIR-"/tmp/deploymentWorkArea/${TAR}/${VERSION}"}

executeCommand "rm -rf ${APPSERVER_WAR_DIR}/*.war"
#purge_logs
clean_work
clean_webapps

#executeCommand "rm -rf ${APPSERVER_BASE}/webapps/${APP}*"
executeCommand "${APPSERVER_BIN}/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION} -s ${TARGENV}"
executeCommand "cp ${WORKING_DIR}/${APP}*.war ${APPSERVER_WAR_DIR}/."

executeCommand "${APPSERVER_BIN}/tcruntime-ctl.sh start"
executeCommandNoFail "rm ${WORKING_DIR}/${APP}*.war"
executeCommandNoFail "rm -fR ${WORKING_DIR}"
exit 0
