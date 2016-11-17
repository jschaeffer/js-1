#!/bin/ksh
#
# Zayo_Perf_Single_Component_Deploy.sh
# Expected inputs - Component, Clear_Logs, VERSION, StealthDeploy
#
# Edits for component/system additions
# 
#  APP - The .war name within the .tar file (if the name is different than the .tar)
#  APPSERVER_IP - The hostname/IP of the target system
#  INSTANCE     - The tcserver instance specific to what is being deployed
#  WEBAPPS      - The As Installed naming of the deployed application (should match the Context line of server.xml)
#  Verify User supplies a Username and Purpose for the Deployment

if [ -z ${DeployUser} ] ; then
    echo "<h2>User must supply a user name and summary of deploy purpose</h2>"
    exit 1
fi
echo "Started by $DeployUser"
export TAR=${Component}
cd /opt/build/scripts/zayo_perf

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
   echo "<b>URL For Deploy output: </b><a href="${BUILD_URL}console">console</a><br>" >> /tmp/${BUILD_TAG}.log
   echo "<hr>" >> /tmp/${BUILD_TAG}.log
   echo "<p>" >> /tmp/${BUILD_TAG}.log
   scp /tmp/${BUILD_TAG}.log cvbuild@cvbuild.cv.infra:/opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
   ssh cvbuild@cvbuild.cv.infra "mv /opt/build/scm/scripts/buildServer/log/${DeployTarg}.html /opt/build/scm/scripts/buildServer/log/${DeployTarg}.tmp; cat /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log /opt/build/scm/scripts/buildServer/log/${DeployTarg}.tmp > /opt/build/scm/scripts/buildServer/log/${DeployTarg}.html; rm /opt/build/scm/scripts/buildServer/log/${DeployTarg}.tmp; rm /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log"
#   rm /tmp/${BUILD_TAG}.log
   exit 1
  else
   echo "<b>DB Rebuild: </b>${DB_Rebuild} <br>" >> /tmp/${BUILD_TAG}.log
   echo "<b>URL For Deploy output: </b><a href="${BUILD_URL}console">console</a><br>" >> /tmp/${BUILD_TAG}.log
   echo "<hr>" >> /tmp/${BUILD_TAG}.log
   echo "<p>" >> /tmp/${BUILD_TAG}.log
   scp /tmp/${BUILD_TAG}.log cvbuild@cvbuild.cv.infra:/opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
   ssh cvbuild@cvbuild.cv.infra "mv /opt/build/scm/scripts/buildServer/log/${DeployTarg}.html /opt/build/scm/scripts/buildServer/log/${DeployTarg}.tmp; cat /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log /opt/build/scm/scripts/buildServer/log/${DeployTarg}.tmp > /opt/build/scm/scripts/buildServer/log/${DeployTarg}.html; rm /opt/build/scm/scripts/buildServer/log/${DeployTarg}.tmp; rm /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log"
#   rm /tmp/${BUILD_TAG}.log
fi
}

fnPostToSlack() {
export webhook_url="https://hooks.slack.com/services/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"
export channel="#deployments"
export username="SCMUpdMgr"
export text="Performance Deploy: ${Component} at version ${VERSION} deployed to ${DeployTarg} by ${DeployUser}\n-URL for console output: <http://cvbuild.cv.infra:7001/job/${JOB_NAME}/${BUILD_NUMBER}/console|here>" 
escapedText=$(echo $text | sed 's/"/\"/g' | sed "s/'/\'/g" ) 
json="{\"channel\": \"$channel\", \"username\":\"$username\", \"icon_emoji\":\"mega\", \"attachments\":[{\"color\":\"good\" , \"text\": \"$escapedText\"}]}"
curl -s -d "payload=$json" "$webhook_url"
}

