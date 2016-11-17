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
# Drops all database objects owned by the user to enable complete rebuild with tagging
################
rebuildDatabase() {
    LIQUIBASE_BASE_CMD="java -jar /opt/build/scripts/liquibase.jar --logLevel=info --driver=oracle.jdbc.driver.OracleDriver"
    LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=\"${JDBC_URL}\""
    LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --username=${DB_USER} --password=${DB_PASS} --classpath=/opt/build/scripts/ojdbc6.jar:/opt/build/scripts/liquibase-oracle-1.2.0.jar"
    LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --changeLogFile=master-changelog.xml"
    if [[ $APP = "caas-core" ]]; then
       LIQUIBASE_BASE_UPD_CMD="${LIQUIBASE_BASE_CMD} update"
# Mike's refactor removing the ADS schema name       LIQUIBASE_BASE_UPD_CMD="${LIQUIBASE_BASE_CMD} update -DADS_SCHEMA_NAME=${ADS_DB_USER}"
    elif [[ $APP = "ads-core" ]]; then
       LIQUIBASE_BASE_UPD_CMD="${LIQUIBASE_BASE_CMD} update -DCAAS_SCHEMA_NAME=${CAAS_DB_USER} -Denvironment=dev"
    else
       LIQUIBASE_BASE_UPD_CMD="${LIQUIBASE_BASE_CMD} update" 
    fi 
    echo "Updating database"
    echo "${LIQUIBASE_BASE_CMD} releaseLocks"
    echo "${LIQUIBASE_BASE_UPD_CMD}"
    echo "${LIQUIBASE_BASE_CMD} tag ${VERSION}"
    cd ${WORKING_DIR}/liquibase
    
##
# Section added to deliver Legacy ADS Core.  Have to create a symlink to the src files needed
##
#    mkdir -p  src/main/resources/liquibase/
#    cd src/main/resources/liquibase
#    ln -s ${WORKING_DIR}/liquibase/core-1.2.0-data core-1.2.0-data
#    ln -s ${WORKING_DIR}/liquibase/core-3.0.0-data core-3.0.0-data 
#    ln -s ${WORKING_DIR}/liquibase/core-4.0.0-data core-4.0.0-data
    cd ${WORKING_DIR}/liquibase
# End of Section
    executeCommand "${LIQUIBASE_BASE_CMD} releaseLocks"

    executeCommand "${LIQUIBASE_BASE_UPD_CMD} && ${LIQUIBASE_BASE_CMD} tag ${VERSION}"
    cd -
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

#############
# Usage message
#############
usage() {
    cat << EOF
usage: $0 options

This script rebuilds the specified database 

OPTIONS:
  -h   Show this message
  -t   Required. Tar filename
  -j   Required. jdbc URL. ex. jdbc:oracle:thin:@10.13.18.68:1522:dev002
  -a   Required. App name
  -r   Required. Version
  -p   Required. Database password
  -u   Required. Database user
  -v   Verbose
EOF
}

######################################################################
#                       Main script
######################################################################

VERBOSE=${VERBOSE-0}
#WORKING_DIR=${WORKING_DIR-"/tmp/deploymentWorkArea"}
WORKING_DIR=${WORKING_DIR-"/tmp/deploymentWorkArea/${TAR}/${VERSION}"}
RESULT=""

while getopts "a:t:i:h:v:e:j:p:r:u:" OPTION
do
    case $OPTION in
      a)
        APP=${OPTARG}
        ;;
      t)
        TAR=${OPTARG}
        ;;
      i)
        INSTANCE=${OPTARG}
        ;;
      h)
        usage
        exit 1
        ;;
      e)
        TARGENV=${OPTARG}
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
if [ -z ${JDBC_URL} -o -z ${TAR} -o -z ${DB_PASS} -o -z ${DB_USER} -o -z ${VERSION} -o -z ${APP} ] ; then
    usage
    exit 1
fi

#executeCommandNoFail "rm *changelog*"
#executeCommand "cp -r ${WORKING_DIR}/*changelog* ."
executeCommand "cp liquibase.jar ${WORKING_DIR}/liquibase"
executeCommand "cp ojdbc6.jar ${WORKING_DIR}/liquibase"
executeCommand "cp liquibase-oracle-1.2.0.jar ${WORKING_DIR}/liquibase"
if [[ $APP = "caas-core" || "ads-core" ]]; then
  case ${TARGENV} in
   devint)
#	ADS_DB_USER=DI_ADS
        CAAS_DB_USER=DI_CAAS
        ;;
   scrum1)
#        ADS_DB_USER=SC1_ADS
        CAAS_DB_USER=SC1_CAAS
        ;;
   scrum2)
#        ADS_DB_USER=SC2_ADS
        CAAS_DB_USER=SC2_CAAS
        ;;
   scrum3)
#        ADS_DB_USER=SC3_ADS
        CAAS_DB_USER=SC3_CAAS
        ;;
   MicroDev)
#        ADS_DB_USER=DI4_ADS
        CAAS_DB_USER=DI4_CAAS
        ;;
   Marley)
#        ADS_DB_USER=MAR_ADS
        CAAS_DB_USER=MAR_CAAS
        ;;
   scrum4)
#        ADS_DB_USER=SC4_ADS
        CAAS_DB_USER=SC4_CAAS
        ;;
   RH65)
#        ADS_DB_USER=RH65_ADS
        CAAS_DB_USER=RH65_CAAS
        ;;
  esac
fi

RESULT="1"

case "$RESULT" in
   "1")
     rebuildDatabase
     ;;
   *)
     echo "Error in Result"
esac

executeCommandNoFail "rm *changelog*.*"
executeCommandNoFail "rm -fR version_changelogs"
executeCommandNoFail "rm -fR ${WORKING_DIR}"
