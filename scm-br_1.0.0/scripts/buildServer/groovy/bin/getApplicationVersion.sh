#!/bin/ksh

##############
# Execute a command and exit on failure.
##############
executeCommand() {
    
    if [ ${VERBOSE} -eq 1 ] ; then
        print Executing : $1
    fi
    
    RESULT=`eval "$1"`
    
    if [ $? -ne 0 ] ; then
        print ERROR: Error executing $1
        exit 1
    fi
    
}

##############
# Execute a command. Do not fail on exit.
##############
executeCommandNoFail() {
    
    if [ ${VERBOSE} -eq 1 ] ; then
        print Executing : $1
    fi
    
    eval $1
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
  -v   Verbose
EOF
}

######################################################################
#                       Main script
######################################################################

export VERBOSE=0
RESULT=""

while getopts "ha:i:e:j:p:r:u:v" OPTION
do
    case $OPTION in
      a)
        APP=${OPTARG}
        ;;
      i)
        INSTANCE=${OPTARG}
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

export APPSERVER_BASE="/opt/tcserver/instances/${INSTANCE}"
export APPSERVER_WAR="${APPSERVER_BASE}/webapps"

#export WORKING_DIR="/tmp/deploymentWorkArea"
WORKING_DIR=${WORKING_DIR-"/tmp/deploymentWorkArea/${TAR}/${VERSION}"}

executeCommandNoFail "rm -rf ${WORKING_DIR}"
executeCommand "mkdir ${WORKING_DIR}"
executeCommand "cp ${APPSERVER_WAR}/${APP}*.war ${WORKING_DIR}"
executeCommand "cd ${WORKING_DIR} ; jar xf ${APP}*.war ; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"

echo ${RESULT}
exit 0

