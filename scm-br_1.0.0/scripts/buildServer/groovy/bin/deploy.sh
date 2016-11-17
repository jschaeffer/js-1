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
  -t   Required.  Tarfile name
  -e   Required. Environment to which the application will be deployed. Currently the IP of the app server.
  -i   Required. Instance name for app
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

while getopts "ha:e:r:v" OPTION
do
    case $OPTION in
      a)
        TARGAPP=${OPTARG}
        if [[ $OPTARG = "dai-billing" ]]; then
	    APP=${OPTARG}
            DB_PASS=BILLING
            DB_USER=BILLING
	    INSTANCE=billing
	    TAR=dai-billing
        elif [[ $OPTARG = "oss_bar" ]]; then
            APP=${OPTARG}
            DB_PASS=OSS_BAR
            DB_USER=OSS_BAR
	    INSTANCE=oss_bar
	    TAR=oss_bar
        elif [[ $OPTARG = "smsi-publisher" ]]; then
            APP=${OPTARG}
            DB_PASS=SMSIPUB
            DB_USER=SMSIPUB
            INSTANCE=smsipub
            TAR=smsi-publisher
       elif [[ $OPTARG = "ops-dce-metadata-agent" ]]; then
           APP=${OPTARG}
           DB_PASS=DCE_MDATA
           DB_USER=DCE_MDATA
           INSTANCE=dce-mdata
           TAR=ops-dce-metadata-agent
       elif [[ $OPTARG = "dai_amm" ]]; then
           APP=${OPTARG}
           DB_PASS=AMM
           DB_USER=AMM
           INSTANCE=dai_amm
           TAR=dai_amm
       elif [[ $OPTARG = "dai-national-cis" ]]; then
           APP="nCisClient"
           DB_PASS=NCIS
           DB_USER=NCIS
           INSTANCE=dai-national-cis
           TAR=dai-national-cis
           CAAS_SCHEMA_NAME=CAAS
       elif [[ $OPTARG = "dai-smsi-relay" ]]; then
           APP="smsi-relay-client"
           DB_PASS=RELAY
           DB_USER=RELAY
           INSTANCE=dai-smsi-relay
           TAR=dai-smsi-relay
           CAAS_SCHEMA_NAME=CAAS
        elif [[ $OPTARG = "dai-dce" ]]; then
            APP="dai-dce-server"
            DB_PASS=DCE
            DB_USER=DCE
            INSTANCE=dai-dce
            TAR=dai-dce
        elif [[ $OPTARG = "ad-load-manager" ]]; then
            APP="alm-server"
            DB_PASS=ALM
            DB_USER=ALM
            INSTANCE=ad-load-manager
            TAR=ad-load-manager
        elif [[ $OPTARG = "Pgmr-Cpgn-Int" ]]; then
            APP="pci"
            DB_PASS=PCI
            DB_USER=PCI
            INSTANCE=Pgmr-Cpgn-Int
            TAR=Pgmr-Cpgn-Int
        elif [[ $OPTARG = "smsi_data_collector" ]]; then
            APP="dai-sdc-server"
            DB_PASS=SDC
            DB_USER=SDC
            INSTANCE=smsi_data_collector
            TAR=smsi_data_collector
        else
	    APP=${OPTARG}
            DB_PASS=""
            DB_USER=""
            INSTANCE=""
	    TAR=""
        fi
        ;;
      e)
        TARGENV=${OPTARG}
        if [[ $OPTARG = "devint" ]]; then
            APPSERVER_IP=10.13.18.113
            JDBC_URL=jdbc:oracle:thin:@10.13.18.61:1522:scrum004
            export DB_USER=DI_${DB_USER}
            export DB_PASS=DI_${DB_PASS}
            export CAAS_SCHEMA_NAME=DI_${CAAS_SCHEMA_NAME}
        elif [[ $OPTARG = "scrum1" ]]; then
            APPSERVER_IP=10.13.18.115
            JDBC_URL=jdbc:oracle:thin:@10.13.18.61:1522:scrum004
            export DB_USER=SC1_${DB_USER}
            export DB_PASS=SC1_${DB_PASS}
            export CAAS_SCHEMA_NAME=SC1_${CAAS_SCHEMA_NAME}
        elif [[ $OPTARG = "scrum2" ]]; then
            APPSERVER_IP=10.13.18.116
            JDBC_URL=jdbc:oracle:thin:@10.13.18.61:1522:scrum004
            export DB_USER=SC2_${DB_USER}
            export DB_PASS=SC2_${DB_PASS}
            export CAAS_SCHEMA_NAME=SC2_${CAAS_SCHEMA_NAME}
        elif [[ $OPTARG = "scrum3" ]]; then
            APPSERVER_IP=10.13.18.117
            JDBC_URL=jdbc:oracle:thin:@10.13.18.61:1522:scrum004
            export DB_USER=SC3_${DB_USER}
            export DB_PASS=SC3_${DB_PASS}
            export CAAS_SCHEMA_NAME=SC3_${CAAS_SCHEMA_NAME}
        elif [[ $OPTARG = "scrum4" ]]; then
            APPSERVER_IP=10.13.18.122
            JDBC_URL=jdbc:oracle:thin:@10.13.18.61:1522:scrum004
            export DB_USER=SC4_${DB_USER}
            export DB_PASS=SC4_${DB_PASS}
            export CAAS_SCHEMA_NAME=SC4_${CAAS_SCHEMA_NAME}
        elif [[ $OPTARG = "Marley" ]]; then
            APPSERVER_IP=10.13.18.118
            JDBC_URL=jdbc:oracle:thin:@10.13.18.61:1522:scrum004
            export DB_USER=MAR_${DB_USER}
            export DB_PASS=MAR_${DB_PASS}
            export CAAS_SCHEMA_NAME=MAR_${CAAS_SCHEMA_NAME}
        elif [[ $OPTARG = "RH65" ]]; then
            APPSERVER_IP=10.13.18.19
            JDBC_URL=jdbc:oracle:thin:@10.13.18.61:1522:scrum004
            export DB_USER=RH65_${DB_USER}
            export DB_PASS=RH65_${DB_PASS}
            export CAAS_SCHEMA_NAME=RH65_${CAAS_SCHEMA_NAME}
        else
            APPSERVER_IP=${OPTARG}
            JDBC_URL=""
            TARGENV=""
        fi
        ;;
      h)
        usage
        exit 1
        ;;
      r)
        VERSION=${OPTARG}
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

