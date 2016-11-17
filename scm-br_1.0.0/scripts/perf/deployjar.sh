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

while getopts "h:a:t:o:e:r:j:m:p:u:b:c:v" OPTION
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
       if [[ $APP = "dai-cip" ]]; then
           APPSERVER_IP=pfcipdai01
       elif [[ $APP = "acp" ]]; then
           APPSERVER_IP=pfcm01
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

export TARGENV
case $APP in
  dai-cip)
        export DESTBASE="/opt/tcserver/dai-cip_40"
        export WORKING_DIR="/var/tmp/deploymentWorkArea/${TAR}/${VERSION}"
#like this when lyam found it export WORKING_DIR="/var/tmp/deploymentWorkArea/${TAR}/${VERSION}"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
        export JARCPCMD="\"cp ${WORKING_DIR}/dai-cip.jar ${DESTBASE}/bin\""
        export JARCLNCMD="rm \-fR ${WORKING_DIR}"
        export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:/tmp/"
        export CP_BIN_DIR="${APPSERVER_IP}:/tmp"
        export APPSERVER_BASE=${APPSERVER_BASE-/tmp}
        export APPSERVER_BIN="${APPSERVER_BASE}"
        echo "Deploying DAI-CIP to Performance"
        executeCommand "scp retrieveApplicationArchive.sh ${SSH_CP_BIN_DIR}"
# Used in Scrums only     executeCommand "scp deploycip.sh ${SSH_CP_BIN_DIR}"
        executeCommand "${SSH_BASE} ${APPSERVER_BIN}/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"
# Used in Scrums only     executeCommand "${SSH_BASE} ${APPSERVER_BIN}/deploycip.sh -a ${APP} -t ${TAR} -r ${VERSION} -s ${TARGENV}"
        executeCommand "${SSH_BASE} ${JARCPCMD}"
# Used in Scrums only        executeCommand "${SSH_BASE} \"chmod +x ${DESTBASE}/launcher.sh\""
        #executeCommand "${SSH_BASE} ${JARCLNCMD}"
        ;;
  old_dai-cip)
	export DESTBASE="/opt/tcserver/dai-cip_40"
	export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
	export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
	export JARCPCMD="\"cp ${WORKING_DIR}/dai-cip-batch.jar ${DESTBASE}/cip-batch/; cp ${WORKING_DIR}/dai-cip-immediate.jar ${DESTBASE}/cip-immediate/\""
	export JARCLNCMD="rm \-fR ${WORKING_DIR}"
#	export JARCLNCMD="rm ${WORKING_DIR}/*cip-batch* ${WORKING_DIR}/*cip-immediate* ${WORKING_DIR}/dai-cip*.tar ${WORKING_DIR}/README.txt"
	export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:/tmp/"
	export CP_BIN_DIR="${APPSERVER_IP}:/tmp"	
	export SSH_BASE="ssh tcserver@${APPSERVER_IP}"	
        export APPSERVER_BASE=${APPSERVER_BASE-/tmp}
        export APPSERVER_BIN="${APPSERVER_BASE}"
        echo "Deploying DAI-CIP to Performance"
	executeCommand "scp retrieveApplicationArchive.sh ${SSH_CP_BIN_DIR}"
        echo "Retrieving the release package"
	executeCommand "${SSH_BASE} ${APPSERVER_BIN}/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION} -v"
        echo "Extracting and placing the cip-batch and cip-intermediate binaries"
	executeCommand "${SSH_BASE} ${JARCPCMD}"
        echo "Cleaning up the temporary deployment artifacts"
	executeCommand "${SSH_BASE} ${JARCLNCMD}"
	;;
  acp)
        export DESTBASE="/opt/tcserver/acp"
        export WORKING_DIR="/var/tmp/deploymentWorkArea/${TAR}/${VERSION}"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"

        export JARCPCMD="\"cp ${WORKING_DIR}/acp.jar ${DESTBASE}/bin/; cp ${WORKING_DIR}/config/launcher.sh ${DESTBASE}/launcher.sh\""
#        export JARCLNCMD="rm \-fR ${WORKING_DIR}"
        export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:/var/tmp/"
        export CP_BIN_DIR="${APPSERVER_IP}:/var/tmp"
        export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:/var/tmp/"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
        export APPSERVER_BASE=${APPSERVER_BASE-/var/tmp}
        export APPSERVER_BIN="${APPSERVER_BASE}"
        executeCommand "scp retrieveApplicationArchive.sh ${SSH_CP_BIN_DIR}"
        executeCommand "${SSH_BASE} ${APPSERVER_BIN}/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION} -v"
        executeCommand "${SSH_BASE} ${JARCPCMD}"
        echo "Replacing lib directory"