fnVERSIONCheck() {
 Deployed_VERSION=`ssh tcserver@${APPSERVER_IP} "grep Implementation-VERSION /opt/tcserver/instances/${INSTANCE}/webapps/${WEBAPPS}/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
 echo "---------------------------------------------------------------------"
 echo "Upgrading ${Component} : in instance ${INSTANCE} to ${VERSION}"
 echo "---------------------------------------------------------------------"
 echo "<b>&nbsp ... on ${APPSERVER_IP}</b> in instance <b>${INSTANCE}</b> from <b>${Deployed_VERSION} to ${VERSION}</b><br>" >> /tmp/${BUILD_TAG}.log
}

fnJarVERSIONCheck() {
 Deployed_VERSION=`ssh tcserver@${APPSERVER_IP} "cd /var/tmp; jar xf /opt/tcserver/${JarDirect}/${JarLoc1}/${JarName1}.jar META-INF/MANIFEST.MF; grep Implementation-VERSION META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
 echo "---------------------------------------------------------------------"
 echo "Upgrading ${Component} : in instance ${JarDirect} to ${VERSION}"
 echo "---------------------------------------------------------------------"
 echo "<b>&nbsp ... on ${APPSERVER_IP}</b> in <b>${JarDirect}</b> from <b>${Deployed_VERSION} to ${VERSION}</b><br>" >> /tmp/${BUILD_TAG}.log
}

fnCheckDBVers() {
  echo "Checking DB Version"
  export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
echo "SQLCONN is -> $SQLCONN"
sqlplus -S ${DB_USER}/${DB_USER}@$SQLCONN <<!
set heading off;
set feedback off;
define DB_USER='$DB_USER'
set verify off
@/opt/build/scripts/check_dbversions.sql
exit sql.sqlcode
!
  STATUS=${?}
  if [[ ${STATUS} != "0" ]]; then
   echo "Schema creation failed"
   exit ${STATUS}
  fi
  echo "$Deployed_VERSION" >>Version.in
  cd /opt/cvbuild/wa/DB_Extracts/${BUILD_TAG}
  tr -d '\n' <Version.in >Version.out
  Deployed_VERSION=`cat Version.out`
  echo "$Deployed_VERSION"
}

#Database Configuration settings
fnDBConf() {
# Notes:  sqlplus uses the SERVICE_NAME and the SIDTarg.  Liquibase uses the JDBC_URL and wants a SID not SERVICE
#    export SIDTarg="PERF1"
#    export DBIP="208.54.248.212"
#    export JDBC_URL="jdbc:oracle:thin:@208.54.248.212:1522:PERF1"
    export SIDTarg="bucket"
    export DBIP="perf-rac-scan.cv.perf"
#    export DBIP="pfdbrac01-vip.cv.perf"
    export JDBC_URL="jdbc:oracle:thin:@pfdbrac01.cv.perf:1522:PERF1"
#    export JDBC_URL="jdbc:oracle:thin:@pfdbrac01-vip.cv.perf:1522:PERF1"
}

#Check for DB version update, rebuild and rollback conditions.   Drop and recreate the user if rebuild
fnDB_Rebuild() {
    if [[ ${DB_Rebuild} = "No" ]]; then
#     Compcheck=`./compareVersions.sh -n $Version -o $Deployed_Version`
     if [[ $Compcheck = "-1" ]]; then
       echo "------------------------------------------------------"
       echo "Rebuild required to roll back to previous DB Version!"
       echo "------------------------------------------------------"
       echo "Please retry with DB rebuild!"
       exit 1
     fi
    fi
    if [[ ${DB_Rebuild} = "Yes" ]] ; then
     cd /opt/build/scripts/zayo_perf
     export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
echo "SQLCONN is -> $SQLCONN"
sqlplus -S cm_system/Perf0ra@$SQLCONN <<!
set heading off
define DeployTarg='${DB_USER}'
set verify off
@dropUser.${DB_USER}.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema drop failed"
        exit ${STATUS}
      fi
sqlplus -S cm_system/Perf0ra@$SQLCONN <<!
set heading off
set verify off
@genUser.${DB_USER}.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema creation failed"
        exit ${STATUS}
      fi
    fi
}

