#!/bin/bash 
#
# Single_Component_Deploy.sh
# Expected inputs - Component, Clear_Logs, VERSION
#
# Edits for component/system additions
# 
#  APP - The .war name within the .tar file (if the name is different than the .tar)
#  APPSERVER_IP - The hostname/IP of the target system
#  INSTANCE     - The tcserver instance specific to what is being deployed
#  WEBAPPS      - The As Installed naming of the deployed application (should match the Context line of server.xml)
#  Verify User supplies a Username and Purpose for the Deployment
#
# Function descriptions:
#
#  executeCommand: 	Excute a command, evaluate for success and exit on failure
#  fnInitRpt:		Initialze a new .html report file for eventual concatanation for Deployment History	
#  fnVERSIONCheck	Check version string 'Implementation Version' inside exploded webapps location META-DATA/MANIFEST.MF
#  fnJarVERSIONCheck	Check version string 'Implementation Version' inside .jar file
#  fnCheckDBVers	Check version of DB using DATABASECHANGELOG and liquibase TAG
#  fnBaseAppSet		Setup .war generic delivery variables, Working directory, etc.
#  fnBaseJarAppSet	Setup .jar generic delivery variables, Working directory, etc.
#  fnDB_Rebuild		Drop the DB User and Rebuild using the component's GenUser .sql scripts
#  fnDepDB              Setup and execute liquibase execution for Database delivery
#  fnRebuildCheck	Perform the version check to ensure fallback is by rebuild only
#  fnClearLogs		Clear the webapp log files to regain space 
#  fnSendApp		Deliver the Component .tar file to the App_Files directory
#  fnCpyJarScpts	
#  fnCpyScpts		Delivers the deployWar.sh file to the Component's ./bin directory
#  fnRetApp		Retrieve the Component .tar file and deliver/unpack in the build server Working directory
#  fnStopDepApp		Stop applications identified as dependent apps to enable DB delivery	
#  fnStartDepApp	Start applications identified as dependent apps after DB delivery
#  fnStopApp		Stop the Components application server
#  fnStartApp		Start the Components application server
#  fnDepWar		(Runs external) Runs the deployWar.sh file on the target server/component/bin dir
#  fnDepJar		
#  fnCleanup		Cleanup delivered 
#  fnJarCln
#  fnRptVer		Reports version to Update Manager .txt files
#  fnPostToSlack	Posts the deploy action to Canoe Ventures slack.com instance in the #deployments channel
#  fnDefSysVars		Deprecated - Replaced with ZayoSCMSysVars.sh script - Common System Definitions (ie; scrum, devint, etc.)
#  Collector Functions that call the above single functions (useful in triage
#  fnDeployApp		Collector function to deploy .war based component		
#  fnDeployJar		Collector function to deploy .jar based component
#  fnDeployDB		Collector function to delivery Database component
#  fnDeployMD           Collector function to deliver MicroStrategy component

# Assign inputs to variable names since export won't carry acrosss ssh (only needed for PackageDeploy jobs)
# If statement below verifies that 7 variables were passed to the deploy script.  
#   If 7 variables were passed, then assign them to their regular variables as normal
#   If only 6 were passed, assign VERSION/Version as null and reassign the remaining variables
if [[ -z ${9} ]] ; then
  echo "No version supplied"
  export Component=${1}
  export DB_Rebuild=${2}
  export VERSION=""
  export Clear_Logs=${3}
  export DeployTarg=${4}
  export BUILD_TAG=${5}
  export export DeployUser=${6}
  export JOB_NAME=${7}
  export BUILD_NUMBER=${8}
  echo "Component=$1 DB_Rebuild=$2 VERSION=$VERSION Clear_Logs=$3 DeployTarg=$4 BUIILD_TAG=$5 DeployUser=$6 JOB_NAME=$7 BUILD_NUMBER=$8"
else
  echo "Version supplied - ${9}"
  export Component=${1}
  export DB_Rebuild=${2}
  export Version=${9}
  export VERSION=${9}
  export Clear_Logs=${3}
  export DeployTarg=${4}
  export BUILD_TAG=${5}
  export DeployUser=${6}
  export JOB_NAME=${7}
  export BUILD_NUMBER=${8}
  echo "Component=$1 DB_Rebuild=$2 Clear_Logs=$3 DeployTarg=$4 BUIILD_TAG=$5 DeployUser=$6 JOB_NAME=$7 BUILD_NUMBER=$8 VERSION=$9"
fi