#        export CP_LIB_DIR="cd ${DESTBASE}/bin; rm -fR lib; tar -xvf ${WORKING_DIR}/${TAR}_${VERSION}.tar lib; ls -al lib\"
        executeCommand "${SSH_BASE} \"cd ${DESTBASE}/bin; rm -fR lib; tar -xvf ${WORKING_DIR}/${TAR}_${VERSION}.tar lib; ls -al lib\""
#        executeCommand "${SSH_BASE} ${JARCLNCMD}"
        ;;
  dai-lincoln)
        export DESTBASE="/opt/tcserver/log_splitter"
        export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
        export JARCPCMD="cp ${WORKING_DIR}/*lincoln*.jar ${DESTBASE};"
        export JARCLNCMD="rm ${WORKING_DIR}/*lincoln*"
        export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:/tmp/"
        export CP_BIN_DIR="${APPSERVER_IP}:/tmp"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
        export APPSERVER_BASE=${APPSERVER_BASE-/tmp}
        export APPSERVER_BIN="${APPSERVER_BASE}"
        executeCommand "scp retrieveApplicationArchive.sh ${CP_BIN_DIR}"
        executeCommand "${SSH_BASE} ${APPSERVER_BIN}/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"
        executeCommand "${SSH_BASE} ${JARCPCMD}"
        executeCommand "${SSH_BASE} ${JARCLNCMD}"
	;;
  metadata-sync)
        cd /opt/build/scripts/perf
        echo "Building Triggers in metadata-sync"
        export ADS_USER="ADS_CORE_MSO1,ADS_CORE_MSO2"
        export CAAS_USER="CAAS_CORE"
        export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
        echo "APP - ${APP} TAR - ${TAR}  Vers - ${VERSION} ADS User - ${ADS_USER}  CAAS User - ${CAAS_USER}"
        ./retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}
        cd ${WORKING_DIR}
        echo "Running ./install.sh ${ADS_USER} ${CAAS_USER} against 10.13.19.67 1522 bucket"
        chmod +x install.sh
        ./install.sh ${ADS_USER} ${CAAS_USER} cm_system Perf0ra 10.13.19.67 1522 bucket 
        ;;
  MicroDev)
        export DESTBASE="/opt/tcserver/Microstrategy"
        export APPSERVER_IP="10.13.19.58"
        export WORKING_DIR="/var/tmp/deploymentWorkArea/${TAR}/${VERSION}"
        export JARCPCMD="\"cd ${WORKING_DIR}; /opt/Microstrategy/MicroStrategy/bin/mstrcmdmgr -n performance_test -u Administrator -p "Perf_test01" -f /var/tmp/deploymentWorkArea/${TAR}/${VERSION}/mstrcmdmgr.scp -o ${WORKING_DIR}/${VERSION}.log; unix2dos ${WORKING_DIR}/${VERSION}.log; cat ${WORKING_DIR}/${VERSION}.log\""
        export JARCLNCMD="rm ${WORKING_DIR}/*micro*"
        export SSH_CP_BIN_DIR="mstradmin@${APPSERVER_IP}:/var/tmp/"
        export CP_BIN_DIR="${APPSERVER_IP}:/var/tmp"
        export SSH_BASE="ssh mstradmin@${APPSERVER_IP}"
        export WORKING_BASE="${CP_BIN_DIR}/deploymentWorkArea/${TAR}/${VERSION}"
        export APPSERVER_BASE=${APPSERVER_BASE-/var/tmp}
        export APPSERVER_BIN="${APPSERVER_BASE}"
        export UNDO="${WORKING_DIR}/undopackage_${VERSION}"
        export PACKAGE="${WORKING_DIR}/MicroDev.mmp"
        executeCommand "scp retrieveApplicationArchive.sh ${SSH_CP_BIN_DIR}"
        executeCommand "${SSH_BASE} ${APPSERVER_BIN}/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"
        export FULL_TAR="${TAR}_${VERSION}.tar"
        echo "CREATE UNDOPACKAGE \"${UNDO}\" FOR PROJECT \"${MSDSN}\" FROM PACKAGE \"${PACKAGE}\";" >> /var/tmp/mstrcmdmgr.scp
        echo "IMPORT PACKAGE \"${PACKAGE}\" FOR PROJECT \"${MSDSN}\";" >> /var/tmp/mstrcmdmgr.scp
        echo "UPDATE SCHEMA REFRESHSCHEMA FOR PROJECT \"${MSDSN}\";" >> /var/tmp/mstrcmdmgr.scp
        executeCommand "scp /var/tmp/mstrcmdmgr.scp ${SSH_CP_BIN_DIR}/deploymentWorkArea/${TAR}/${VERSION}/mstrcmdmgr.scp"
        executeCommand "${SSH_BASE} ${JARCPCMD}"
        executeCommand "rm /var/tmp/mstrcmdmgr.scp"
        ;;
  dai-etl-feeder)
	export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
	executeCommand "./retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"
        export DESTBASE="/opt/tcserver/dai_etl_feeder"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
        export JARCPCMD="cp ${WORKING_DIR}/*dai-etl*.jar ${DESTBASE}/"
	export JARCLNCMD1="rm \-fR ${WORKING_DIR}"
        export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:/tmp/"
        export CP_BIN_DIR="${APPSERVER_IP}:/tmp"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
        export APPSERVER_BASE=${APPSERVER_BASE-/tmp}
        export APPSERVER_BIN="${APPSERVER_BASE}"
        DEPLOYED_VERSION=`/opt/build/scripts/check_dbversions.sh -a dai-etl-feeder -e devint`