fnUpdDB() {
    executeCommand "cp /opt/build/scripts/liquibase.jar ${WORKING_DIR}/liquibase"
    executeCommand "cp /opt/build/scripts/ojdbc6.jar ${WORKING_DIR}/liquibase"
    executeCommand "cp /opt/build/scripts/liquibase-oracle-1.2.0.jar ${WORKING_DIR}/liquibase"
    LIQUIBASE_BASE_CMD="java -jar -Djava.security.egd=file:/dev/../dev/urandom liquibase.jar --logLevel=info --driver=oracle.jdbc.driver.OracleDriver"
    LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=${JDBC_URL}"
    #LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=\"${JDBC_URL}\""
    LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --username=${DB_USER} --password=${DB_PASS} --classpath=./ojdbc6.jar:./liquibase-oracle-1.2.0.jar"
    LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --changeLogFile=master-changelog.xml"
    LIQUIBASE_UPD_CMD="${LIQUIBASE_BASE_CMD} update ${LiqBaOPTS}" 
    echo "Updating database"
    echo "${LIQUIBASE_BASE_CMD} releaseLocks"
    echo "${LIQUIBASE_UPD_CMD}"
    echo "${LIQUIBASE_BASE_CMD} tag ${VERSION}"
    cd ${WORKING_DIR}/liquibase
    executeCommand "${LIQUIBASE_BASE_CMD} releaseLocks"
    executeCommand "${LIQUIBASE_UPD_CMD}" && executeCommand "${LIQUIBASE_BASE_CMD} tag ${VERSION}"
# Following lines are the above liquibase command with the double ampersand removed for testing
#    executeCommand "${LIQUIBASE_UPD_CMD}"
#    executeCommand "${LIQUIBASE_BASE_CMD} tag ${VERSION}"
    executeCommandNoFail "rm *changelog*.*"
    executeCommandNoFail "rm -fR version_changelogs"
    executeCommandNoFail "rm -fR ${WORKING_DIR}"
}


#Base Application server setup related variables.
fnBaseAppSet() {
  export APPSERVER_BASE="/opt/tcserver/instances/${INSTANCE}" ; echo "APPSERVER_BASE=${APPSERVER_BASE}"
  export APPSERVER_BIN="${APPSERVER_BASE}/bin" ; echo "APPSERVER_BIN=${APPSERVER_BIN}"
  export SSH_BASE="ssh tcserver@${APPSERVER_IP}" ; echo "SSH_BASE=${SSH_BASE}"
  export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:${APPSERVER_BIN}/." ; echo "SSH_CP_BIN_DIR=${SSH_CP_BIN_DIR}"
  export WORKING_DIR="/opt/tcserver/App_Files" ; echo "WORKING_DIR=${WORKING_DIR}"
  export SCP_BASE="tcserver@${APPSERVER_IP}" ; echo "SCP_BASE=${SCP_BASE}"
}

#Base Application server setup related variables for jar components.
fnBaseJarAppSet() {
  export TAR="${Component}_${VERSION}"
  export WORKING_DIR="/opt/tcserver/App_Files" ; echo "WORKING_DIR=${WORKING_DIR}"
  export CP_BIN_DIR="tcserver@${APPSERVER_IP}:/var/tmp" ; echo "CP_BIN_DIR=${CP_BIN_DIR}"
  export SSH_BASE="ssh tcserver@${APPSERVER_IP}" ; echo "SSH_BASE=${SSH_BASE}"
  export APPSERVER_BASE=${APPSERVER_BASE-/var/tmp} ; echo "APPSERVER_BASE=${APPSERVER_BASE}"
  export APPSERVER_BIN="${APPSERVER_BASE}" ; echo "APPSERVER_BIN=${APPSERVER_BIN}"
  export ARCHIVE="${Component}_${VERSION}.tar" ; echo "ARCHIVE=${ARCHIVE}"
  export SCP_BASE="tcserver@${APPSERVER_IP}" ; echo "SCP_BASE=${SCP_BASE}"
}

fnRetDB() {
  export WORKING_DIR="/tmp/deploymentWorkArea/${Component}/${VERSION}"
  if [ -d ${WORKING_DIR} ] ; then
   executeCommand "rm -rf ${WORKING_DIR}"
  fi
  executeCommand "mkdir -p ${WORKING_DIR}"
  export ARCHIVE="${Component}_${VERSION}.tar"
  executeCommand "scp cvbuild@cvbuild.cv.infra:/opt/build/releaseTars/${Component}/${ARCHIVE} ${WORKING_DIR}"
  cd ${WORKING_DIR}
  executeCommand "tar xf ${ARCHIVE}"
}

#Deliver Application function
fnSendApp() {
  export ARCHIVE="${Component}_${VERSION}.tar" ; echo "ARCHIVE=${ARCHIVE}"
  executeCommand "scp cvbuild@cvbuild.cv.infra:/opt/build/releaseTars/${Component}/${ARCHIVE} ${SCP_BASE}:/${WORKING_DIR}"
}

