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


delay_continue() {
          echo "---------------------------------------------------------------------------------"
          echo "[War Date/Time]"; ls -al /opt/tcserver/instances/${INSTANCE}/war/${APP}.war; echo ""; echo "[Webapps As Installed]"; ls -al /opt/tcserver/instances/${INSTANCE}/webapps | grep ${WEBAPPS}; echo ""
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
  -w   Required. Webapps directory name. ex ads-1.2.0
  -v   Verbose
EOF
}

######################################################################
#                       Main script
######################################################################

VERBOSE=${VERBOSE-0}

while getopts "ha:t:r:i:w:e:v" OPTION
do
    case $OPTION in
      a)
        export APP=${OPTARG}
        ;;
      t)
        export TAR=${OPTARG}
        ;;
      h)
        usage
        exit 1
        ;;
      r)
        export VERSION=${OPTARG}
        ;;
      i)
        export INSTANCE=${OPTARG}
        ;;
      w)
        export WEBAPPS=${OPTARG}
        ;;
      e)
        export APPSERVER_IP=${OPTARG}
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
if [ -z ${APP} -o -z ${TAR} -o -z ${VERSION} -o -z ${INSTANCE} -o -z ${WEBAPPS} ] ; then
    usage
    exit 1
fi


export APPSERVER_INSTALLED="/opt/tcserver"
export APPSERVER_HOME="${APPSERVER_INSTALLED}/instances/$INSTANCE"
export WORKING_DIR="${APPSERVER_INSTALLED}/App_Files"

executeCommandNoFail "rm -v ${APPSERVER_HOME}/war/*.war"

executeCommand "cd ${APPSERVER_HOME}/war; tar -xvf ${WORKING_DIR}/${TAR}_${VERSION}.tar ${APP}.war"

delay_continue &
echo "Restart, webapps cleanout, work cleanout, NOT performed to allow for pre-deployment"
exit
