#!/bin/ksh -xe


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
  -a   Required. Application name. ex. cip-server.war
  -t   Required. Tar file name.  ex. dai-cip-feedback.tar
  -e   Required. Environment to which the application will be deployed. Currently the IP of the app server.
  -r   Required. Application version. ex. 2.0.0_2
  -i   Required. Instance name (in case it's different than the repository name
  -v   Verbose
EOF
}

######################################################################
#                       Main script
######################################################################

export VERBOSE=0

# Function return value
FUNC_RV=""

while getopts "ha:t:e:r:i:v" OPTION
do
    case $OPTION in
      a)
        APP=${OPTARG}
        ;;
      t)
        TAR=${OPTARG}
        ;;
      r)
        VERSION=${OPTARG}
        ;;
      i)
        INSTANCE=${OPTARG}
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
      v)
        VERBOSE=1
        ;;
      h)
        usage
        echo "OPTARG = ${OPTARG}"
        exit 1
        ;;
      ?)
        usage
        exit
        ;;
    esac
done
# Ensure required parameters are entered

if [ -z ${APP} -o -z ${TAR} -o -z ${APPSERVER_IP} -o -z ${VERSION} -o -z ${INSTANCE} ] ; then
    usage
    exit 1
fi

# Application server related variables.
export APPSERVER_BASE="/opt/tcserver/instances/${INSTANCE}" 
export APPSERVER_BIN="${APPSERVER_BASE}/bin"
export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:${APPSERVER_BIN}/."

export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
#echo "TAR = ${TAR} APPSERVER_BASE = ${APPSERVER_BASE}  SSH_CP_BIN_DIR = ${SSH_CP_BIN_DIR}"
#echo "APPSERVER_IP=${APPSERVER_IP}  TARGENV=${TARGENV}"

executeCommand "./retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"

# Retrieve the application deployment archive.

# copy scripts to remote application server.
executeCommand "scp stop.sh ${SSH_CP_BIN_DIR}"

# Stop the application server
executeCommand "${SSH_BASE} ${APPSERVER_BIN}/stop.sh -a ${INSTANCE}"

# Deploy the war to the app server.
executeCommand "scp deployWar.sh ${SSH_CP_BIN_DIR}"
executeCommand "scp retrieveApplicationArchive.sh ${SSH_CP_BIN_DIR}"
executeCommand "${SSH_BASE} ${APPSERVER_BIN}/deployWar.sh -a ${APP} -t ${TAR} -r ${VERSION} -i ${INSTANCE} -s ${TARGENV}"

# clean up
executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/stop.sh"
#executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/deployWar.sh"
executeCommand "rm -fR ${WORKING_DIR}"

exit 0