# Check to see if a version is supplied and notify the user that no version will indicate a DevInt version upgrade to the selected Scrum system
 if [ -z ${VERSION} ] ; then
    getVer="1"
    echo "For Scrum deployments, if no version is supplied, the existing DevInt version will be deployed"
 fi

# Ensure Deploy User is identified
 if [ -z "$DeployUser" ] ; then
    echo "<h2>User must supply a user name and summary of deploy purpose - $DeployUser</h2>"
    exit 1
 fi
echo "Deployed by : $DeployUser"

export TAR=${Component}
cd /opt/build/scripts/
export FailFlag="No"
######################################################################
#                      Utility Functions of script 
######################################################################
executeCommand() {
 echo "Executing : $1"
 FUNC_RV=eval $1
 if [ $? -ne 0 ] ; then
     echo "ERROR: Error executing $1"
     exit 1
 fi
}

executeMicroDevCommand() {
 echo "Executing : $1"
 FUNC_RV=`eval "$1"`
 if [ $? -ne 0 ] ; then
     echo "ERROR: Error executing $1"
     exit 1
 fi
}

executeCommandNoFail() {
    echo "Executing : $1"
    RESULT=`eval "$1"`
    echo "Result : $RESULT"
}

fnInitRpt() { 
DepDate=`date | awk '{print \$1,\$2,\$3,\$4}'`
echo "<b>--- Deployment ID:</b> ${BUILD_TAG} - ${DepDate}<br>" >> /tmp/${BUILD_TAG}.log
echo "<b>Deployment to ${DeployTarg} by ${DeployUser} </b><br>" >> /tmp/${BUILD_TAG}.log
echo "<b>Component: </b>${Component} <br>" >> /tmp/${BUILD_TAG}.log
echo "<b>&nbsp<u> Upgrading ${Component}</u> :</b><br>" >> /tmp/${BUILD_TAG}.log
}

fnCompRpt() {
if ssh cvbuild@cvbuild.cv.infra "grep -q \"Liquibase Update Failed\" /opt/cie/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}/log" ; then
   echo "DB Update Failed."
   echo "<b>DB Rebuild: </b>${DB_Rebuild} <br>" >> /tmp/${BUILD_TAG}.log
   echo "<font bgcolor=black color=red><b>DB Update Failed !!</b></font><br>" >> /tmp/${BUILD_TAG}.log
   echo "<b>URL For Deploy output: </b><a href="http://cvbuild.cv.infra:7001/job/${JOB_NAME}/${BUILD_NUMBER}/console">console</a><br>" >> /tmp/${BUILD_TAG}.log
   echo "<hr>" >> /tmp/${BUILD_TAG}.log
   echo "<p>" >> /tmp/${BUILD_TAG}.log
   scp /tmp/${BUILD_TAG}.log cvbuild@cvbuild.cv.infra:/opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
   ssh cvbuild@cvbuild.cv.infra "mv /opt/build/scm/scripts/buildServer/log/${DeployTarg}.html /opt/build/scm/scripts/buildServer/log/${DeployTarg}.tmp; cat /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log /opt/build/scm/scripts/buildServer/log/${DeployTarg}.tmp > /opt/build/scm/scripts/buildServer/log/${DeployTarg}.html; rm /opt/build/scm/scripts/buildServer/log/${DeployTarg}.tmp; rm /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log"
   export FailFlag="Yes"
   exit 1
  else
   echo "<b>DB Rebuild: </b>${DB_Rebuild} <br>" >> /tmp/${BUILD_TAG}.log
   echo "<b>URL For Deploy output: </b><a href="http://cvbuild.cv.infra:7001/job/${JOB_NAME}/${BUILD_NUMBER}/console">console</a><br>" >> /tmp/${BUILD_TAG}.log
   echo "<hr>" >> /tmp/${BUILD_TAG}.log
   echo "<p>" >> /tmp/${BUILD_TAG}.log
   scp /tmp/${BUILD_TAG}.log cvbuild@cvbuild.cv.infra:/opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
   ssh cvbuild@cvbuild.cv.infra "mv /opt/build/scm/scripts/buildServer/log/${DeployTarg}.html /opt/build/scm/scripts/buildServer/log/${DeployTarg}.tmp; cat /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log /opt/build/scm/scripts/buildServer/log/${DeployTarg}.tmp > /opt/build/scm/scripts/buildServer/log/${DeployTarg}.html; rm /opt/build/scm/scripts/buildServer/log/${DeployTarg}.tmp; rm /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log"
fi
}

