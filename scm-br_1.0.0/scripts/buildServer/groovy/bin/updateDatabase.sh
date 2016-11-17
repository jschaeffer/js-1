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

################
# Upgrades the database to the requested version
################
upgradeDatabase() {
    echo "Upgrade database"
    cd ${WORKING_DIR}/liquibase
    pwd
    echo "${LIQUIBASE_BASE_CMD} update ${LiqBaOPTS}"
    echo "${LIQUIBASE_BASE_CMD} tag ${VERSION}"
executeCommand "${LIQUIBASE_BASE_CMD} update ${LiqBaOPTS} && ${LIQUIBASE_BASE_CMD} tag ${VERSION}"
    cd -
}

#############
# Usage message
#############
usage() {
    cat << EOF
usage: $0 options

This script upgrades the specified database to the specified version.

OPTIONS:
  -a   Required. Application name. ex. oss_bar
  -e   Required. Environment to which the application will be deployed. Currently the IP of the app server.
  -h   Show this message
  -i   Required. App instance name
  -j   Required. jdbc URL. ex. jdbc:oracle:thin:@10.13.18.68:1522:dev002
  -p   Required. Database password
  -r   Required. The release version. Used to tag the update for rollback purposes.
  -u   Required. Database user
  -v   Verbose
EOF
}

######################################################################
#                       Main script
######################################################################

VERBOSE=${VERBOSE-0}
WORKING_DIR=${WORKING_DIR-"/tmp/deploymentWorkArea/${TAR}/${VERSION}"}
RESULT=""

while getopts "a:c:e:t:i:h:v:j:p:r:u:" OPTION
do
    case $OPTION in
      a)
        APP=${OPTARG}
        ;;
      c)
        if [[ $APP = "nCisClient" ]]; then
            export LiqBaOPTS="-DCAAS_SCHEMA_NAME=${OPTARG}"
        elif [[ $APP = "smsi-relay-client" ]]; then
            export LiqBaOPTS="-DCAMPAIGN_SCHEMA_NAME=${OPTARG}"
        else
	    LiqBaOPTS=""
        fi
        echo "LiqBaOPTS=$LiqBaOPTS  - APP=$APP"
        ;;
      e)
        APPSERVER_IP=${OPTARG}
        ;;
      i)
        INSTANCE=${OPTARG}
        ;;
      t)
        TAR=${OPTARG}
        ;;
      h)
        usage
        exit 1
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
if [ -z ${JDBC_URL} -o -z ${DB_PASS} -o -z ${DB_USER} -o -z ${VERSION} -o -z ${APP} -o -z ${APPSERVER_IP} -o -z ${INSTANCE} ] ; then
    usage
    exit 1
fi


export APPSERVER_BASE="/opt/tcserver/instances/${INSTANCE}"
export APPSERVER_BIN="${APPSERVER_BASE}/bin"
export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:${APPSERVER_BIN}/."

#executeCommandNoFail "rm *changelog*"
#executeCommand "cp -r ${WORKING_DIR}/*changelog* ."
executeCommand "cp liquibase.jar ${WORKING_DIR}/liquibase"
executeCommand "cp ojdbc6.jar ${WORKING_DIR}/liquibase"
executeCommand "cp derby*.jar ${WORKING_DIR}/liquibase"

LIQUIBASE_BASE_CMD="java -jar liquibase.jar --logLevel=info --driver=oracle.jdbc.driver.OracleDriver"
LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --changeLogFile=master-changelog.xml"
LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=\"${JDBC_URL}\""
#LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --username=${DB_USER} --password=${DB_PASS} --classpath=./ojdbc6.jar:derby.jar:derbyclient.jar"
LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --username=${DB_USER} --password=${DB_PASS} --classpath=./ojdbc6.jar"

LIQUIBASE_DIFF_CMD="java -jar liquibase.jar --logLevel=info --driver=oracle.jdbc.driver.OracleDriver"
LIQUIBASE_DIFF_CMD="${LIQUIBASE_DIFF_CMD} --changeLogFile=master-changelog.xml"
LIQUIBASE_DIFF_CMD="${LIQUIBASE_DIFF_CMD} --url=\"${JDBC_URL}\""
LIQUIBASE_DIFF_CMD="${LIQUIBASE_DIFF_CMD} --username=${DB_USER} --password=${DB_PASS} --classpath=./ojdbc6.jar:derby.jar:derbyclient.jar"

DEPLOYED_VERSION=$RESULT
### Call function 'upgradeDatabase' ###
upgradeDatabase
executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/retrieveApplicationArchive.sh"
#executeCommand "rm -fR ${WORKING_DIR}"
