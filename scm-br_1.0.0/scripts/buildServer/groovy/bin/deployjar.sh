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

while getopts "ha:t:o:e:r:j:m:p:u:b:c:v" OPTION
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
           JDBC_URL=jdbc:oracle:thin:@10.13.18.61:1522:scrum004
#           JDBC_URL=jdbc:oracle:thin:@10.13.18.111:1522:dev003
           export DB_USER=DI_${DB_USER}
           export DB_PASS=DI_${DB_PASS}
       elif [[ $OPTARG = "scrum1" ]]; then
           APPSERVER_IP=10.13.18.115
           JDBC_URL=jdbc:oracle:thin:@10.13.18.61:1522:scrum004
#           JDBC_URL=jdbc:oracle:thin:@10.13.18.119:1522:scrum001
           export DB_USER=SC1_${DB_USER}
           export DB_PASS=SC1_${DB_PASS}
       elif [[ $OPTARG = "scrum2" ]]; then
           APPSERVER_IP=10.13.18.116
           JDBC_URL=jdbc:oracle:thin:@10.13.18.61:1522:scrum004
#           JDBC_URL=jdbc:oracle:thin:@10.13.18.120:1522:scrum002
           export DB_USER=SC2_${DB_USER}
           export DB_PASS=SC2_${DB_PASS}
       elif [[ $OPTARG = "scrum3" ]]; then
           APPSERVER_IP=10.13.18.117
           JDBC_URL=jdbc:oracle:thin:@10.13.18.61:1522:scrum004
#           JDBC_URL=jdbc:oracle:thin:@10.13.18.121:1522:scrum003
           export DB_USER=SC3_${DB_USER}
           export DB_PASS=SC3_${DB_PASS}
       elif [[ $OPTARG = "scrum4" ]]; then
           APPSERVER_IP=10.13.18.122
           JDBC_URL=jdbc:oracle:thin:@10.13.18.61:1522:scrum004
           export DB_USER=SC4_${DB_USER}
           export DB_PASS=SC4_${DB_PASS}
           export CAAS_USER="SC4_CAAS"
           export ADS_USER="SC4_ADS"
       elif [[ $OPTARG = "Marley" ]]; then
           APPSERVER_IP=10.13.18.118
           JDBC_URL=jdbc:oracle:thin:@10.13.18.61:1522:scrum004
           export DB_USER=MAR_${DB_USER}
           export DB_PASS=MAR_${DB_PASS}
           export CAAS_USER="MAR_CAAS"
           export ADS_USER="MAR_ADS"
       elif [[ $OPTARG = "RH65" ]]; then
           APPSERVER_IP=10.13.18.19
           JDBC_URL=jdbc:oracle:thin:@10.13.18.61:1522:scrum004
#           JDBC_URL=jdbc:oracle:thin:@10.13.18.119:1522:scrum001
           export DB_USER=RH65_${DB_USER}
           export DB_PASS=RH65_${DB_PASS}
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
  dai-metadata-ingestion)
        export DESTBASE="/opt/tcserver/dai-metadata-ingestion"
        export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
        export JARCPCMD="\"cp ${WORKING_DIR}/*.* ${DESTBASE}/\""
        export JARCLNCMD="\"rm \-fR ${WORKING_DIR}; rm ${DESTBASE}/${TAR}_${VERSION}.tar\""
