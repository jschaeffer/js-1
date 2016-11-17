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

while getopts "ha:t:e:r:d:j:w:p:u:c:v" OPTION
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
        APPSERVER_IP=${OPTARG}
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
      d)
        purpose=${OPTARG}
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
  dai-etl-feeder)
#	export WORKING_DIR="/tmp/deploymentWorkArea/dai-etl-feeder/dai-etl-feeder-4.0.0_164/src/main/resources"
	export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
	executeCommand "./retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"
        export DESTBASE="/opt/tcserver/dai_etl_feeder"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
        export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:/tmp/"
        export CP_BIN_DIR="${APPSERVER_IP}:/tmp"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
        export APPSERVER_BASE=${APPSERVER_BASE-/tmp}
        export APPSERVER_BIN="${APPSERVER_BASE}"
        DEPLOYED_VERSION=`/opt/build/scripts/lab2lab/check_dbversions_lab2lab_${purpose}.sh -a dai-etl-feeder -e lab2lab`
	echo "--------------------------------------------------"
	echo "Existing deployed version: $DEPLOYED_VERSION"

	################
	# Upgrades the database to the requested version
	################
	rebuildDatabase() {
         LIQUIBASE_BASE_CMD="java -jar liquibase.jar --logLevel=info --driver=oracle.jdbc.driver.OracleDriver"
         LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=\"${JDBC_URL}\""
         LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --username=${DB_USER} --password=${DB_PASS} --classpath=./ojdbc6.jar"
         LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --changeLogFile=./master-changelog.xml"
         echo "Running Liquibase"
         cd ${WORKING_DIR}/liquibase
	 echo "Working Dir"
	 pwd
	 echo "${LIQUIBASE_BASE_CMD} releaseLocks"
	 echo "${LIQUIBASE_BASE_CMD} update -DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME} -DREPORTING_SCHEMA_NAME=${REPORTING_SCHEMA_NAME}"
	 echo "${LIQUIBASE_BASE_CMD} tag ${VERSION}"
	 executeCommand "${LIQUIBASE_BASE_CMD} releaseLocks"
	 executeCommand "${LIQUIBASE_BASE_CMD} update -DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME} -DREPORTING_SCHEMA_NAME=${REPORTING_SCHEMA_NAME} && ${LIQUIBASE_BASE_CMD} tag ${VERSION}"
	}
   
#        export WORKING_DIR="/tmp/deploymentWorkArea/dai-etl-feeder/dai-etl-feeder-4.0.0_164/src/main/resources"
        export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
	executeCommand "cp liquibase.jar ${WORKING_DIR}/liquibase"
	executeCommand "cp ojdbc6.jar ${WORKING_DIR}/liquibase"

	RESULT="1"

	case "$RESULT" in
	  "1")
	   rebuildDatabase
	  ;;
	  *)
	   echo "Error in Result"
	esac
	executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/getApplicationVersion.sh"
	executeCommand "rm -fR ${WORKING_DIR}"
        ;;
   smsi_reporting)
        export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
        executeCommand "./retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${Version}"
        export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:/tmp/"
        export CP_BIN_DIR="${APPSERVER_IP}:/tmp"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
        export APPSERVER_BASE=${APPSERVER_BASE-/tmp}
        export APPSERVER_BIN="${APPSERVER_BASE}"
        # DEPLOYED_VERSION=`/opt/build/scripts/lab2lab/check_dbversions_lab2lab_${purpose}.sh -a dai-etl-feeder -e lab2lab`
        echo "--------------------------------------------------"
        echo "Existing deployed version: $DEPLOYED_VERSION"

        ################
        # Upgrades the database to the requested version
        ################
        smsi_rpt_liquibase() {
         LIQUIBASE_BASE_CMD="java -jar liquibase.jar --logLevel=info --driver=oracle.jdbc.driver.OracleDriver"
         LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=\"${JDBC_URL}\""
         LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --username=${DB_USER} --password=${DB_PASS} --classpath=./ojdbc6.jar"
         LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --changeLogFile=./master-changelog.xml"
         echo "Running Liquibase"
         cd ${WORKING_DIR}/liquibase
         echo "Working Dir"
         pwd
         echo "${LIQUIBASE_BASE_CMD} releaseLocks"
         echo "${LIQUIBASE_BASE_CMD} update -DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME} -DINGEST_SCHEMA_NAME=${REPORTING_SCHEMA_NAME}"
         echo "${LIQUIBASE_BASE_CMD} tag ${VERSION}"
         executeCommand "${LIQUIBASE_BASE_CMD} releaseLocks"
         executeCommand "${LIQUIBASE_BASE_CMD} update -DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME} -DINGEST_SCHEMA_NAME=${REPORTING_SCHEMA_NAME} && ${LIQUIBASE_BASE_CMD} tag ${Version}"
        }

        export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
        executeCommand "cp liquibase.jar ${WORKING_DIR}/liquibase"
        executeCommand "cp ojdbc6.jar ${WORKING_DIR}/liquibase"
        smsi_rpt_liquibase

        executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/getApplicationVersion.sh"
        executeCommand "rm -fR ${WORKING_DIR}"
        ;;
esac

exit 0