#Copy jar to location.
fnCpyJarScpts() {
  cd /opt/build/scripts/zayo_perf
  executeCommand "scp deployJar.sh ${CP_BIN_DIR}"
}

#Copy scripts to remote application server.
fnCpyScpts() {
  cd /opt/build/scripts/zayo_perf
  executeCommand "scp stop.sh ${SSH_CP_BIN_DIR}"
  executeCommand "scp deployWar.sh ${SSH_CP_BIN_DIR}"
}

# Stop the application server
fnStopApp() {
  ${SSH_BASE} ${APPSERVER_BIN}/stop.sh -a ${INSTANCE}
}

fnAssignInfo() {
# Function to assign the variables used in deployment to the info parsed from the system array in fnZayos_Sys
  export APPSERVER_IP="$(echo ${inar[$k]} | cut -f1 -d:)"
  export INSTANCE="$(echo ${inar[$k]} | cut -f2 -d:)"
  export WEBAPPS="$(echo ${inar[$k]} | cut -f3 -d:)"
  export APP="$(echo ${inar[$k]} | cut -f4 -d:)"
  export DB_USER="$(echo ${inar[$k]} | cut -f5 -d:)"
  export DB_PASS="$(echo ${inar[$k]} | cut -f6 -d:)"
  export LiqBaOPTS="$(echo ${inar[$k]} | cut -f7 -d:)"
}

fnMicroDevSet() {
  export TAR="MicroDev_${VERSION}" ; echo "TAR=${TAR}"
  export SSH_BASE="ssh mstradmin@${APPSERVER_IP}"
  export SSH_BASE_t="ssh mstradmin@${APPSERVER_IP} -t"
  export SCP_BASE="mstradmin@${APPSERVER_IP}" ; echo "SCP_BASE=${SCP_BASE}"
  export WORKING_DIR="/tmp/deploymentWorkArea/${Component}/${VERSION}" ; echo "WORKING_DIR=${WORKING_DIR}"
  export UNDO="${WORKING_DIR}/undopackage_${VERSION}"
  export PACKAGE="${WORKING_DIR}/MicroDev.mmp"
  export SSH_CP_BIN_DIR="mstradmin@${APPSERVER_IP}:/tmp/deploymentWorkArea"

#  export JARCPCMD="\"cd ${WORKING_DIR}; /opt/Microstrategy/MicroStrategy/bin/mstrcmdmgr -n SCRUM -u Administrator -p test_1234 -f /tmp/deploymentWorkArea/${TAR}/${VERSION}/mstrcmdmgr.scp -o ${WORKING_DIR}/${VERSION}.log && unix2dos ${WORKING_DIR}/${VERSION}.log && cat ${WORKING_DIR}/${VERSION}.log\""

  export JARCPCMD="cd ${WORKING_DIR}; /opt/Microstrategy/MicroStrategy/bin/mstrcmdmgr -n ${MSDSN} -u $MSDBUSR -p $MSDBPWD -f ${WORKING_DIR}/mstrcmdmgr.scp -o ${WORKING_DIR}/${VERSION}.log -showoutput -i -e"

#  export JARCPCMD="\"cd ${WORKING_DIR}; /opt/Microstrategy/MicroStrategy/bin/mstrcmdmgr -n ${MSDSN} -u $MSDBUSR -p $MSDBPWD -f ${WORKING_DIR}/mstrcmdmgr.scp -o ${WORKING_DIR}/${VERSION}.log -showoutput -i -e\""
  export CATLOG="\"cat ${WORKING_DIR}/${VERSION}.log\""
}

fnMDDirCreate() {
  ${SSH_BASE} "rm -rf ${WORKING_DIR}"
  ${SSH_BASE} "mkdir -p ${WORKING_DIR}"
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
  echo "/tmp/mstrcmdmgr.scp contents"
  cat /tmp/mstrcmdmgr.scp
}

fnSendMDApp() {
  export ARCHIVE="MicroDev_${VERSION}.tar" ; echo "ARCHIVE=${ARCHIVE}"
  executeCommand "scp cvbuild@cvbuild.cv.infra:/opt/build/releaseTars/MicroDev/${ARCHIVE} ${SCP_BASE}:${WORKING_DIR}"
}

fnSendMstCmdMgr(){
  # ${SSH_BASE} "cd /tmp/deploymentWorkArea; mkdir ${Component}; mkdir ${Component}/${VERSION}"
  executeCommand "scp /tmp/mstrcmdmgr.scp ${SSH_CP_BIN_DIR}/${Component}/${VERSION}/mstrcmdmgr.scp"
}