#	export DEPLOYED_VERSION=`ssh tcserver@dvappdai01 "cd /opt/tcserver/dai_etl_feeder; jar xf dai-etl-feeder-3.0.0-SNAPSHOT.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
#	echo "--------------------------------------------------"
#	echo "Existing deployed version: $DEPLOYED_VERSION"
        executeCommand "scp retrieveApplicationArchive.sh ${CP_BIN_DIR}"
        executeCommand "${SSH_BASE} ${APPSERVER_BIN}/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"
        #executeCommand "${SSH_BASE} ${JARCPCMD}"
        executeCommand "${SSH_BASE} ${JARCLNCMD1}"

	################
	# Upgrades the database to the requested version
	################
	upgradeDatabase() {
	    #echo "Upgrade database"
            #echo "--------------------------------------------------"
	    cd ${WORKING_DIR}/liquibase
	    echo "${LIQUIBASE_BASE_CMD} update -DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME} -DBAR_SCHEMA_NAME=${BAR_SCHEMA_NAME} -DBILLING_SCHEMA_NAME=${BILLING_SCHEMA_NAME}" 
	    executeCommand "${LIQUIBASE_BASE_CMD} update -DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME} -DBAR_SCHEMA_NAME=${BAR_SCHEMA_NAME} -DBILLING_SCHEMA_NAME=${BILLING_SCHEMA_NAME} && ${LIQUIBASE_BASE_CMD} tag ${VERSION}"
	    cd -
	}

	################
	# Rollback the database to the requested version
	################
	rollbackDatabase() {
	    #echo "Rollback database"    
            #echo "--------------------------------------------------"
	    cd ${WORKING_DIR}/liquibase
	    echo "${LIQUIBASE_BASE_CMD} rollback ${VERSION}"
	    executeCommand "${LIQUIBASE_BASE_CMD} rollback ${VERSION}"
            cd -
	}
   
	executeCommandNoFail "rm *changelog*"
	executeCommand "cp liquibase.jar ${WORKING_DIR}/liquibase"
	executeCommand "cp ojdbc6.jar ${WORKING_DIR}/liquibase"

	LIQUIBASE_BASE_CMD="java -jar liquibase.jar --logLevel=info --driver=oracle.jdbc.driver.OracleDriver"
	LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --changeLogFile=./master-changelog.xml"
	LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=\"${JDBC_URL}\""
	LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --username=${DB_USER} --password=${DB_PASS} --classpath=./ojdbc6.jar"


	executeCommand "./compareVersions.sh -n ${VERSION} -o ${DEPLOYED_VERSION}"

	case "$RESULT" in
	  "1")
	   upgradeDatabase
	  ;;
	  "-1")
	   rollbackDatabase
	  ;;
	  *)
	   echo "Database at the correct version"
	esac
#	echo "JARCLNCMD1=${JARCLNCMD1} JARCLNCMD2=${JARCLNCMD2} DEPLOYED_VERSION=${DEPLOYED_VERSION} LIQUIBASE_BASE_CMD=${LIQUIBASE_BASE_CMD}"
	executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/getApplicationVersion.sh"
	executeCommand "rm -fR ${WORKING_DIR}"
        ;;
esac

exit 0
