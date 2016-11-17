#!/bin/ksh 

##############
# Execute a command and exit on failure.
##############
executeCommand() {
    
    if [ ${VERBOSE} -eq 1 ] ; then
        print Executing : $1
    fi
    
    eval $1
    
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

    RESULT=`eval "$1"`

    if [ ${VERBOSE} -eq 1 ] ; then
        print Result : $RESULT
    fi
}

##############
# Execute a command. Do not fail on exit.
##############
executeCommandNoFailNoPrint() {

    if [ ${VERBOSE} -eq 1 ] ; then
        print Executing : $1
    fi

    RESULT=`eval "$1"`
}

clean_work() {

        echo "Cleaning work directory for $INSTANCE"
        cd /opt/tcserver/instances/$INSTANCE/work
        executeCommand "rm -rf Catalina"

}

clean_webapps() {

        echo "Cleaning webapps for $INSTANCE"
        cd /opt/tcserver/instances/$INSTANCE/webapps
        for app in $(awk -F= '/Context path/ { print $2 }' /opt/tcserver/instances/$INSTANCE/conf/server.xml | sed -e 's/^"\///' -e 's/".*//'); do executeCommandNoFail "rm -rf $app"; echo "Removed $app directory"; done

}

delay_continue() {
        export i=0
        export pidfile="/opt/tcserver/instances/${INSTANCE}/logs/tcserver.pid"
        export webapps="/opt/tcserver/instances/${INSTANCE}/webapps/${WEBAPPS}"

#  Check if PID file gets created by start command
         until [ -f "$pidfile" ]; do
          echo "---------------------------------------------------------------------------------"
          echo "Restarting ... Begin checking for PID file... $i seconds"
          sleep 1
          i=$(($i + 1))
         done
         echo "Pidfile showed up in $i second(s)"
       export i=0

#  Check if webapps directory gets populated with .war file contents
         until [[ -d "$webapps" || "$i" -gt 20 ]]; do
          sleep 1
          i=$(($i + 1))
          #echo "After Pidfile appearance, checking for WebApps directory population... $i second(s)"
          if [ ! -f "$pidfile" ] ; then
           echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
           echo "ERROR: Error restarting tcserver - PID file died after restart attempt"
           echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
          exit 1
          fi
          done
#  Post check to verify pidfile and webapps still intact
          if [ ! -d "$webapps" ] ; then
           echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
           echo "ERROR: Error running tcserver - No WebApps directory population"
           echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
          exit 1
          fi
          echo "WebApps population showed up in $i seconds"
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
clean_work
clean_webapps

executeCommand "cd ${APPSERVER_HOME}/war; tar -xvf ${WORKING_DIR}/${TAR}_${VERSION}.tar ${APP}.war"

delay_continue &
executeCommandNoFailNoPrint "${APPSERVER_HOME}/bin/tcruntime-ctl.sh start"

exit