fnDepMD(){
  ${SSH_BASE} "cd ${WORKING_DIR} ; tar -xvf MicroDev_${VERSION}.tar"
  executeCommand "${SSH_BASE} ${JARCPCMD}"
#  executeCommand "${SSH_BASE} ${CATLOG}"
}

fnStopDepApp() {

for Comp in $DependApps; do
 export k=0 
 fnZayos_Sys $Comp
 for i in ${inar[@]}; do
    export System="$(echo ${inar[$k]} | cut -f1 -d:)"
    export Instance="$(echo ${inar[$k]} | cut -f2 -d:)"
    export Webapps="$(echo ${inar[$k]} | cut -f3 -d:)"

  if [[ $Comp = dai-cip || $Comp = acp ]]; then
    echo "(Not) Stopping processes on System-> $System   Instance->$Instance"
#    ssh tcserver@$System "cd $Instance; ./launcher.sh stop"
    k=$((k+1))

  else
    echo "(Not) Stopping Dependent tcerver processes DepApp->$Comp  System-> $System   Instance->$Instance  Webapps->$Webapps"
#    /opt/build/scripts/tcServerAdmin.sh ${System} ${Instance} status
    k=$((k+1))

  fi
 done
done
}

fnStartDepApp() {

for Comp in $DependApps; do
 export k=0
 fnZayos_Sys $Comp
 for i in ${inar[@]}; do
    export System="$(echo ${inar[$k]} | cut -f1 -d:)"
    export Instance="$(echo ${inar[$k]} | cut -f2 -d:)"
    export Webapps="$(echo ${inar[$k]} | cut -f3 -d:)"

  if [[ $Comp = acp ]]; then
    echo "(Not) Starting processes on System-> $System   Instance->$Instance"
#    ssh tcserver@$System "cd $Instance; ./launcher.sh stop"
    k=$((k+1))

  else
    echo "(Not) Starting Dependent tcerver processes DepApp->$Comp   System-> $System   Instance->$Instance  Webapps->$Webapps"
#    /opt/build/scripts/tcServerAdmin.sh ${System} ${Instance} status
    k=$((k+1))

  fi
 done
done
}


# Deploy the war to the app server.
fnDepWar() {
  executeCommand "${SSH_BASE} ${APPSERVER_BIN}/deployWar.sh -a ${APP} -t ${Component} -r ${VERSION} -i ${INSTANCE} -w ${WEBAPPS} -e ${APPSERVER_IP} -v"
}

fnDepJar() {
 executeCommand "${SSH_BASE} ${APPSERVER_BIN}/deployJar.sh -a ${APP} -t ${Component} -r ${VERSION} -e ${APPSERVER_IP} -j ${JarDirect} -k ${JarName1} -m ${JarLoc1} -v"
}

# clean up
fnCleanup() {
  executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/stop.sh"
  executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/deployWar.sh"
}

fnJarCln() {
  executeCommand "${SSH_BASE} rm ${CP_BIN_DIR}/deployJar.sh"
}

# Report Performance VERSION info
fnRptVer() {
  ssh cvbuild@cvbuild.cv.infra "echo \"${VERSION}\" > /var/www/html/zayo_perf/${Component}.txt"
  ssh cvbuild@cvbuild.cv.infra "date | awk '{print \$2,\$3,\$4}' > /var/www/html/zayo_perf/${Component}.instdate.txt"
}

######################################################################
#                 End of Utility Functions of script
######################################################################

######################################################################
#                   Begin Deployment Function calls 
######################################################################
# When testing, use as modular sequential functions.
# fnVERSIONCheck- Check the existing deployed version 
# fnBaseAppSet  - Base Application server, workarea setup related variables.
# fnSendApp     - Deliver Application to target Workarea (App_Files)
# fnCpyScpts    - Deliver deployWar.sh and stop.sh to target instance bindir
# fnStopApp     - Stop the target application server
# fnDepWar      - Run the deployWar.sh script on target server
# fnCleanup     - Clean up any delivered scripts, temporary files
# fnRptVer      - Report version of deployment

fnDeployApp() {
  fnVERSIONCheck
  fnBaseAppSet
  fnSendApp 
  fnCpyScpts
  fnStopApp
  fnDepWar
#  fnCleanup
  fnRptVer
  fnPostToSlack
}

