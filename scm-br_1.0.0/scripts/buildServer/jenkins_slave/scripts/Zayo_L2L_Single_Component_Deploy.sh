#!/bin/bash 
#
# Zayo_L2L_Single_Component_Deploy.sh
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
cd /opt/build/scripts/zayo_L2L

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
echo "<b>Deployment to ${Suite} by ${DeployUser} </b><br>" >> /tmp/${BUILD_TAG}.log
echo "<b>Component: </b>${Component} <br>" >> /tmp/${BUILD_TAG}.log
echo "<b>&nbsp<u> Upgrading ${Component}</u> :</b><br>" >> /tmp/${BUILD_TAG}.log
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

fnCheckDBVers() {
  echo "Checking DB Version"
  export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1521)))(CONNECT_DATA=(SID=${SIDTarg})))"
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
     cd /opt/build/scripts/zayo_L2L
     export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1521)))(CONNECT_DATA=(SID=${SIDTarg})))"

if [[ ${Component} = "caas-core" ]]; then
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off;
set feedback on;
set echo on;
define DB_USER='$DB_USER'
set verify on
set serveroutput on
@/opt/build/scripts/zayo_L2L/drop_flshbk.sql $DB_USER
exit
!
fi

sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
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
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
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
  cd ${WORKING_DIR}
  export ARCHIVE="${Component}_${VERSION}.tar"
  executeCommand "scp cvbuild@cvbuild.cv.infra:/opt/build/releaseTars/${Component}/${ARCHIVE} ${WORKING_DIR}"
  cd ${WORKING_DIR}
  executeCommand "tar xf ${ARCHIVE}"
}

#Trigger setup for CAAS-Core
fnMetaTrigger() {
   Trig_Version=`ssh cvbuild@cvbuild.cv.infra \"cat /opt/build/releaseTars/metadata-sync/latest\"`
   cd /opt/build/scripts/zayo_L2L
       echo "Building Triggers in metadata-sync"
       case $Suite in
         Base)
          export ADS_USER="ADS_CORE_TWC,ADS_CORE_COM"
          export CAAS_USER="CAAS40"
          ;;
         FW)
         export ADS_USER="ADS_CORE_FW"
         export CAAS_USER="CAAS_CORE_FW"
          ;;
         Google)
         export ADS_USER="ADS_CORE_TWC_L"
         export CAAS_USER="CAAS_LOCAL"
          ;;
         Cox)
         export ADS_USER="ADS_CORE_COX"
         export CAAS_USER="CAAS_CORE_COX"
          ;;
         Broadway)
         export ADS_USER="ADS_CORE_BRD"
         export CAAS_USER="CAAS_CORE_BRD"
        ;;
         Rentrak)
         export ADS_USER="ADS_CORE_RTK"
         export CAAS_USER="CAAS_CORE_RTK"
          ;;
       esac
    
       export TRIGWORKING_DIR="/tmp/deploymentWorkArea/metadata-sync/${Trig_Version}"
       echo "APP - ${APP} TAR - ${TAR}  Vers - ${VERSION} ADS User - ${ADS_USER}  CAAS User - ${CAAS_USER}"
        if [ -d ${TRIGWORKING_DIR} ] ; then
         executeCommand "rm -rf ${TRIGWORKING_DIR}"
        fi
       executeCommand "mkdir -p ${TRIGWORKING_DIR}"
       cd ${TRIGWORKING_DIR}
       export ARCHIVE="metadata-sync_${Trig_Version}.tar"
       executeCommand "scp cvbuild@cvbuild.cv.infra://opt/build/archives/metadata-sync/${ARCHIVE} .; tar xf ${ARCHIVE}"
       echo "Running ./install.sh ${ADS_USER} ${CAAS_USER} against dbrac03.cv.dr pro001"
       chmod +x install.sh
       ./install.sh ${ADS_USER} ${CAAS_USER} cm_system L2L0ra dbrac03.cv.dr 1521 pro001
}

#Deliver Application function
fnSendApp() {
  export ARCHIVE="${Component}_${VERSION}.tar" ; echo "ARCHIVE=${ARCHIVE}"
#  executeCommand "scp /opt/build/releaseTars/${Component}/${ARCHIVE} ${SCP_BASE}:/${WORKING_DIR}"
  executeCommand "scp cvbuild@cvbuild.cv.infra:/opt/build/releaseTars/${Component}/${ARCHIVE} ${SCP_BASE}:/${WORKING_DIR}"
}

#Copy jar to location.
fnCpyJarScpts() {
  cd /opt/build/scripts/zayo_L2L
  executeCommand "scp deployJar.sh ${CP_BIN_DIR}"
}

#Copy scripts to remote application server.
fnCpyScpts() {
  cd /opt/build/scripts/zayo_L2L
  executeCommand "scp stop.sh ${SSH_CP_BIN_DIR}"
  executeCommand "scp deployWar.sh ${SSH_CP_BIN_DIR}"
}