fnPostToSlack() {
export webhook_url="https://hooks.slack.com/services/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"
export channel="#deployments"
export username="SCMUpdMgr"
export text="Scrum Deploy: ${Component} at version ${VERSION} deployed to ${DeployTarg} by ${DeployUser}\n-URL for console output: <http://cvbuild.cv.infra:7001/job/${JOB_NAME}/${BUILD_NUMBER}/console|here>"
escapedText=$(echo $text | sed 's/"/\"/g' | sed "s/'/\'/g" )
json="{\"channel\": \"$channel\", \"username\":\"$username\", \"icon_emoji\":\"mega\", \"attachments\":[{\"color\":\"good\" , \"text\": \"$escapedText\"}]}"
if [ ${FailFlag} = "Yes" ] ; then
 curl -s -d "payload=$json" "$webhook_url"
else
 curl -s -d "payload=$json" "$webhook_url"
fi
}


fnVERSIONCheck() {
 export Deployed_VERSION=`ssh tcserver@${APPSERVER_IP} "grep Implementation-Version /opt/tcserver/instances/${INSTANCE}/webapps/${WEBAPPS}/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
  if [ ${getVer} = "1" ] ; then
    export VERSION=`ssh tcserver@cv-devint.cv.scrum "grep Implementation-Version /opt/tcserver/instances/${INSTANCE}/webapps/${WEBAPPS}/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
  fi
 echo "<b>&nbsp ... on ${APPSERVER_IP}</b> in instance <b>${INSTANCE}</b> from <b>$Deployed_VERSION to $VERSION</b><br>" >> /tmp/${BUILD_TAG}.log
 echo "---------------------------------------------------------------------------------------"
 echo "Upgrading ${Component} : in instance ${INSTANCE} from $Deployed_VERSION to $VERSION"
 echo "---------------------------------------------------------------------------------------"
}

fnJarVERSIONCheck() {
 export Deployed_VERSION=`ssh tcserver@${APPSERVER_IP} "cd /var/tmp; jar xf /opt/tcserver/${JarDirect}/${JarLoc1}/${JarName1}.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
  if [ ${getVer} = "1" ] ; then
   export VERSION=`ssh tcserver@cv-devint.cv.scrum "cd /var/tmp; jar xf /opt/tcserver/${JarDirect}/${JarLoc1}/${JarName1}.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
  fi
   echo "-----------------------------------------------------------------------------------------"
   echo "Upgrading ${Component} : in directory ${JarDirect} from $Deployed_VERSION to ${VERSION}"
   echo "-----------------------------------------------------------------------------------------"
   echo "<b>&nbsp ... on ${APPSERVER_IP}</b> in <b>${JarDirect}</b> from <b>${Deployed_VERSION} to ${VERSION}</b><br>" >> /tmp/${BUILD_TAG}.log
}

#Base Application server setup related variables.
fnBaseAppSet() {
  export APPSERVER_BASE="/opt/tcserver/instances/${INSTANCE}" ; echo "APPSERVER_BASE=${APPSERVER_BASE}"
  export APPSERVER_BIN="${APPSERVER_BASE}/bin" ; echo "APPSERVER_BIN=${APPSERVER_BIN}"
  export SSH_BASE="ssh tcserver@${APPSERVER_IP}" ; echo "SSH_BASE=${SSH_BASE}"
  export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:${APPSERVER_BIN}/" ; echo "SSH_CP_BIN_DIR=${SSH_CP_BIN_DIR}"
  export WORKING_DIR="/opt/tcserver/App_Files" ; echo "WORKING_DIR=${WORKING_DIR}"
  export SCP_BASE="tcserver@${APPSERVER_IP}" ; echo "SCP_BASE=${SCP_BASE}"
}

#Base Application server setup related variables for jar components.
fnBaseJarAppSet() {
  export TAR="${Component}_${VERSION}" ; echo "TAR=${TAR}"
  export WORKING_DIR="/opt/tcserver/App_Files" ; echo "WORKING_DIR=${WORKING_DIR}"
  export CP_BIN_DIR="tcserver@${APPSERVER_IP}:/opt/tcserver/App_Files" ; echo "CP_BIN_DIR=${CP_BIN_DIR}"
  export SSH_BASE="ssh tcserver@${APPSERVER_IP}" ; echo "SSH_BASE=${SSH_BASE}"
  export APPSERVER_BASE=${APPSERVER_BASE-/tmp} ; echo "APPSERVER_BASE=${APPSERVER_BASE}"
  export APPSERVER_BIN="${APPSERVER_BASE}" ; echo "APPSERVER_BIN=${APPSERVER_BIN}"
  export ARCHIVE="${Component}_${VERSION}.tar" ; echo "ARCHIVE=${ARCHIVE}"
  export SCP_BASE="tcserver@${APPSERVER_IP}" ; echo "SCP_BASE=${SCP_BASE}"
  export DESTBASE="/opt/tcserver/${Component}" ; echo "DESTBASE=${DESTBASE}"
}

