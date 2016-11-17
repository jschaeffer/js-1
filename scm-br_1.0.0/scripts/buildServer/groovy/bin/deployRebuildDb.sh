#!/bin/ksh 


##############
# Execute a command and exit on failure.
##############
executeCommand() {
    
    if [ ${VERBOSE} -eq 1 ] ; then
        print Executing : $1
    fi
    
    FUNC_RV=eval $1
    
    if [ $? -ne 0 ] ; then
        print ERROR: Error executing $1
        exit 1
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
  -t   Required.  Tar filename
  -e   Required. Environment to which the application will be deployed. Currently the IP of the app server.
  -i   Required. App server instance name
  -j   Required. jdbc URL. ex. jdbc:oracle:thin:@10.13.18.68:1522:dev002
  -p   Required. Database password
  -r   Required. Application version. ex. 2.0.0_2
  -u   Required. Database user
  -v   Verbose
EOF
}

######################################################################
#                       Main script
######################################################################

export VERBOSE=0

# Function return value
FUNC_RV=""

while getopts "ha:t:e:i:s:j:p:r:u:v" OPTION
do
    case $OPTION in
      a)
        APP=${OPTARG}
        ;;
      t)
        TAR=${OPTARG}
        ;;
      e)
        TARGENV=${OPTARG}
        if [[ $OPTARG = "devint" ]]; then
            APPSERVER_IP=10.13.18.113
        elif [[ $OPTARG = "scrum1" ]]; then
            APPSERVER_IP=10.13.18.115
        elif [[ $OPTARG = "scrum2" ]]; then
            APPSERVER_IP=10.13.18.116
        elif [[ $OPTARG = "scrum3" ]]; then
            APPSERVER_IP=10.13.18.117
        elif [[ $OPTARG = "scrum4" ]]; then
            APPSERVER_IP=10.13.18.122
        elif [[ $OPTARG = "Marley" ]]; then
            APPSERVER_IP=10.13.18.118
        elif [[ $OPTARG = "RH65" ]]; then
            APPSERVER_IP=10.13.18.19
        else
            APPSERVER_IP=${OPTARG}
            TARGENV=""
        fi
        ;;
      i)
        INSTANCE=${OPTARG}
        ;;
      h)
        usage
        exit 1
        ;;
      s)
        CISYS=${OPTARG}
        ;;
      j)
        JDBC_URL=${OPTARG}
        ;;
      p)
        DB_PASS=${OPTARG}
        ;;
      r)
        VERSION=${OPTARG}
        ;;
      u)
        DB_USER=${OPTARG}
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
if [ -z ${APP} -o -z ${TAR} -o -z ${APPSERVER_IP} -o -z ${INSTANCE} -o -z ${VERSION} -o -z ${JDBC_URL} -o -z ${DB_PASS} -o -z ${DB_USER} ] ; then
    usage
    exit 1
fi

# Application server related variables.
export APPSERVER_BASE="/opt/tcserver/instances/${INSTANCE}"
export APPSERVER_BIN="${APPSERVER_BASE}/bin"
export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:${APPSERVER_BIN}/."

export WORKING_DIR="/tmp/deploymentWorkArea/${APP}/${VERSION}"

executeCommand "./retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"

# Retrieve the application deployment archive.

# copy scripts to remote application server.
executeCommand "scp stop.sh ${SSH_CP_BIN_DIR}"

# Stop the application server
executeCommand "${SSH_BASE} ${APPSERVER_BIN}/stop.sh -a ${INSTANCE}"

# Apply database changes.
executeCommand "./dropDb.sh -a ${APP} -t ${TAR} -i ${INSTANCE} -r ${VERSION} -e ${TARGENV} -j ${JDBC_URL} -p ${DB_PASS} -u ${DB_USER}"
executeCommand "echo ${APPSERVER_BIN}/tcruntime-ctl.sh"
executeCommand "${SSH_BASE} ${APPSERVER_BIN}/tcruntime-ctl.sh start"

exit 0