# Stop the application server
fnStopApp() {
  ${SSH_BASE} ${APPSERVER_BIN}/stop.sh -a ${INSTANCE}
}

#fnAssignInfo() {
## Function to assign the variables used in deployment to the info parsed from the system array in fnZayos_Sys
#  export Suite="$(echo ${inar[$k]} | cut -f1 -d:)"
#  export APPSERVER_IP="$(echo ${inar[$k]} | cut -f2 -d:)"
#  export INSTANCE="$(echo ${inar[$k]} | cut -f3 -d:)"
#  export WEBAPPS="$(echo ${inar[$k]} | cut -f4 -d:)"
#  export APP="$(echo ${inar[$k]} | cut -f5 -d:)"
#  export DB_USER="$(echo ${inar[$k]} | cut -f6 -d:)"
#  export DB_PASS="$(echo ${inar[$k]} | cut -f7 -d:)"
#  export LiqBaOPTS="$(echo ${inar[$k]} | cut -f8 -d:)"
#}

fnStopDepApp() {
 export Comp=$Component
 source /opt/build/scripts/zayos_sys_L2L.sh
 fnZayos_Sys
 echo "Component-> $Component ; DependApps-> $DependApps"
for Comp in $DependApps; do
 export k=0
 source /opt/build/scripts/zayos_sys_L2L.sh
 fnZayos_Sys
 for i in ${inar[@]}; do
    export System="$(echo ${inar[$k]} | cut -f2 -d:)"
    export Instance="$(echo ${inar[$k]} | cut -f3 -d:)"
    export Webapps="$(echo ${inar[$k]} | cut -f4 -d:)"

  if [[ $Comp = dai-cip || $Comp = acp || $Comp = dai-metadata-ingestion ]]; then
    echo "Stopping processes on System-> $System   Instance->$Instance"
    ssh tcserver@$System "cd $Instance; ./launcher.sh stop"
    k=$((k+1))

  else

     if /opt/build/scm/scripts/buildServer/groovy/bin/tcServerAdmin.sh ${System} ${Instance} status | grep "NOT" ;
      then
      echo "Instance not running no shut down necessary"
     else
      echo "Stopping Dependent tcerver processes DepApp->$Comp  System-> $System   Instance->$Instance  Webapps->$Webapps"
      /opt/build/scripts/tcServerAdmin.sh ${System} ${Instance} stop
      k=$((k+1))
      export RestApps="$RestApps $Comp"
      echo "Apps to be Restarted -> $RestApps"
     fi
  fi
 done
done
}

fnStartDepApp() {

for Comp in $RestApps; do
 echo "Restarting $RestApps"
 export k=0
 source /opt/build/scripts/zayos_sys_L2L.sh
 fnZayos_Sys
 for i in ${inar[@]}; do
    export System="$(echo ${inar[$k]} | cut -f2 -d:)"
    export Instance="$(echo ${inar[$k]} | cut -f3 -d:)"
    export Webapps="$(echo ${inar[$k]} | cut -f4 -d:)"

  if [[ $Comp = dai-cip || $Comp = acp || $Comp = dai-metadata-ingestion ]]; then
    echo "(Not) Starting $Comp processes on System-> $System   Instance->$Instance"
    k=$((k+1))
  else
    echo "Starting Dependent tcerver processes DepApp->$Comp   System-> $System   Instance->$Instance  Webapps->$Webapps"
    /opt/build/scripts/tcServerAdmin.sh ${System} ${Instance} start
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

# Report Lab-to-Lab VERSION info
fnRptVer() {
  ssh cvbuild@cvbuild.cv.infra "echo \"${VERSION}\" > /var/www/html/lab2lab/${Suite}/${Component}.txt"
  ssh cvbuild@cvbuild.cv.infra "date | awk '{print \$2,\$3,\$4}' > /var/www/html/lab2lab/${Suite}/${Component}.instdate.txt"
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
}

fnDeployJar() {
#  fnJarVERSIONCheck
  fnBaseJarAppSet
  fnSendApp
  fnCpyJarScpts
  fnDepJar
#  fnJarCln
  fnRptVer
}

fnDeployDB() {
#leave  Deployed_VERSION=`fnCheckDBVers`
  fnDB_Rebuild
  fnRetDB
  fnUpdDB
  fnRptVer
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
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       fnInitRpt
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
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
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
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       for i in ${inar[@]}; do
        fnAssignInfo
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
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       for i in ${inar[@]}; do
       fnAssignInfo
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
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       for i in ${inar[@]}; do
       fnAssignInfo
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
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
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
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
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
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       for i in ${inar[@]}; do
       fnAssignInfo
        if test "$DB_USER"; then
         fnDeployDB
        fi
        fnDeployApp
        unset ${DB_USER}
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -dai-national-cis
#  Uses the new array assignment method .vs. case logic
    dai-national-cis)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       for i in ${inar[@]}; do
       fnAssignInfo
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
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       for i in ${inar[@]}; do
       fnAssignInfo
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -dmp-config
#  Uses the new array assignment method .vs. case logic
    dmp-config)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       for i in ${inar[@]}; do
       fnAssignInfo
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
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       for i in ${inar[@]}; do
       fnAssignInfo
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
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       for i in ${inar[@]}; do
       fnAssignInfo
        if test "$DB_USER"; then
         fnDeployDB
        fi
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
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
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
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       for i in ${inar[@]}; do
        fnAssignInfo
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
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       for i in ${inar[@]}; do
        fnAssignInfo
        if test "$DB_USER"; then
         fnDeployDB
        fi
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -acp
    acp)
       fnInitRpt
       export APP=$Component
       export APPSERVER_IP="cv-l2lcmc-clstr4"
       export JarDirect="acp"
       export JarLoc1="bin"
       export JarName1="acp"
       fnDeployJar
      ;;