fnMicroDevSet() {
  export TAR="MicroDev_${VERSION}" ; echo "TAR=${TAR}"
  export SSH_BASE="ssh mstradmin@${APPSERVER_IP}"
  export SCP_BASE="mstradmin@${APPSERVER_IP}" ; echo "SCP_BASE=${SCP_BASE}"
  export WORKING_DIR="/tmp/deploymentWorkArea/${Component}/${VERSION}" ; echo "WORKING_DIR=${WORKING_DIR}"
  export UNDO="${WORKING_DIR}/undopackage_${VERSION}"
  export PACKAGE="${WORKING_DIR}/MicroDev.mmp"
  export SSH_CP_BIN_DIR="mstradmin@${APPSERVER_IP}:/tmp/deploymentWorkArea"

#  export JARCPCMD="\"cd ${WORKING_DIR}; /opt/Microstrategy/MicroStrategy/bin/mstrcmdmgr -n SCRUM -u Administrator -p test_1234 -f /tmp/deploymentWorkArea/${TAR}/${VERSION}/mstrcmdmgr.scp -o ${WORKING_DIR}/${VERSION}.log && unix2dos ${WORKING_DIR}/${VERSION}.log && cat ${WORKING_DIR}/${VERSION}.log\""

#  export JARCPCMD="\"cd ${WORKING_DIR}; /opt/Microstrategy/MicroStrategy/bin/mstrcmdmgr -n SCRUM -u Administrator -p test_1234 -f ${WORKING_DIR}/mstrcmdmgr.scp -o ${WORKING_DIR}/${VERSION}.log && unix2dos ${WORKING_DIR}/${VERSION}.log\""

  export JARCPCMD="\"cd ${WORKING_DIR}; /opt/Microstrategy/MicroStrategy/bin/mstrcmdmgr -n SCRUM -u Administrator -p test_1234 -f ${WORKING_DIR}/mstrcmdmgr.scp -o ${WORKING_DIR}/${VERSION}.log\""
  export CATLOG="\"cat ${WORKING_DIR}/${VERSION}.log\""
}

fnBuildMstrCmdMgr(){
 if [ -f /tmp/mstrcmdmgr.scp ] ; then 
  executeCommand "rm /tmp/mstrcmdmgr.scp"
 fi
  echo "CREATE UNDOPACKAGE \"${UNDO}\" FOR PROJECT \"${MSDSN}\" FROM PACKAGE \"${PACKAGE}\";" >> /tmp/mstrcmdmgr.scp
  echo "IMPORT PACKAGE \"${PACKAGE}\" FOR PROJECT \"${MSDSN}\";" >> /tmp/mstrcmdmgr.scp
  echo "UPDATE SCHEMA REFRESHSCHEMA FOR PROJECT \"${MSDSN}\";" >> /tmp/mstrcmdmgr.scp
#LH: 11/30/15: If MD deploy breaks this may be the culprit, new line for version reporting
  echo "ALTER PROJECT CONFIGURATION DESCRIPTION \"${VERSION}\" IN PROJECT \"${MSDSN}\";" >> /tmp/mstrcmdmgr.scp
}

#Function to check for DB_Rebuild and execute if needed
fnDB_Rebuild() {
  if [[ ${DB_Rebuild} = "No" ]]; then
  echo "Checking to ensure the DB is incrementing .vs. decrementing"
  fi

  if [[ ${DB_Rebuild} = "Yes" ]] ; then
  cd /opt/cvbuild/wa/DB_Extracts; mkdir ${BUILD_TAG}; cd ${BUILD_TAG}
  echo "Extracting DB creation scripts for ${VERSION} of ${Component}"

  scp cvbuild.cv.infra:/opt/build/releaseTars/${Component}/${Component}_${VERSION}.tar .
  tar -xf ${Component}_${VERSION}.tar liquibase/cisys
  cd liquibase/cisys
  echo "Dropping database users $DB_USER / $DB_PASS"
  export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1521)))(CONNECT_DATA=(SID=${SIDTarg})))"

