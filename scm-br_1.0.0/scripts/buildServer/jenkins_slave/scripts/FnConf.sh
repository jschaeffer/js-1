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
if [ -z ${APP} -o -z ${TAR} -o -z ${VERSION} ] ; then
    usage
    exit 1
fi


echo "APP - $APP"
export DESTBASE="/opt/tcserver/${APP}"
export APPSERVER_INSTALLED="/opt/tcserver"
export APPSERVER_HOME="${APPSERVER_INSTALLED}/${APP}"
export APPSERVER_BIN="${APPSERVER_HOME}/bin"
export WORKING_DIR="${APPSERVER_INSTALLED}/App_Files"
export CONFFILES_DIR="${WORKING_DIR}/${APP}/${VERSION}"
export APPSERVER_CONF="${APPSERVER_HOME}/conf*"

cd ${CONFFILES_DIR}/config

DOT="."
export DOT
export REPTARG="${TARGENV}"

if [ -f setenv.functional.* ]
  then
    export REPTARG="functional"
    echo "...using ${REPTARG} .vs. environment specific files."
else
    echo "...using ${REPTARG} environment specific files .vs. functional files."
fi

for base in *${REPTARG}*; do new=`echo $base | sed 's/'${DOT}${REPTARG}'//g'`; echo "Renaming $base to $new and copying to ${INSTANCE}/conf"; cp $base ${APPSERVER_CONF}/$new; ls -al ${APPSERVER_CONF}/$new; done

exit 0