# -dai-cip
    dai-cip)
       export APP=$Component
       	case $Suite in
	 Base)
          export APPSERVER_IP="cv-l2lcmc-clstr1"
         ;;
         FW)
          export APPSERVER_IP="cv-l2lfw-clstr1"
         ;;
         Google)
          export APPSERVER_IP="cv-l2lggl-clstr1"
         ;;
         Cox)
          export APPSERVER_IP="cv-l2lcox-clstr1"
         ;;
         Broadway)
          export APPSERVER_IP="cv-l2lbrd-clstr1"
         ;;
         Rentrak)
          export APPSERVER_IP="cv-l2lrtk-clstr1"
         ;;
	esac
       fnInitRpt
       export JarDirect="dai_cip"
       export JarLoc1="bin"
       export JarName1="dai-cip"
       fnDeployJar
      ;;
    dai-metadata-ingestion)
       export APP=$Component
        case $Suite in
         Base)
          export APPSERVER_IP="cv-l2lcmc-clstr4"
         ;;
         FW)
          export APPSERVER_IP="cv-l2lfw-clstr4"
         ;;
         Google)
          export APPSERVER_IP="cv-l2lggl-clstr4"
         ;;
         Cox)
          export APPSERVER_IP="cv-l2lcox-clstr4"
         ;;
         Broadway)
          export APPSERVER_IP="cv-l2lbrd-clstr4"
         ;;
         Rentrak)
          export APPSERVER_IP="cv-l2lrtk-clstr4"
         ;;
        esac
       fnInitRpt
       export JarDirect="dai-metadata-ingestion"
       export JarLoc1="bin"
       export JarName1="ingester"
       fnDeployJar
      ;;
# POIS-
#  Uses the new array assignment method .vs. case logic
    POIS)
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       fnInitRpt
       for i in ${inar[@]}; do
        fnAssignInfo
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
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       fnInitRpt
       for i in ${inar[@]}; do
        fnAssignInfo
        fnDeployApp
        k=$((k+1))
       done
       fnCompRpt
       ;;
# -caas-core
   caas-core)
       fnStopDepApp
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       fnInitRpt
       while [[ $(echo ${inar[$k]} | cut -f1 -d:) = $Suite ]]; do
#       for i in ${inar[@]}; do
        echo "i = $i  k = $k"
        fnAssignInfo
        fnDeployDB
        k=$((k+1))
        fnMetaTrigger
       done
       fnCompRpt
       fnStartDepApp
   ;;
# -ads-core
   ads-core)
       export DependApps="Dynamic-Ad-Insertion-engine"
       fnStopDepApp
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       fnInitRpt
       while [[ $(echo ${inar[$k]} | cut -f1 -d:) = $Suite ]]; do
#       for i in ${inar[@]}; do
        echo "i = $i  k = $k"
        fnAssignInfo
        fnDeployDB
        k=$((k+1))
       done
       fnCompRpt
       fnStartDepApp
   ;;
# -dai-etl-feeder
   dai-etl-feeder)
     export DependApps="dai-smsi dai-smsi-relay"
#     fnStopDepApp
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       fnInitRpt
       while [[ $(echo ${inar[$k]} | cut -f1 -d:) = $Suite ]]; do
#       for i in ${inar[@]}; do
        fnAssignInfo
        fnDeployDB
        k=$((k+1))
       done
       fnCompRpt
   ;;
   bogus_app)
#     export DependApps="dai-cip acp"
#     export DependApps="dai-cip-feedback ad-load-manager dai-smsi-relay dai-smsi Dynamic-Ad-Insertion-cm metadata-publisher Pgmr-Cpgn-Int dai-national-cis"
     echo "Bogus App - just an echo"
       export k=0
       export Comp=ads-core
       source /opt/build/scripts/zayos_sys_L2L.sh
       fnZayos_Sys
       while [[ $(echo ${inar[$k]} | cut -f1 -d:) = $Suite ]]; do
        fnAssignInfo
        k=$((k+1))
       done
#     fnStopDepApp
#     fnStartDepApp
   ;; 
   *)
    echo "No Deploy...";;
esac