if [[ ${Component} = "caas-core" ]]; then
sqlplus -S cm_system/oracle123@$SQLCONN <<!
set heading off;
set feedback on;
set echo on;
define DB_USER='$DB_USER'
set verify on
set serveroutput on
@/opt/build/scripts/drop_flshbk.sql $DB_USER
exit
!
fi

if [[ ${Component} = "dai-smsi-relay" ]]; then
# dai-smsi-relay has four DBs so we redefine the DB User to the fourth DB, rerun the SysVars definitions 
# and drop the DB, then redefine to first DB and continue with regular deployment

 export DB_USER="RELAY3"
 export DB_PASS="RELAY3"
 source /opt/build/scripts/ZayoSCMSysVars.sh
sqlplus -S cm_system/oracle123@$SQLCONN <<!
set heading off;
set feedback on;
set echo on;
define DB_USER='$DB_USER'
set verify on
set serveroutput on
@/opt/build/scripts/drop_test.sql $DB_USER
exit sql.sqlcode
!
 export DB_USER="RELAY2"
 export DB_PASS="RELAY2"
 source /opt/build/scripts/ZayoSCMSysVars.sh
sqlplus -S cm_system/oracle123@$SQLCONN <<!
set heading off;
set feedback on;
set echo on;
define DB_USER='$DB_USER'
set verify on
set serveroutput on
@/opt/build/scripts/drop_test.sql $DB_USER
exit sql.sqlcode
!
 export DB_USER="RELAY1"
 export DB_PASS="RELAY1"
 source /opt/build/scripts/ZayoSCMSysVars.sh
sqlplus -S cm_system/oracle123@$SQLCONN <<!
set heading off;
set feedback on;
set echo on;
define DB_USER='$DB_USER'
set verify on
set serveroutput on
@/opt/build/scripts/drop_test.sql $DB_USER
exit sql.sqlcode
!
 export DB_USER="RELAY"
 export DB_PASS="RELAY"
 source /opt/build/scripts/ZayoSCMSysVars.sh
fi

sqlplus -S cm_system/oracle123@$SQLCONN <<!
set heading off;
set feedback on;
set echo on;
define DB_USER='$DB_USER'
set verify on
set serveroutput on
@/opt/build/scripts/drop_test.sql $DB_USER
define DeployTarg='$DeployTarg'
set verify off
@genUser.${DeployTarg}.sql
exit sql.sqlcode
!
  STATUS=${?}
  if [[ ${STATUS} != "0" ]]; then
   echo "Schema creation failed"
   exit ${STATUS}
  fi
 fi

#####  Removing section for flashback archive - JWS 6/8/15   ### Once Stephen has an idea how he wants to use these, I'll reenable
#if [[ ${Component} = "caas-core" ]]; then
#sqlplus -S cm_system/oracle123@$SQLCONN <<!
#set heading off;
#set feedback on;
#set echo on;
#define DB_USER='$DB_USER'
#set verify on
#set serveroutput on
#@/opt/build/scripts/caas_flshbk.sql $DB_USER
#exit
#!
#fi
}

fnCheckDBVers() {
cd /opt/cvbuild/wa/DB_Extracts; mkdir ${BUILD_TAG}; cd ${BUILD_TAG}
cd /opt/build/scripts
./check_dbversions.sh -a $Component -e devint >/opt/cvbuild/wa/DB_Extracts/${BUILD_TAG}/Version.in
  cd /opt/cvbuild/wa/DB_Extracts/${BUILD_TAG}
  echo "$Deployed_VERSION" >>Version.in
  tr -d '\n' <Version.in >Version.out
  Deployed_VERSION=`cat Version.out`
 
echo "$Deployed_VERSION"
}

#Displays error message for comparecheck failure
fnRebuildCheck() {
  Compcheck=`./compareVersions.sh -n $VERSION -o $Deployed_VERSION`
  if [[ $Compcheck = "-1" ]]; then
    echo "------------------------------------------------------"
    echo "Rebuild required to roll back to previous DB VERSION!"
    echo "------------------------------------------------------"
    echo "Please retry with DB rebuild!"
  exit 1
  fi
}

#Check for log clear and execture if needed
fnClearLogs() {
  if [[ ${Clear_Logs} = "Yes" ]] ; then
    echo "Removing log files ${Component} on ${targname}"
    ClearList=`ssh tcserver@${targname} "ls /opt/tcserver/instances/${INSTANCE}/logs"`
    echo ${ClearList}
    `ssh tcserver@${targname} "rm /opt/tcserver/instances/${INSTANCE}/logs/*log*"`
    ClearList=`ssh tcserver@${targname} "ls /opt/tcserver/instances/${INSTANCE}/logs"`
    echo ${ClearList}
  fi
}

