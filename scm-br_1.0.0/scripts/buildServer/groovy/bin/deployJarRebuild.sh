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
EOF
}

######################################################################
#                       Main script
######################################################################

export VERBOSE=0

# Function return value
FUNC_RV=""

while getopts "ha:t:d:e:r:o:j:p:u:w:b:c:v" OPTION
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
        export  APPSERVER_IP=10.13.18.113
        elif [[ $OPTARG = "scrum1" ]]; then
        export  APPSERVER_IP=10.13.18.115
        elif [[ $OPTARG = "scrum2" ]]; then
        export  APPSERVER_IP=10.13.18.116
        elif [[ $OPTARG = "scrum3" ]]; then
         export APPSERVER_IP=10.13.18.117
        elif [[ $OPTARG = "scrum4" ]]; then
         export APPSERVER_IP=10.13.18.122
        elif [[ $OPTARG = "Marley" ]]; then
         export APPSERVER_IP="10.13.18.118"
        else
            APPSERVER_IP=${OPTARG}
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
      d)
        ADS_SCHEMA_NAME=${OPTARG}
        ;;
      b)
        BAR_SCHEMA_NAME=${OPTARG}
        ;;
      o)
        BILLING_SCHEMA_NAME=${OPTARG}
        ;;
      w) 
        REPORTING_SCHEMA_NAME=${OPTARG}
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
if [ -z ${APP} -o -z ${TAR} -o -z ${APPSERVER_IP} -o -z ${VERSION} ] ; then
    usage
    exit 1
fi

case $APP in
  scte-feeder)
        cd /opt/build/scripts
        ################
        # Jar Section
        ################
        DEPLOYED_VERSION=`/opt/build/scripts/check_dbversions.sh -a scte-feeder -e devint`
        export DESTBASE="/opt/tcserver/scte-feeder"
        export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
        export JARCPCMD1="cp ${WORKING_DIR}/scte-feeder.jar ${DESTBASE}"
        export JARCPCMD2="cp ${WORKING_DIR}/etl-feeder.properties ${DESTBASE}"
        export JARCPCMD3="cp ${WORKING_DIR}/log4j-dev.xml ${DESTBASE}"
        export JARCPCMD4="cp ${WORKING_DIR}/connection-context.xml ${DESTBASE}"
        export JARCLNCMD="rm ${WORKING_DIR}/*.*"
        export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:/tmp/"
        export CP_BIN_DIR="${APPSERVER_IP}:/tmp"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
        export APPSERVER_BASE=${APPSERVER_BASE-/tmp}
        export APPSERVER_BIN="${APPSERVER_BASE}"
        executeCommand "scp retrieveApplicationArchive.sh ${SSH_CP_BIN_DIR}"
        executeCommand "${SSH_BASE} ${APPSERVER_BIN}/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"
        executeCommand "${SSH_BASE} ${JARCPCMD1}"
        executeCommand "${SSH_BASE} ${JARCPCMD2}"
        executeCommand "${SSH_BASE} ${JARCPCMD3}"
        executeCommand "${SSH_BASE} ${JARCPCMD4}"
        executeCommand "${SSH_BASE} ${JARCLNCMD}"
        ##################
        # Database Section
        ##################
        executeCommand "./retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"
        echo "Upgrade database"
        echo "--------------------------------------------------"
        executeCommand "cp liquibase.jar ${WORKING_DIR}/liquibase"
        executeCommand "cp ojdbc6.jar ${WORKING_DIR}/liquibase"
        cd ${WORKING_DIR}/liquibase

        LIQUIBASE_BASE_CMD="java -jar liquibase.jar --logLevel=info --driver=oracle.jdbc.driver.OracleDriver"
        LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --changeLogFile=./master-changelog.xml"
        LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=\"${JDBC_URL}\""
        LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --username=${DB_USER} --password=${DB_PASS} --classpath=./ojdbc6.jar"

        echo "${LIQUIBASE_BASE_CMD} update -DADS_SCHEMA_NAME=${ADS_SCHEMA_NAME}"
        executeCommand "${LIQUIBASE_BASE_CMD} update -DADS_SCHEMA_NAME=${ADS_SCHEMA_NAME} -DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME} -DBAR_SCHEMA_NAME=${BAR_SCHEMA_NAME}"
        executeCommand "${LIQUIBASE_BASE_CMD} tag ${VERSION}"
        executeCommand "${JARCLNCMD}"
        ;;
  dai-etl-feeder)
	export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
	executeCommand "./retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"
        export DESTBASE="/opt/tcserver/dai_etl_feeder"
