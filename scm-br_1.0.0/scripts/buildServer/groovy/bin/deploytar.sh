#!/bin/ksh


##############
# Execute a command and exit on failure.
##############
executeCommand() {

    if [ ${VERBOSE} -eq 1 ] ; then
        print Executing : $1
    fi

    RESULT=`eval "$1"`

    if [ ${VERBOSE} -eq 1 ] ; then
        print Result : $RESULT
    fi

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

#############
# Usage message
#############
usage() {
    cat << EOF
usage: $0 options

This script deploys an application to a specified environment.

OPTIONS:
  -h   Show this message
  -a   Required. Application name. (ex. dai-)
  -t   Required. Tar filename
  -e   Required. Environment to which the application will be deployed. Currently the IP of the app server.
  -c   Optional.  CM Schema name
  -r   Required. Application version. ex. 2.0.0_2
  -j   Required. jdbc URL. ex. jdbc:oracle:thin:@10.13.18.68:1522:dev002
  -p   Required. Database password
  -u   Required. Database user
  -v   Verbose
  -m   Required for MicroDev. MSDSN project target
EOF
}

######################################################################
#                       Main script
######################################################################

export VERBOSE=0

# Function return value
FUNC_RV=""

while getopts "ha:t:o:e:r:j:m:p:u:b:c:v" OPTION
do
    case $OPTION in
      a)
        APP="ScrumSysGen"
        ;;
      t)
        TAR=${OPTARG}
        ;;
      e)
        APPSERVER_IP=${OPTARG}
#       TARGENV=${OPTARG}
#       if [[ $OPTARG = "devint" ]]; then
#           APPSERVER_IP=10.13.18.113
#           JDBC_URL=jdbc:oracle:thin:@10.13.18.111:1522:dev003
#           export DB_USER=DI_${DB_USER}
#           export DB_PASS=DI_${DB_PASS}
#       elif [[ $OPTARG = "scrum1" ]]; then
#           APPSERVER_IP=10.13.18.115
#           JDBC_URL=jdbc:oracle:thin:@10.13.18.119:1522:scrum001
#           export DB_USER=SC1_${DB_USER}
#           export DB_PASS=SC1_${DB_PASS}
#       elif [[ $OPTARG = "scrum2" ]]; then
#           APPSERVER_IP=10.13.18.116
#           JDBC_URL=jdbc:oracle:thin:@10.13.18.120:1522:scrum002
#           export DB_USER=SC2_${DB_USER}
#           export DB_PASS=SC2_${DB_PASS}
#       elif [[ $OPTARG = "scrum3" ]]; then
#           APPSERVER_IP=10.13.18.117
#           JDBC_URL=jdbc:oracle:thin:@10.13.18.121:1522:scrum003
#           export DB_USER=SC3_${DB_USER}
#           export DB_PASS=SC3_${DB_PASS}
#       else
#           APPSERVER_IP=${OPTARG}
#           JDBC_URL=""
#           TARGENV=""
#       fi
        ;;
      h)
        usage
        exit 1
        ;;
      r)
        VERSION=${OPTARG}
        ;;
      j)
        JDBC_URL=${OPTARG}
        ;;
      p)
        DB_PASS=${OPTARG}
        ;;
      u)
        DB_USER=${OPTARG}
        ;;
      c)
        CAMPAIGN_SCHEMA_NAME=${OPTARG}
        ;;
      b)
        BAR_SCHEMA_NAME=${OPTARG}
        ;;
      o)
        BILLING_SCHEMA_NAME=${OPTARG}
        ;;
      v)
        VERBOSE=1
        ;;
      m)
        MSDSN=${OPTARG}
        ;;
      ?)
        usage
        exit
        ;;
    esac
done

# Ensure required parameters are entered
if [ -z ${APP} -o -z ${TAR} -o -z ${APPSERVER_IP} -o -z ${VERSION} ] ; then
    usage
    exit 1
fi

case $APP in
  ScrumSysGen)
	export DESTBASE="/opt/tcserver/"
#	export WORKING_DIR="/tmp/deploymentWorkArea/ScrumSysGen/"
        export WORKING_DIR=${WORKING_DIR-"/tmp/deploymentWorkArea/${TAR}/${VERSION}"}
	export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
	export TARCPCMD="\"curl http://10.13.18.168/releaseTars/ScrumSysGen/ScrumSysGen_${VERSION}.tar > ScrumSysGen_${VERSION}.tar\""
	export JARCLNCMD="rm \-fR ${WORKING_DIR}"
	export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:/tmp/"
	export CP_BIN_DIR="${APPSERVER_IP}:/tmp"	
	export SSH_BASE="ssh tcserver@${APPSERVER_IP}"	
        export APPSERVER_BASE=${APPSERVER_BASE-/tmp}
        export APPSERVER_BIN="${APPSERVER_BASE}"
	executeCommand "scp retrieveApplicationArchive.sh ${CP_BIN_DIR}"
	executeCommand "${SSH_BASE} \"/tmp/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"\"
        executeCommand "${SSH_BASE} \"cd; tar xvf ${WORKING_DIR}/ScrumSysGen_1.0.0_3.tar"\"
	#executeCommand "${SSH_BASE} ${JARCLNCMD}"
	;;
esac

exit 0