fnDeployJar() {
#  fnJarVERSIONCheck
  fnBaseJarAppSet
  fnSendApp
  fnCpyJarScpts
  fnDepJar
#  fnJarCln
  fnRptVer
  fnPostToSlack
}
fnDeployDB() {
#  Deployed_VERSION=`fnCheckDBVers`
  fnDBConf
  fnDB_Rebuild
  fnRetDB
  echo "Hostname=`hostname`"
  traceroute pfdbrac01.cv.perf
  fnUpdDB
  fnRptVer
}

fnDeployMD() {
  fnBaseJarAppSet
  fnMicroDevSet
  fnMDDirCreate
  fnBuildMstrCmdMgr
  fnSendMDApp
  fnSendMstCmdMgr
  fnDepMD
#  fnMDCln
  fnPostToSlack
}

######################################################################
#                End Deployment Functions of script
######################################################################

######################################################################
#                Components and Systems Definitions 
######################################################################

case $Component in
# -Dynamic-Ad-Insertion-engine
#  Uses the new array assignment method .vs. case logic
 Dynamic-Ad-Insertion-engine)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -Dynamic-Ad-Insertion-cm
#  Uses the new array assignment method .vs. case logic
    Dynamic-Ad-Insertion-cm)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -smsi-msp-relay
#  Uses the new array assignment method .vs. case logic
    smsi-msp-relay)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -DMP Config
#  Uses the new array assignment method .vs. case logic
    dmp-config)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -Mock Server
#  Uses the new array assignment method .vs. case logic
    int-test-support)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# ad-load-manager-
#  Uses the new array assignment method .vs. case logic
    ad-load-manager)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS LiqBaOPTS=$LiqBaOPTS"
        if test "$DB_USER"; then
         fnDeployDB
        fi
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# dai-dce-
#  Uses the new array assignment method .vs. case logic
    dai-dce)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS LiqBaOPTS=$LiqBaOPTS"
        if test "$DB_USER"; then
         fnDeployDB
        fi
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -Pgmr-Cpgn-Int
#  Uses the new array assignment method .vs. case logic
    Pgmr-Cpgn-Int)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS LiqBaOPTS=$LiqBaOPTS"
        if test "$DB_USER"; then
         fnDeployDB
        fi
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -dai-smsi
#  Uses the new array assignment method .vs. case logic
    dai-smsi)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -smsiCorrection
#  Uses the new array assignment method .vs. case logic
    smsiCorrection)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -SDC-session-collector
#  Uses the new array assignment method .vs. case logic
    SDC-session-collector)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -smsi-publisher
#  Uses the new array assignment method .vs. case logic
    smsi-publisher)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS LiqBaOPTS=$LiqBaOPTS"
        if test "$DB_USER"; then
         fnDeployDB
        fi
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -rema-publisher
#  Uses a custom system definition due to it's temporary nature.  Will eventually be converted to the smsi-publisher section
    rema-publisher)
       export Comp=smsi-publisher
       export Component=smsi-publisher
       fnInitRpt
       export k=0
       inar[0]=cv-pfsmsi_pub01.cv.perf:PF_REMAPUB_01:smsi-pub:smsi-publisher:REMA_PUB:REMA_PUB
       inar[1]=cv-pfsmsi_pub02.cv.perf:PF_REMAPUB_02:smsi-pub:smsi-publisher
       inar[2]=cv-pfsmsi_pub03.cv.perf:PF_REMAPUB_03:smsi-pub:smsi-publisher
       inar[3]=cv-pfsmsi_pub04.cv.perf:PF_REMAPUB_04:smsi-pub:smsi-publisher
       inar[4]=cv-pfsmsi-pub05.cv.perf:PF_REMAPUB_05:smsi-pub:smsi-publisher
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS LiqBaOPTS=$LiqBaOPTS"
        if test "$DB_USER"; then
         echo "Building DB and Component -> $DB_USER  $DB_PASS  $Component"
         fnDeployDB
        fi
        fnDeployApp
        if [[ $APPSERVER_IP = "cv-pfsmsi_pub01.cv.perf" ]]; then
         fnStopApp
        fi
         k=$((k+1))
       done
       export Component=rema-publisher
       fnRptVer
       fnCompRpt
       ;;