#Creates and destroys App_Files  component/version specific working dir 
fnDirCreate() {
 export Check_Dir="${WORKING_DIR}/${Component}/${VERSION}"

# Initialize the working directory.
  ${SSH_BASE} "mkdir -p ${Check_Dir}"
}

fnMDDirCreate() {
  ${SSH_BASE} "rm -rf ${WORKING_DIR}"
  ${SSH_BASE} "mkdir -p ${WORKING_DIR}"
}

#Deliver Application function
# Modified for the Jenkins Slave setup.  SCP occurs from the slave through the Jenkins box copying to the target
fnSendApp() {
  echo "###SENDING###"
  export ARCHIVE="${Component}_${VERSION}.tar" ; echo "ARCHIVE=${ARCHIVE}"
  executeCommand "scp cvbuild@cvbuild.cv.infra:/opt/build/releaseTars/${Component}/${ARCHIVE} ${SCP_BASE}:${WORKING_DIR}"
}

fnSendMDApp() {
  export ARCHIVE="MicroDev_${VERSION}.tar" ; echo "ARCHIVE=${ARCHIVE}"
  executeCommand "scp cvbuild@cvbuild.cv.infra:/opt/build/releaseTars/MicroDev/${ARCHIVE} ${SCP_BASE}:${WORKING_DIR}"
}

fnSendMstCmdMgr(){
  executeCommand "scp /tmp/mstrcmdmgr.scp ${SSH_CP_BIN_DIR}/${Component}/${VERSION}/mstrcmdmgr.scp"
}

#Copy jar to location.
fnCpyJarScpts() {
  executeCommand "scp /opt/build/scripts/FnConf.sh ${CP_BIN_DIR}"
}

#Copy scripts to remote application server.
fnCpyScpts() {
  executeCommand "scp /opt/build/scripts/deployWar.sh ${SSH_CP_BIN_DIR}"
}

fnRetApp() {
export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"

# Initialize the working directory.
if [ -d ${WORKING_DIR} ] ; then
  executeCommand "rm -rf ${WORKING_DIR}"
fi
executeCommand "mkdir -p ${WORKING_DIR}"

# Retrieve and explode the application archive
 cd ${WORKING_DIR}
 export ARCHIVE="${Component}_${VERSION}.tar" ; echo "ARCHIVE=${ARCHIVE}"
 executeCommand "scp cvbuild@cvbuild.cv.infra:/opt/build/releaseTars/${Component}/${ARCHIVE} ${WORKING_DIR}"
 executeCommand "tar -xf ${Component}_${VERSION}.tar"
}

# Stop the application server of dependent applications
fnStopDepApp() {

#counter
export l=0

for k in $DependApps; do

  if /opt/build/scripts/tcServerAdmin.sh ${targname} $k status | grep "NOT" ;
then
     echo "Instance not running no shut down necessary"
else
    echo "Stopping $k"
    /opt/build/scripts/tcServerAdmin.sh ${targname} $k stop
    InAr[$l]=${k}
    l=$((l+1))
fi

done
}

# Start the application server of dependent applications
fnStartDepApp() {

export l=0

for k in ${InAr[@]}; do

    echo "Starting $InAr"
    /opt/build/scripts/tcServerAdmin.sh ${targname} ${InAr[$l]} start
#    /opt/build/scripts/tcServerAdmin.sh ${targname} ${InAr[$l]} start
    l=$((l+1))
done
}

# Stop the application server
fnStopApp() {
    /opt/build/scripts/tcServerAdmin.sh ${targname} ${INSTANCE} stop
}

# Start the application server
fnStartApp() {
   /opt/build/scripts/tcServerAdmin.sh ${targname} ${INSTANCE} start
}

fnFuncConf() {
executeCommand "${SSH_BASE} ${WORKING_DIR}/FnConf.sh -a ${APP} -t ${TAR} -r ${VERSION} -s ${DeployTarg} -c ${ConfDir}"
}

# Deploy the war to the app server.
fnDepWar() {
  executeCommand "${SSH_BASE} ${APPSERVER_BIN}/deployWar.sh -a ${APP} -t ${Component} -r ${VERSION} -i ${INSTANCE} -w ${WEBAPPS} -e ${APPSERVER_IP} -s ${DeployTarg} -v"
}