#       export JARCLNCMD="rm ${WORKING_DIR}/*cip-batch* ${WORKING_DIR}/*cip-immediate* ${WORKING_DIR}/dai-cip*.tar ${WORKING_DIR}/README.txt"
        export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:/tmp/"
        export CP_BIN_DIR="${APPSERVER_IP}:/tmp"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
        export APPSERVER_BASE=${APPSERVER_BASE-/tmp}
        export APPSERVER_BIN="${APPSERVER_BASE}"
        executeCommand "scp retrieveApplicationArchive.sh ${SSH_CP_BIN_DIR}"
        executeCommand "${SSH_BASE} ${APPSERVER_BIN}/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"
        executeCommand "${SSH_BASE} ${JARCPCMD}"
        executeCommand "${SSH_BASE} ${JARCLNCMD}"
        ;;
  old_dai-cip)
	export DESTBASE="/opt/tcserver/dai-cip"
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
	executeCommand "scp retrieveApplicationArchive.sh ${SSH_CP_BIN_DIR}"
	executeCommand "${SSH_BASE} ${APPSERVER_BIN}/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"
	executeCommand "${SSH_BASE} ${JARCPCMD}"
	executeCommand "${SSH_BASE} ${JARCLNCMD}"
	;;
  dai-cip)
        export DESTBASE="/opt/tcserver/dai-cip"
        export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
        export JARCPCMD="\"cp ${WORKING_DIR}/dai-cip.jar ${DESTBASE}/bin; cp ${WORKING_DIR}/config/launcher.sh ${DESTBASE}/launcher.sh\""
        export JARCLNCMD="rm \-fR ${WORKING_DIR}"
        export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:/tmp/"
        export CP_BIN_DIR="${APPSERVER_IP}:/tmp"
        export APPSERVER_BASE=${APPSERVER_BASE-/tmp}
        export APPSERVER_BIN="${APPSERVER_BASE}"
        executeCommand "scp retrieveApplicationArchive.sh ${SSH_CP_BIN_DIR}"
        executeCommand "scp deploycip.sh ${SSH_CP_BIN_DIR}"
        executeCommand "${SSH_BASE} ${APPSERVER_BIN}/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"
        executeCommand "${SSH_BASE} ${APPSERVER_BIN}/deploycip.sh -a ${APP} -t ${TAR} -r ${VERSION} -s ${TARGENV}"
        executeCommand "${SSH_BASE} ${JARCPCMD}"
        executeCommand "${SSH_BASE} \"chmod +x ${DESTBASE}/launcher.sh\""
        ;;
  acp)
        export DESTBASE="/opt/tcserver/acp"
        export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"

        export JARCPCMD="\"cp ${WORKING_DIR}/acp.jar ${DESTBASE}/bin/; cp ${WORKING_DIR}/config/launcher.sh ${DESTBASE}/launcher.sh\""
#        export JARCLNCMD="rm \-fR ${WORKING_DIR}"
        export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:/tmp/"
        export CP_BIN_DIR="${APPSERVER_IP}:/tmp"
        export SSH_BASE="ssh tcserver@${APPSERVER_IP}"
        export APPSERVER_BASE=${APPSERVER_BASE-/tmp}
        export APPSERVER_BIN="${APPSERVER_BASE}"
        executeCommand "scp retrieveApplicationArchive.sh ${SSH_CP_BIN_DIR}"
        executeCommand "scp deployacp.sh ${SSH_CP_BIN_DIR}"
        executeCommand "${SSH_BASE} ${APPSERVER_BIN}/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"
        executeCommand "${SSH_BASE} ${APPSERVER_BIN}/deployacp.sh -a ${APP} -t ${TAR} -r ${VERSION} -s ${TARGENV}" 
        executeCommand "${SSH_BASE} ${JARCPCMD}"