# -dai-national-cis
#  Uses the new array assignment method .vs. case logic
    dai-national-cis)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS LiqBaOPTS=$LiqBaOPTS"
        if test "$DB_USER"; then
         fnDeployDB
        fi
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -metadata-publisher
#  Uses the new array assignment method .vs. case logic
    metadata-publisher)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -dai-smsi-relay
#  Uses the new array assignment method .vs. case logic
    dai-smsi-relay)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS LiqBaOPTS=$LiqBaOPTS"
        if test "$DB_USER"; then
         fnDeployDB
         unset DB_USER
        fi
         echo "$DB_USER"
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -ADI-MDI
#  Uses the new array assignment method .vs. case logic
    ADI-MDI)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS LiqBaOPTS=$LiqBaOPTS"
        if test "$DB_USER"; then
         fnDeployDB
         unset DB_USER
        fi
         echo "$DB_USER"
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -dai-cip-feedback
# Uses the new array assignment method .vs. case logic
    dai-cip-feedback)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS"
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# request-mgr
#  Uses the new array assignment method .vs. case logic
    request-mgr)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS"
        if test "$DB_USER"; then
        echo "(Not) Deploying DB for $DB_USER"
        fnDeployDB
        fi
        fnDeployApp
        fnStopApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -acp
    acp)
       fnInitRpt
       export APP=$Component
       export APPSERVER_IP="cv-pfcluster02.cv.perf"
       export JarDirect="pf_acp"
       export JarLoc1="bin"
       export JarName1="acp"
       echo "$APP $JarDirect $JarLoc1 $JarName1 $APPSERVER_IP"
       fnDeployJar
       fnCompRpt
      ;;
# -dai-cip
    dai-cip)
       fnInitRpt
       export APP=$Component
       export APPSERVER_IP="cv-pfcluster03.cv.perf"
       export JarDirect="pf_dai_cip"
       export JarLoc1="bin"
       export JarName1="dai-cip"
       echo "$APP $JarDirect $JarLoc1 $JarName1 $APPSERVER_IP"
       fnDeployJar
       fnCompRpt
      ;;
# -Sheringham
    Sheringham)
       fnInitRpt
       export APP=$Component
       export JarDirect="pf_Sheringham"
       export JarLoc1="bin"
       export JarName1="sheringham-server"
       export APPSERVER_IP="cv-pfshrham01.cv.perf"
       echo "$APP $JarDirect $JarLoc1 $JarName1 $APPSERVER_IP"
       fnDeployJar
       export APPSERVER_IP="cv-pfshrham02.cv.perf"
       echo "$APP $JarDirect $JarLoc1 $JarName1 $APPSERVER_IP"
       fnDeployJar
       fnCompRpt
      ;;
# -MicroDev
    MicroDev)
     export k=0
     export Comp=$Component
     source /opt/build/scripts/zayos_sys_Perf.sh
     fnInitRpt
     for i in ${inar[@]}; do
      fnDeployMD
       echo "APPSERVER_IP-> $APPSERVER_IP MSDSN-> $MSDSN  MSDBUSR-> $MSDBUSR MSDBPWD-> $MSDBPWD"
      k=$((k+1))
     done
     fnCompRpt
   ;;

# POIS-
#  Uses the new array assignment method .vs. case logic
    POIS)
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       fnInitRpt
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS"
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -impression_collector
#  Uses the new array assignment method .vs. case logic
    impression_collector)
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
       fnInitRpt
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS"
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -caas-core
   caas-core)
     export DependApps="acp dai-cip-feedback ad-load-manager dai-smsi-relay smsi-msp-relay dai-smsi dai-cip Dynamic-Ad-Insertion-cm metadata-publisher Pgmr-Cpgn-Int dai-national-cis"
     export DependJars="dai-cip acp"
     export DB_USER="CAAS_CORE"
     export DB_PASS="CAAS_CORE"
     export LiqBaOPTS="-DADS_SCHEMA_NAME=ADS_CORE_MS01"
     fnInitRpt
     echo "LiqBaOPTS=$LiqBaOPTS"
     fnDeployDB
     cd /opt/build/scripts/zayo_perf
     echo "Building Triggers in metadata-sync"
     export ADS_USER="ADS_CORE_MSO1,ADS_CORE_MSO2,ADS_CORE_MSO3"
     export CAAS_USER="CAAS_CORE"
