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
# Updates database from liquibase scripts and tags with version id
################
updateDatabase() {
    LIQUIBASE_BASE_CMD="java -jar liquibase.jar --logLevel=info --driver=oracle.jdbc.driver.OracleDriver"
    LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=\"${JDBC_URL}\""
    LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --username=${DB_USER} --password=${DB_PASS} --classpath=./ojdbc6.jar:./liquibase-oracle-1.2.0.jar"
    LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --changeLogFile=master-changelog.xml"
    if [[ $APP = "caas-core" ]]; then
       LIQUIBASE_BASE_UPD_CMD="${LIQUIBASE_BASE_CMD} update -DADS_SCHEMA_NAME=${ADS_DB_USER}"
    elif [[ $APP = "ads-core" ]]; then
       LIQUIBASE_BASE_UPD_CMD="${LIQUIBASE_BASE_CMD} update -DCAAS_SCHEMA_NAME=${CAAS_DB_USER} ${LiqBaOPTS}"
    else
       LIQUIBASE_BASE_UPD_CMD="${LIQUIBASE_BASE_CMD} update ${LiqBaOPTS}" 
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

# Section to Execute actual DB changes.  Comment/uncomment to verify commands through echos
    executeCommand "${LIQUIBASE_BASE_CMD} releaseLocks"
    executeCommand "${LIQUIBASE_BASE_UPD_CMD} && ${LIQUIBASE_BASE_CMD} tag ${VERSION}"
#    executeCommand "${LIQUIBASE_BASE_CMD} tag ${VERSION}"
    cd -
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
WORKING_DIR=${WORKING_DIR-"/tmp/deploymentWorkArea/${TAR}/${VERSION}"}
RESULT=""

while getopts "a:t:i:d:h:f:v:e:j:p:r:u:" OPTION
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
      d)
        purpose=${OPTARG}
        ;;
      j)
        JDBC_URL=${OPTARG}
        ;;
      f)
        ADSENV=${OPTARG}
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

executeCommand "cp liquibase.jar ${WORKING_DIR}/liquibase"
executeCommand "cp ojdbc6.jar ${WORKING_DIR}/liquibase"
executeCommand "cp liquibase-oracle-1.2.0.jar ${WORKING_DIR}/liquibase"
if [[ $APP = "caas-core" || $APP = "ads-core" ]]; then
        case $purpose in
         base)
          export CAAS_DB_USER="CAAS40"
          if [[ $DB_USER = "ADS_CORE_COM" ]]; then
            export LiqBaOPTS="-Denvironment=dev"
          else
            LiqBaOPTS="-Denvironment=prod"
          fi
         ;;
          fw)
          export CAAS_DB_USER="CAAS_CORE_FW"
          export LiqBaOPTS="-Denvironment=prod"
         ;;
          kodiak)
          export CAAS_DB_USER="CAAS_LOCAL"
          export LiqBaOPTS="-Denvironment=prod"
         ;;
          broadway)
          export CAAS_DB_USER="CAAS_CORE_BRD"
          export LiqBaOPTS="-Denvironment=prod"
         ;;
        esac
fi
echo "Liquibase Options: ${LiqBaOPTS}"

updateDatabase 


executeCommandNoFail "rm *changelog*.*"
executeCommandNoFail "rm -fR version_changelogs"
executeCommandNoFail "rm -fR ${WORKING_DIR}"

