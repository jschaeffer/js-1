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

while getopts "ha:t:o:e:i:s:j:p:r:u:b:c:v" OPTION
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
        if [[ $OPTARG = "MicroDev" ]]; then
            APPSERVER_IP=10.13.18.61
        else
            APPSERVER_IP=10.13.18.61
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
      c)
        CAMPAIGN_SCHEMA_NAME=${OPTARG}
        ;;
      b)
        BAR_SCHEMA_NAME=${OPTARG}
        ;;
      o)
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

# Apply database changes.

case $APP in
    oss_bar)
	executeCommand "./dropDb.sh -a ${APP} -t ${TAR} -i ${INSTANCE} -r ${VERSION} -e ${TARGENV} -j ${JDBC_URL} -p ${DB_PASS} -u ${DB_USER}"
        ;;
    caas-core)
        executeCommand "./dropDb.sh -a ${APP} -t ${TAR} -i ${INSTANCE} -r ${VERSION} -e ${TARGENV} -j ${JDBC_URL} -p ${DB_PASS} -u ${DB_USER}"
        ;;
    ops-dt)
        executeCommand "./dropDb.sh -a ${APP} -t ${TAR} -i ${INSTANCE} -r ${VERSION} -e ${TARGENV} -j ${JDBC_URL} -p ${DB_PASS} -u ${DB_USER}"
        ;;
    dai-etl-feeder)
        export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
        DEPLOYED_VERSION=`/opt/build/scripts/check_dbversions.sh -a dai-etl-feeder -e devint`
#        export DEPLOYED_VERSION=`ssh tcserver@dvappdai01 "cd /opt/tcserver/dai_etl_feeder; jar xf dai-etl-feeder-3.0.0-SNAPSHOT.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
        echo "--------------------------------------------------"
        echo "Existing deployed version: $DEPLOYED_VERSION"

        ################
        # Upgrades the database to the requested version
        ################
        rebuildDatabase() {
         LIQUIBASE_BASE_CMD="java -jar liquibase.jar --logLevel=info --driver=oracle.jdbc.driver.OracleDriver"
	 echo "${LIQUIBASE_BASE_CMD}"
         LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=\"${JDBC_URL}\""
         echo "${LIQUIBASE_BASE_CMD}"
         LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --username=${DB_USER} --password=${DB_PASS} --classpath=./ojdbc6.jar"
         echo "${LIQUIBASE_BASE_CMD}"
         LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --changeLogFile=./master-changelog.xml"
         echo "${LIQUIBASE_BASE_CMD}"
         echo "Rebuild database"
         cd ${WORKING_DIR}/liquibase
         echo "Working Dir"
         pwd
         echo "${LIQUIBASE_BASE_CMD} releaseLocks"
         echo "${LIQUIBASE_BASE_CMD} update -DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME} -DBAR_SCHEMA_NAME=${BAR_SCHEMA_NAME} -DREPORTING_SCHEMA_NAME=${REPORTING_SCHEMA_NAME}"
         echo "${LIQUIBASE_BASE_CMD} tag ${VERSION}"
         executeCommand "${LIQUIBASE_BASE_CMD} releaseLocks"
         executeCommand "${LIQUIBASE_BASE_CMD} update -DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME} -DBAR_SCHEMA_NAME=${BAR_SCHEMA_NAME} -DREPORTING_SCHEMA_NAME=${REPORTING_SCHEMA_NAME}"
         executeCommand "${LIQUIBASE_BASE_CMD} tag ${VERSION}"
        }
        rebuildUser() {
         LIQUIBASE_BASE_CMD="java -jar ../liquibase.jar --logLevel=info --driver=oracle.jdbc.driver.OracleDriver"
         LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=\"${JDBC_URL}\""
         LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --username=cm_system --password=oracle123 --classpath=../ojdbc6.jar"
         LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --changeLogFile=genUser.${TARGENV}.sql"
         echo "Rebuild User"
         cd ${WORKING_DIR}/liquibase/cisys
         cd -
         unset LIQUIBASE_BASE_CMD
        }

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
#        executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/getApplicationVersion.sh"
#        executeCommand "rm -fR ${WORKING_DIR}"
#        executeCommand "${SSH_BASE} ${JARCLNCMD1}"
        ;;
esac

exit 0 

