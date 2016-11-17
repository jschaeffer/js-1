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

fncleanWebapps() {

        echo "Cleaning webapps for $INSTANCE"
        cd /opt/tcserver/instances/$INSTANCE/webapps
        ls -al /opt/tcserver/instances/$INSTANCE/webapps
        executeCommandNoFail "rm -rf $WEBAPPS"; echo "Removed $app directory"
        if [[ ${APP} = "request-manager" ]] ; then
          executeCommand "rm -fr /opt/tcserver/instances/$INSTANCE/webapps/ROOT"
        fi
        ls -al $WEBAPPS
}

fnDelayContinue() {
        export i=0
        export file="/opt/tcserver/instances/${INSTANCE}/logs/tcserver.pid"

       while [ $i -le 20 ]; do
        until [ -f "$file" ]; do
           echo "Restarting ... $i seconds"
           sleep 1
           i=$(($i + 1))
        done
          echo "pid present"
          echo "tcserver instance took $i seconds to restart"
        exit
       done
       exit 1
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

while getopts "ha:t:r:i:w:e:s:v" OPTION
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
      s)
        export TARGENV=${OPTARG}
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
export APPSERVER_BIN="${APPSERVER_HOME}/bin"
export WORKING_DIR="${APPSERVER_INSTALLED}/App_Files"
export CONFFILES_DIR="${WORKING_DIR}/${TAR}/${VERSION}"
export APPSERVER_CONF="${APPSERVER_HOME}/conf"
export APPSERVER_BIN="${APPSERVER_HOME}/bin"

fncleanWebapps
executeCommand "cd ${APPSERVER_HOME}/webapps; tar -xvf ${WORKING_DIR}/${TAR}_${VERSION}.tar ${APP}.war"
executeCommand "mkdir ${WORKING_DIR}/${TAR}; mkdir ${CONFFILES_DIR}; cd ${CONFFILES_DIR}; tar -xf ${WORKING_DIR}/${TAR}_${VERSION}.tar"
if [[ ${APP} = "request-manager" ]] ; then
  executeCommand "mv ${APPSERVER_HOME}/webapps/${APP}.war ${APPSERVER_HOME}/webapps/ROOT.war"
fi

## Control statement for Decision Engine inclusion:
case $APP in
  ads|psn) cd ${CONFFILES_DIR}/ads_config;;
  cis) cd ${CONFFILES_DIR}/cis_config;;
  *) cd ${CONFFILES_DIR}/config;;
esac

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

case $INSTANCE in
  ads) executeCommandNoFail "mv ${APPSERVER_CONF}/setenv.ads.sh ${APPSERVER_BIN}/setenv.sh"
       executeCommandNoFail "rm ${APPSERVER_CONF}/setenv.psn.sh"
  ;;
  psn) executeCommandNoFail "mv ${APPSERVER_CONF}/setenv.psn.sh ${APPSERVER_BIN}/setenv.sh"
       executeCommandNoFail "rm ${APPSERVER_CONF}/setenv.ads.sh"
  ;;
  *) executeCommandNoFail "mv ${APPSERVER_CONF}/setenv.sh ${APPSERVER_BIN}/setenv.sh"
  ;;
esac

executeCommandNoFail "cd ${APPSERVER_BIN}; ./tcruntime-ctl.sh start" 
#fnDelayContinue
executeCommandNoFail "rm ${WORKING_DIR}/${TAR}_${VERSION}.tar"
executeCommandNoFail "rm ${WORKING_DIR}/${TAR}/${VERSION}/*.*"
executeCommandNoFail "rm -fR ${WORKING_DIR}/${TAR}"
exit 0