fnDepJar() {
#  if [[ $APP = "dai-metadata-ingestion"  ]]; then
#    ${SSH_BASE} "cd ${DESTBASE} ; tar -xf ${WORKING_DIR}/${TAR}.tar ${JarName1}.jar"
#  else
  ${SSH_BASE} "cd ${DESTBASE}/${JarLoc1} ; tar -xf ${WORKING_DIR}/${TAR}.tar ${JarName1}.jar"
#  fi
  ${SSH_BASE} "cd ${WORKING_DIR}/${APP}/${VERSION}; tar -xf ${WORKING_DIR}/${TAR}.tar"

#executeCommand "${SSH_BASE} ${APPSERVER_BIN}/deployJar.sh -a ${APP} -t ${Component} -r ${VERSION} -e ${APPSERVER_IP} -j ${JarDirect} -k ${JarName1} -m ${JarLoc1} -v"
}

fnDepMD(){
  ${SSH_BASE} "cd ${WORKING_DIR} ; tar -xf MicroDev_${VERSION}.tar"
# LH 7/27 trying to fix automated deploy
  executeMicroDevCommand "${SSH_BASE} ${JARCPCMD}"
  executeMicroDevCommand "${SSH_BASE} ${CATLOG}"
}

fnJarLaunch() {
  ${SSH_BASE} "cp ${WORKING_DIR}/${Component}/${VERSION}/config/launcher.sh ${DESTBASE}/launcher.sh"
  if [[ $APP = "acp"  ]]; then
     echo "Replacing lib directory"
     ${SSH_BASE} "cd ${DESTBASE}/bin; rm -fR lib; tar -xf ${WORKING_DIR}/${ARCHIVE} lib; ls -al lib"
  fi
}

fnDepDB() {
# Define custom Liquibase options as needed by the DBs
  if [[ $APP = "nCisClient" ]]; then
   export LiqBaOPTS="-DCAAS_SCHEMA_NAME=${CAAS_SCHEMA_NAME}"
  elif [[ $Component = "request-mgr" ]]; then
   export LiqBaOPTS="-DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME}"
  elif [[ $APP = "smsi-relay-client" ]]; then
   export LiqBaOPTS="-DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME}"
  elif [[ $Component = "ads-core" ]]; then
   export LiqBaOPTS="-DCAAS_SCHEMA_NAME=${CAAS_DB_USER} -Denvironment=dev"
  elif [[ $Component = "dai-etl-feeder" ]]; then
   export LiqBaOPTS="-DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME} -DBAR_SCHEMA_NAME=${ETL_BAR} -DBILLING_SCHEMA_NAME=${ETL_BILLING} -DREPORTING_SCHEMA_NAME=${REPORTING_SCHEMA_NAME}"
  elif [[ $Component = "smsi_reporting" ]]; then
   export LiqBaOPTS="-DCAMPAIGN_SCHEMA_NAME=${CAMPAIGN_SCHEMA_NAME} -DINGEST_SCHEMA_NAME=${REPORTING_SCHEMA_NAME}"
  else
   LiqBaOPTS=""
  fi
  echo "LiqBaOPTS=$LiqBaOPTS  -APP=$APP -Component=$Component"

# Copy over needed .jars for Liquibase to function
  executeCommand "cp /opt/build/scripts/liquibase.jar ${WORKING_DIR}/liquibase"
  executeCommand "cp /opt/build/scripts/ojdbc6.jar ${WORKING_DIR}/liquibase"
  executeCommand "cp /opt/build/scripts/derby*.jar ${WORKING_DIR}/liquibase"

# Build up the Liquibase command 
  LIQUIBASE_BASE_CMD="java -jar liquibase.jar --logLevel=info --driver=oracle.jdbc.driver.OracleDriver"
  LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --changeLogFile=master-changelog.xml"
  LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=${JDBC_URL}"
  LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --username=${DB_USER} --password=${DB_PASS} --classpath=./ojdbc6.jar"

# Execute the Liquibase command and Liquibase Options
  echo "Upgrade database"
  cd ${WORKING_DIR}/liquibase
  echo "${LIQUIBASE_BASE_CMD} update ${LiqBaOPTS}"
  echo "${LIQUIBASE_BASE_CMD} tag ${VERSION}"
  executeCommand "${LIQUIBASE_BASE_CMD} update ${LiqBaOPTS}" && executeCommand "${LIQUIBASE_BASE_CMD} tag ${VERSION}"
}

# clean up