#     export Trig_Version=`ssh cvbuild@cvbuild.cv.infra \"cat /opt/build/releaseTars/metadata-sync/latest\"`
     export Trig_Version="1.0.0_11"
     export TRIGWORKING_DIR="/tmp/deploymentWorkArea/metadata-sync/${Trig_Version}"
     echo "Triggers Vers - ${Trig_Version} ADS User - ${ADS_USER}  CAAS User - ${CAAS_USER}"
      if [ -d ${TRIGWORKING_DIR} ] ; then
       executeCommand "rm -rf ${TRIGWORKING_DIR}"
      fi
     executeCommand "mkdir -p ${TRIGWORKING_DIR}"
     cd ${TRIGWORKING_DIR}
     export ARCHIVE="metadata-sync_${Trig_Version}.tar"
     executeCommand "scp cvbuild@cvbuild.cv.infra://opt/build/archives/metadata-sync/${ARCHIVE} ."
     executeCommand "tar xf ${ARCHIVE}"
     echo "Running ./install.sh ${ADS_USER} ${CAAS_USER} against $DBIP 1522 $SIDTarg"
     chmod +x install.sh
     ./install.sh ${ADS_USER} ${CAAS_USER} cm_system Perf0ra $DBIP 1522 $SIDTarg
     fnCompRpt
     fnPostToSlack
   ;;
# -ads-core
   ads-core)
     export DependApps="Dynamic-Ad-Insertion-engine"
     export adsCoreDB="adscore1 adscore2 adscore3"
     fnInitRpt
#     fnStopDepApp
     for i in $adsCoreDB; do
       case $i in
        adscore1)
         export DB_USER="ADS_CORE_MSO1"
         export DB_PASS="ADS_CORE_MSO1"
        ;;
        adscore2)
         export DB_USER="ADS_CORE_MSO2"
         export DB_PASS="ADS_CORE_MSO2"
        ;;
        adscore3)
         export DB_USER="ADS_CORE_MSO3"
         export DB_PASS="ADS_CORE_MSO3"
        ;;
       esac 
     export LiqBaOPTS="-DCAAS_SCHEMA_NAME=CAAS_CORE -Denvironment=prod"
     echo "LiqBaOPTS=$LiqBaOPTS"
     fnDeployDB
     done
#     fnStartDepApp
     fnCompRpt
     fnPostToSlack
   ;;
# -dai-etl-feeder
   dai-etl-feeder)
     export DependApps="dai-smsi dai-smsi-relay"
#     fnStopDepApp
     export etlDB="etl1 etl2"
     for i in $etlDB; do
       case $i in
        etl1)
         export DB_USER="DAI_REPORTING_SAFI"
         export DB_PASS="DAI_REPORTING_SAFI"
        ;;
        etl2)
         export DB_USER="REMA_REPORTING_SAFI"
         export DB_PASS="REMA_REPORTING_SAFI"
        ;;
       esac
     export LiqBaOPTS="-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE -DBAR_SCHEMA_NAME=OSS_BAR -DBILLING_SCHEMA_NAME=DAI_BILLING -DREPORTING_SCHEMA_NAME=${DB_USER}"
     echo "LiqBaOPTS=$LiqBaOPTS"
     fnDeployDB
#     fnStartDepApp
     done
     fnCompRpt
     fnPostToSlack
   ;;
# -smsi_reporting
   smsi_reporting)
     fnInitRpt
     export DependApps="dai-smsi dai-smsi-relay"
#     fnStopDepApp
     export DB_USER="SMSI_REPORTING"
     export DB_PASS="SMSI_REPORTING"
     export LiqBaOPTS="-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE -DINGEST_SCHEMA_NAME=DAI_REPORTING_SAFI"
     echo "LiqBaOPTS=$LiqBaOPTS"
     fnDeployDB
#     fnStartDepApp
     fnCompRpt
     fnPostToSlack
   ;;
   bogus_app)
#     export DependApps="dai-cip acp"
#     export DependApps="dai-cip-feedback ad-load-manager dai-smsi-relay dai-smsi Dynamic-Ad-Insertion-cm metadata-publisher Pgmr-Cpgn-Int dai-national-cis"
    echo "Bogus App - just an echo"
#     fnStopDepApp
#     fnStartDepApp
      fnPostToSlack
   ;; 
   *)
    echo "No Deploy...";;
esac