#        executeCommand "${SSH_BASE} ${JARCLNCMD}"
        ;;
  dai-lincoln)
        export DESTBASE="/opt/tcserver/log_splitter"
        export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
        export JARCPCMD1="cp ${WORKING_DIR}/lincoln.jar ${DESTBASE}"
        export JARCPCMD2="cp ${WORKING_DIR}/lincoln.properties ${DESTBASE}"
        export JARCPCMD3="cp ${WORKING_DIR}/lincoln-log4j.xml ${DESTBASE}"
        export JARCPCMD4="cp ${WORKING_DIR}/splitLogs.bash ${DESTBASE}"
        export JARCLNCMD="rm ${WORKING_DIR}/*.*"
        export JARSETCMD="chmod +x ${DESTBASE}/splitLogs.bash"
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
        executeCommand "${SSH_BASE} ${JARSETCMD}"
        executeCommand "${SSH_BASE} ${JARCLNCMD}"
	;;
  MicroDev)
        export DESTBASE="/opt/tcserver/Microstrategy"
        export APPSERVER_IP="10.13.18.59"
        export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
        export JARCPCMD="\"cd ${WORKING_DIR}; /opt/Microstrategy/MicroStrategy/bin/mstrcmdmgr -n SCRUM -u Administrator -p test_1234 -f /tmp/deploymentWorkArea/${TAR}/${VERSION}/mstrcmdmgr.scp -o ${WORKING_DIR}/${VERSION}.log; unix2dos ${WORKING_DIR}/${VERSION}.log; cat ${WORKING_DIR}/${VERSION}.log\""
        export JARCLNCMD="rm ${WORKING_DIR}/*micro*"
        export SSH_CP_BIN_DIR="mstradmin@${APPSERVER_IP}:/tmp/"
        export CP_BIN_DIR="${APPSERVER_IP}:/tmp"
        export SSH_BASE="ssh mstradmin@${APPSERVER_IP}"
        export WORKING_BASE="${CP_BIN_DIR}/deploymentWorkArea/${TAR}/${VERSION}"
        export APPSERVER_BASE=${APPSERVER_BASE-/tmp}
        export APPSERVER_BIN="${APPSERVER_BASE}"
        export UNDO="${WORKING_DIR}/undopackage_${VERSION}"
        export PACKAGE="${WORKING_DIR}/MicroDev.mmp"
        executeCommand "scp retrieveApplicationArchive.sh ${SSH_CP_BIN_DIR}"
        executeCommand "${SSH_BASE} ${APPSERVER_BIN}/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"
        export FULL_TAR="${TAR}_${VERSION}.tar"
        echo "CREATE UNDOPACKAGE \"${UNDO}\" FOR PROJECT \"${MSDSN}\" FROM PACKAGE \"${PACKAGE}\";" >> /tmp/mstrcmdmgr.scp
        echo "IMPORT PACKAGE \"${PACKAGE}\" FOR PROJECT \"${MSDSN}\";" >> /tmp/mstrcmdmgr.scp
        echo "UPDATE SCHEMA REFRESHSCHEMA FOR PROJECT \"${MSDSN}\";" >> /tmp/mstrcmdmgr.scp
        executeCommand "scp /tmp/mstrcmdmgr.scp ${SSH_CP_BIN_DIR}/deploymentWorkArea/${TAR}/${VERSION}/mstrcmdmgr.scp"
        executeCommand "${SSH_BASE} ${JARCPCMD}"
        executeCommand "rm /tmp/mstrcmdmgr.scp"
        ;;
  MicroDev_iir)
        export DESTBASE="/opt/tcserver/Microstrategy"
        export APPSERVER_IP="10.13.18.59"
        export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
        export JARCPCMD="\"cd ${WORKING_DIR}; /opt/Microstrategy/MicroStrategy/bin/mstrcmdmgr -n SCRUM -u Administrator -p test_1234 -f /tmp/deploymentWorkArea/${TAR}/${VERSION}/mstrcmdmgr.scp -o ${WORKING_DIR}/${VERSION}.log; unix2dos ${WORKING_DIR}/${VERSION}.log; cat ${WORKING_DIR}/${VERSION}.log\""
        export JARCLNCMD="rm ${WORKING_DIR}/*micro*"
        export SSH_CP_BIN_DIR="mstradmin@${APPSERVER_IP}:/tmp/"
        export CP_BIN_DIR="${APPSERVER_IP}:/tmp"
        export SSH_BASE="ssh mstradmin@${APPSERVER_IP}"
        export WORKING_BASE="${CP_BIN_DIR}/deploymentWorkArea/${TAR}/${VERSION}"
        export APPSERVER_BASE=${APPSERVER_BASE-/tmp}
        export APPSERVER_BIN="${APPSERVER_BASE}"
        export UNDO="${WORKING_DIR}/undopackage_${VERSION}"
        export PACKAGE="${WORKING_DIR}/MicroDev.mmp"
        executeCommand "scp retrieveApplicationArchive.sh ${SSH_CP_BIN_DIR}"
        executeCommand "${SSH_BASE} ${APPSERVER_BIN}/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"
        export FULL_TAR="${TAR}_${VERSION}.tar"
        echo "CREATE UNDOPACKAGE \"${UNDO}\" FOR PROJECT \"${MSDSN}\" FROM PACKAGE \"${PACKAGE}\";" >> /tmp/mstrcmdmgr.scp
        echo "IMPORT PACKAGE \"${PACKAGE}\" FOR PROJECT \"${MSDSN}\";" >> /tmp/mstrcmdmgr.scp
        echo "UPDATE SCHEMA REFRESHSCHEMA FOR PROJECT \"${MSDSN}\";" >> /tmp/mstrcmdmgr.scp
        executeCommand "scp /tmp/mstrcmdmgr.scp ${SSH_CP_BIN_DIR}/deploymentWorkArea/${TAR}/${VERSION}/mstrcmdmgr.scp"
        executeCommand "${SSH_BASE} ${JARCPCMD}"
        executeCommand "rm /tmp/mstrcmdmgr.scp"
        ;;
 MicroDev_bau)
       export DESTBASE="/opt/tcserver/Microstrategy"
       export APPSERVER_IP="10.13.18.59"
       export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
       export JARCPCMD="\"cd ${WORKING_DIR}; /opt/Microstrategy/MicroStrategy/bin/mstrcmdmgr -n SCRUM -u Administrator -p test_1234 -f /tmp/deploymentWorkArea/${TAR}/${VERSION}/mstrcmdmgr.scp -o ${WORKING_DIR}/${VERSION}.log && unix2dos ${WORKING_DIR}/${VERSION}.log && cat ${WORKING_DIR}/${VERSION}.log\""
       export JARCLNCMD="rm ${WORKING_DIR}/*micro*"
       export SSH_CP_BIN_DIR="mstradmin@${APPSERVER_IP}:/tmp/"
       export CP_BIN_DIR="${APPSERVER_IP}:/tmp"
       export SSH_BASE="ssh mstradmin@${APPSERVER_IP}"
       export WORKING_BASE="${CP_BIN_DIR}/deploymentWorkArea/${TAR}/${VERSION}"
       export APPSERVER_BASE=${APPSERVER_BASE-/tmp}
       export APPSERVER_BIN="${APPSERVER_BASE}"
       export UNDO="${WORKING_DIR}/undopackage_${VERSION}"
       export PACKAGE="${WORKING_DIR}/MicroDev.mmp"
       executeCommand "scp retrieveApplicationArchive.sh ${SSH_CP_BIN_DIR}"
       executeCommand "${SSH_BASE} ${APPSERVER_BIN}/retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}"
       export FULL_TAR="${TAR}_${VERSION}.tar"
       echo "CREATE UNDOPACKAGE \"${UNDO}\" FOR PROJECT \"${MSDSN}\" FROM PACKAGE \"${PACKAGE}\";" >> /tmp/mstrcmdmgr.scp
       echo "IMPORT PACKAGE \"${PACKAGE}\" FOR PROJECT \"${MSDSN}\";" >> /tmp/mstrcmdmgr.scp
       echo "UPDATE SCHEMA REFRESHSCHEMA FOR PROJECT \"${MSDSN}\";" >> /tmp/mstrcmdmgr.scp
       executeCommand "scp /tmp/mstrcmdmgr.scp ${SSH_CP_BIN_DIR}/deploymentWorkArea/${TAR}/${VERSION}/mstrcmdmgr.scp"
       executeCommand "${SSH_BASE} ${JARCPCMD}"
       executeCommand "rm /tmp/mstrcmdmgr.scp"
       ;;
  metadata-sync)
        cd /opt/build/scripts
        echo "Building Triggers in metadata-sync"
        export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"
        echo "APP - ${APP} TAR - ${TAR}  Vers - ${VERSION}"
        ./retrieveApplicationArchive.sh -a ${APP} -t ${TAR} -r ${VERSION}
        cd ${WORKING_DIR}
        echo "Running ./install.sh ${ADS_USER} ${CAAS_USER} cm_system oracle123 10.13.18.61 1522 scrum004"
        chmod +x install.sh
        ./install.sh ${ADS_USER} ${CAAS_USER} cm_system oracle123 10.13.18.61 1522 scrum004 
        ;;
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
        cd ${WORKING_DIR}/liquibase
        executeCommand "cp liquibase.jar ${WORKING_DIR}/liquibase"
        executeCommand "cp ojdbc6.jar ${WORKING_DIR}/liquibase"

        LIQUIBASE_BASE_CMD="java -jar liquibase.jar --logLevel=info --driver=oracle.jdbc.driver.OracleDriver"
        LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --changeLogFile=./master-changelog.xml"
        LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=\"${JDBC_URL}\""
        LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --username=${DB_USER} --password=${DB_PASS} --classpath=./ojdbc6.jar"

        echo "${LIQUIBASE_BASE_CMD} update -DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME} -DBILLING_SCHEMA_NAME=${BILLING_SCHEMA_NAME}"
        executeCommand "${LIQUIBASE_BASE_CMD} update -DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME} -DBILLING_SCHEMA_NAME=${BILLING_SCHEMA_NAME} && ${LIQUIBASE_BASE_CMD} tag ${VERSION}"
        executeCommand "${JARCLNCMD}"
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
        executeCommand "scp retrieveApplicationArchive.sh ${SSH_CP_BIN_DIR}"
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