fnInitClean() {
 export Exist_Dir="${WORKING_DIR}/${Component}"
 echo "Exist_Dir=${Exist_Dir}"
 if ssh tcserver@${targname} test -e ${Exist_Dir}; then
   echo "Directory Exists"
   executeCommand "${SSH_BASE} rm -fr ${Exist_Dir}"
 else
   echo "Directory doesn't exist"
 fi
 if ssh tcserver@${targname} test -e ${WORKING_DIR}/${Component}_${VERSION}.tar; then
   executeCommand "${SSH_BASE} rm ${WORKING_DIR}/${Component}_${VERSION}.tar"
 fi
}

fnCleanup() {
export Check_Dir="${WORKING_DIR}/${Component}"
  executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/deployWar.sh"
  executeCommand "${SSH_BASE} rm -fr ${Check_Dir}/*"
  echo "${SSH_BASE} \"ls -al /tmp/${BUILD_TAG}.log\""
  executeCommand "${SSH_BASE} \"rm /tmp/${BUILD_TAG}.log\""
# Example build log: /tmp/jenkins-DevInt_SingleComponent_Deploy-636.log
}

fnJarCln() {
export Check_Dir="${WORKING_DIR}/${Component}"
  executeCommand "${SSH_BASE} rm ${WORKING_DIR}/FnConf.sh"
  executeCommand "${SSH_BASE} rm -fr ${Check_Dir}"
  executeCommand "${SSH_BASE} rm ${WORKING_DIR}/${Component}_${VERSION}.tar"
}

fnMDCln() {
rm /tmp/mstrcmdmgr.scp
  executeCommand "${SSH_BASE} rm -fr ${WORKING_DIR}"
}

fnMDRep() {
 #LH 11/23: Doesn't work yet don't use. Sloppy needs to be cleaned and streamlined

rm /var/www/html/scrum2/${Component}_version.txt

 executeMicroDevCommand "${SSH_BASE} ${CATLOG} | grep \"execution completed successfully"\" > /var/www/html/scrum2/${Component}_version.txt

if [[ -z /var/www/html/scrum2/${Component}_version.txt ]]; then
  echo "$Version" > /var/www/html/scrum2/${Component}_version.txt
fi
}

# Report Production VERSION info
fnRptVer() {
  ssh cvbuild@cvbuild.cv.infra "echo \"${VERSION}\" > /var/www/html/${DeployTarg}/${Component}.txt"
  ssh cvbuild@cvbuild.cv.infra "date | awk '{print \$2,\$3,\$4}' > /var/www/html/${DeployTarg}/${Component}.instdate.txt"
}

######################################################################
#                 End of Utility Functions of script
######################################################################

######################################################################
#                   Begin Deployment Function calls 
######################################################################
# When testing, use as modular sequential functions.
# fnVERSIONCheck- Check the existing deployed VERSION 
# fnaseAppSet  - Base Application server, workarea setup related variables.
# fnSendApp     - Deliver Application to target Workarea (App_Files)
# fnCpyScpts    - Deliver deployWar.sh and stop.sh to target instance bindir
# fnStopApp     - Stop the target application server
# fnDepWar      - Run the deployWar.sh script on target server
# fnCleanup     - Clean up any delivered scripts, temporary files
# fnRptVer      - Report VERSION of deployment
 
fnDeployDB() {
  fnBaseAppSet
  fnRetApp
  #fnDepDB
  #fnClearLogs
  ##fnRptVer
  #fnCompRpt
}

######################################################################
#                End Deployment Functions of script
######################################################################

######################################################################
#                Components and Systems Definitions 
######################################################################

case $Component in
#--------------------------------------------------------------
# Database Only Components
#--------------------------------------------------------------
 caas-core)
#  AUTO_TEST)
#       export DependApps="cip cm metadata-publisher Pgmr-Cpgn-Int dai-national-cis Ad-Load-Manager dai-smsi-relay"
#       export DependJars="dai-cip acp"
       export DB_USER="AUTO-TEST-CAAS"
       export DB_PASS="AUTO-TEST-CAAS"
       source /opt/build/scripts/TmpO12/TEST_O12_ZayoSCMSysVars.sh
       fnInitRpt
#       fnStopDepApp
#       for d in $DependJars; do
#        echo "Stopping $d processes"
#        ssh tcserver@${targname} "cd $d; ./launcher.sh stop"
#       done
#       Deployed_VERSION=`fnCheckDBVers`
       fnDB_Rebuild
       fnDeployDB
#       fnStartDepApp
#       fnPostToSlack
       ;;
   bogus_app)
     echo "Bogus App - just an echo"
     echo "$Component $DB_Rebuild $Version $Clear_Logs $DeployTarg $BUILD_TAG $DeployUser"
   ;;
    *)
      echo "No Deploy...";;
esac