export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"

executeCommand "./retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"

# Retrieve the application deployment archive.

# copy scripts to remote application server.
executeCommand "scp stop.sh ${SSH_CP_BIN_DIR}"

# Stop the application server
executeCommand "${SSH_BASE} ${APPSERVER_BIN}/stop.sh -a ${INSTANCE}"

# Apply database changes.
executeCommand "./updateDatabase.sh -a ${APP} -t ${TAR} -e ${APPSERVER_IP} -c ${CAAS_SCHEMA_NAME} -i ${INSTANCE} -r ${VERSION} -j ${JDBC_URL} -p ${DB_PASS} -u ${DB_USER}"

if [[ $APP = "smsi-relay-client" ]]; then
   executeCommand "./updateDatabase.sh -a ${APP} -t ${TAR} -e ${APPSERVER_IP} -c ${CAAS_SCHEMA_NAME} -i ${INSTANCE} -r ${VERSION} -j ${JDBC_URL} -p ${DB_PASS}1 -u ${DB_USER}1"
fi

# Deploy the war to the app server.
executeCommand "scp deployWar.sh ${SSH_CP_BIN_DIR}"
executeCommand "scp retrieveApplicationArchive.sh ${SSH_CP_BIN_DIR}"
executeCommand "${SSH_BASE} ${APPSERVER_BIN}/deployWar.sh -a ${APP} -t ${TAR} -r ${VERSION} -i ${INSTANCE} -s ${TARGENV}"

# clean up
executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/stop.sh"
executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/deployWar.sh"
executeCommand "rm -fR ${WORKING_DIR}"

exit 0