#	executeCommand "tree ${WORKING_DIR}"
#	unset WORKING_DIR
#       export WORKING_DIR="/tmp/deploymentWorkArea"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
        export JARCPCMD="cp ${WORKING_DIR}/*dai-etl*.jar ${DESTBASE}/"
        export JARCLNCMD1="rm ${WORKING_DIR}/*etl* ${WORKING_DIR}/*log4j* ${WORKING_DIR}/README.md; cd ${WORKING_DIR}; rm -fR generated-sql; rm -fR liquibase; cd -"
        export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:/tmp/"
        export CP_BIN_DIR="${APPSERVER_IP}:/tmp"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
        export APPSERVER_BASE=${APPSERVER_BASE-/tmp}
        export APPSERVER_BIN="${APPSERVER_BASE}"
        DEPLOYED_VERSION=`/opt/build/scripts/check_dbversions.sh -a dai-etl-feeder -e devint`
	echo "--------------------------------------------------"
	echo "Existing deployed version: $DEPLOYED_VERSION"
        executeCommand "scp retrieveApplicationArchive.sh ${SSH_CP_BIN_DIR}"
        executeCommand "${SSH_BASE} ${APPSERVER_BIN}/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"

	################
	# Upgrades the database to the requested version
	################
	rebuildDatabase() {
         LIQUIBASE_BASE_CMD="java -jar liquibase.jar --logLevel=info --driver=oracle.jdbc.driver.OracleDriver"
         LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=\"${JDBC_URL}\""
         LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --username=${DB_USER} --password=${DB_PASS} --classpath=./ojdbc6.jar"
         LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --changeLogFile=./master-changelog.xml"
	 echo "Rebuild database"
         cd ${WORKING_DIR}/liquibase
	 echo "Working Dir"
	 pwd
	 echo "${LIQUIBASE_BASE_CMD} releaseLocks"
	 echo "${LIQUIBASE_BASE_CMD} update -DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME} -DBAR_SCHEMA_NAME=${BAR_SCHEMA_NAME} -DBILLING_SCHEMA_NAME=${BILLING_SCHEMA_NAME} -DREPORTING_SCHEMA_NAME=${REPORTING_SCHEMA_NAME}"
	 echo "${LIQUIBASE_BASE_CMD} tag ${VERSION}"
	 executeCommand "${LIQUIBASE_BASE_CMD} releaseLocks"
	 executeCommand "${LIQUIBASE_BASE_CMD} update -DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME} -DBAR_SCHEMA_NAME=${BAR_SCHEMA_NAME} -DBILLING_SCHEMA_NAME=${BILLING_SCHEMA_NAME} -DREPORTING_SCHEMA_NAME=${REPORTING_SCHEMA_NAME} && ${LIQUIBASE_BASE_CMD} tag ${VERSION}"
	}
	rebuildUser() {
         LIQUIBASE_BASE_CMD="java -jar ../liquibase.jar --logLevel=info --driver=oracle.jdbc.driver.OracleDriver"
         LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=\"${JDBC_URL}\""
	 LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --username=cm_system --password=oracle123 --classpath=../ojdbc6.jar"
	 LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --changeLogFile=genUser.${TARGENV}.sql"
	 echo "Rebuild User"
	 cd ${WORKING_DIR}/liquibase/cisys
	 executeCommand "${LIQUIBASE_BASE_CMD} releaseLocks"
	 executeCommand "${LIQUIBASE_BASE_CMD} update"
	 cd -
	 unset LIQUIBASE_BASE_CMD
	}
   
        export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
	executeCommandNoFail "rm *changelog*"
	executeCommand "cp liquibase.jar ${WORKING_DIR}/liquibase"
	executeCommand "cp ojdbc6.jar ${WORKING_DIR}/liquibase"

rebuildDatabase
	executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/getApplicationVersion.sh"
	executeCommand "rm -fR ${WORKING_DIR}"
        executeCommand "${SSH_BASE} ${JARCLNCMD1}"
        ;;
esac

exit 0
