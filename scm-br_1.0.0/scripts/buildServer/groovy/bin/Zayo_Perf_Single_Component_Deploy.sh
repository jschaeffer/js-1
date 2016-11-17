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
    print "<h2>User must supply a user name and summary of deploy purpose</h2>"
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
     print ERROR: Error executing $1
     exit 1
 fi
}

executeCommandNoFail() {
    echo "Executing : $1"
    RESULT=`eval "$1"`
    echo "Result : $RESULT"
}

fnInitRpt() { 
echo "<b>&nbsp<u> Upgrading ${Component}</u> :</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
}

fnVERSIONCheck() {
 Deployed_VERSION=`ssh tcserver@${APPSERVER_IP} "grep Implementation-VERSION /opt/tcserver/instances/${INSTANCE}/webapps/${WEBAPPS}/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
 echo "---------------------------------------------------------------------"
 echo "Upgrading ${Component} : in instance ${INSTANCE} to ${VERSION}"
 echo "---------------------------------------------------------------------"
 echo "<b>&nbsp ... on ${APPSERVER_IP}</b> in instance <b>${INSTANCE}</b> from <b>${Deployed_VERSION} to ${VERSION}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
}

fnJarVERSIONCheck() {
 Deployed_VERSION=`ssh tcserver@${APPSERVER_IP} "cd /var/tmp; jar xf /opt/tcserver/${JarDirect}/${JarLoc1}/${JarName1}.jar META-INF/MANIFEST.MF; grep Implementation-VERSION META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
 echo "---------------------------------------------------------------------"
 echo "Upgrading ${Component} : in instance ${JarDirect} to ${VERSION}"
 echo "---------------------------------------------------------------------"
 echo "<b>&nbsp ... on ${APPSERVER_IP}</b> in <b>${JarDirect}</b> from <b>${Deployed_VERSION} to ${VERSION}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
}

fnCheckDBVers() {
  echo "Checking DB Version"
  export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
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
    export DBIP="perf-rac-scan"
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
    LIQUIBASE_BASE_CMD="java -jar liquibase.jar --logLevel=info --driver=oracle.jdbc.driver.OracleDriver"
    LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=${JDBC_URL}"
    #LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --url=\"${JDBC_URL}\""
    LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --username=${DB_USER} --password=${DB_PASS} --classpath=./ojdbc6.jar:./liquibase-oracle-1.2.0.jar"
    LIQUIBASE_BASE_CMD="${LIQUIBASE_BASE_CMD} --changeLogFile=master-changelog.xml"
    LIQUIBASE_UPD_CMD="${LIQUIBASE_BASE_CMD} update -Djava.security.egd=file:///dev/urandom ${LiqBaOPTS}"
    echo "Updating database"
    echo "${LIQUIBASE_BASE_CMD} releaseLocks"
    echo "${LIQUIBASE_UPD_CMD}"
    echo "${LIQUIBASE_BASE_CMD} tag ${VERSION}"
    cd ${WORKING_DIR}/liquibase
    executeCommand "${LIQUIBASE_BASE_CMD} releaseLocks -Djava.security.egd=file:///dev/urandom"
    executeCommand "${LIQUIBASE_UPD_CMD}" && executeCommand "${LIQUIBASE_BASE_CMD} tag ${VERSION} -Djava.security.egd=file:///dev/urandom"
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
  executeCommand "cd ${WORKING_DIR}"
  export ARCHIVE="${Component}_${VERSION}.tar"
  executeCommand "tar xf /opt/build/archives/${Component}/${ARCHIVE}"
}

#Deliver Application function
fnSendApp() {
  export ARCHIVE="${Component}_${VERSION}.tar" ; echo "ARCHIVE=${ARCHIVE}"
  executeCommand "scp /opt/build/releaseTars/${Component}/${ARCHIVE} ${SCP_BASE}:/${WORKING_DIR}"
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

fnZayos_Sys() {
###########################
# Array of system info  
###########################
# Field description:
# #1 APPSERVER_IP
# #2 INSTANCE
# #3 WEBAPPS
# #4 APP
# #5 DB_USER
# #6 DB_PASS
# #7 LiqBaOPTS

case $Comp in
  Dynamic-Ad-Insertion-engine)
  inar[0]=cv-pfdec_eng01.cv.perf:PF_DECENG_01:ads:ads
  inar[1]=cv-pfdec_eng02.cv.perf:PF_DECENG_02:ads:ads
  inar[2]=cv-pfdec_eng03.cv.perf:PF_DECENG_03:ads-1.2.0:ads
  inar[3]=cv-pfdec_eng04.cv.perf:PF_DECENG_04:ads-1.2.0:ads
  inar[4]=cv-pfdec_eng05.cv.perf:PF_DECENG_05:ads:ads
  inar[5]=cv-pfdec_eng06.cv.perf:PF_DECENG_06:ads:ads
  inar[6]=cv-pfde_ciping01.cv.perf:PF_CIPING_01:ads:ads
  inar[7]=cv-pfde_ciping02.cv.perf:PF_CIPING_02:ads:ads
  inar[8]=cv-pfde_ciping03.cv.perf:PF_CIPING_03:ads-1.2.0:ads
  inar[9]=cv-pfde_ciping04.cv.perf:PF_CIPING_04:ads-1.2.0:ads
  inar[10]=cv-pfcluster01.cv.perf:PF_CIS_01:cis:cis
 ;;
 Dynamic-Ad-Insertion-cm)
  inar[0]=cv-pfcluster03.cv.perf:PF_CM_01:Dynamic-Ad-Insertion-cm:Dynamic-Ad-Insertion-cm
 ;;
 request-mgr)
  inar[0]=cv-pfrqman01.cv.perf:PF_REQMAN_01:request-manager:request-manager:REQMAN:REQMAN
  inar[1]=cv-pfrqman02.cv.perf:PF_REQMAN_02:request-manager:request-manager
  inar[2]=cv-pfrqman03.cv.perf:PF_REQMAN_03:request-manager:request-manager
  inar[3]=cv-pfrqman04.cv.perf:PF_REQMAN_04:request-manager:request-manager
  inar[4]=cv-pfrqman05.cv.perf:PF_REQMAN_05:request-manager:request-manager
 ;;
 dai-cip-feedback)
  inar[0]=cv-pfcip_feedbk01.cv.perf:PF_FBN_01:cip-feedback:cip-server
  inar[1]=cv-pfcip_feedbk02.cv.perf:PF_FBN_02:cip-feedback:cip-server
 ;;
 Pgmr-Cpgn-Int)
  inar[0]=cv-pfpci01.cv.perf:PF_PCI_01:pci:pci:PCI_PERF:PCI_PERF
  inar[1]=cv-pfpci02.cv.perf:PF_PCI_02:pci:pci
  inar[2]=cv-pfpci03.cv.perf:PF_PCI_03:pci:pci
 ;;
 metadata-publisher)
  inar[0]=cv-pfcluster02.cv.perf:PF_METAPUB_01:publisher:publisher
 ;;
 smsi-publisher)
  inar[0]=cv-pfsmsi_pub01.cv.perf:PF_SMSIPUB_01:smsi-pub:smsi-publisher:SMSI_PUB:SMSI_PUB
  inar[1]=cv-pfsmsi_pub02.cv.perf:PF_SMSIPUB_02:smsi-pub:smsi-publisher:SMSI_PUB_02:SMSI_PUB_02
  inar[2]=cv-pfsmsi_pub03.cv.perf:PF_SMSIPUB_03:smsi-pub:smsi-publisher:SMSI_PUB_03:SMSI_PUB_03
  inar[3]=cv-pfsmsi_pub04.cv.perf:PF_SMSIPUB_04:smsi-pub:smsi-publisher
 ;;
 dai-smsi)
  inar[0]=cv-pfsmsi_ing01.cv.perf:PF_SMSI_01:smsi:safi-smsi-server
  inar[1]=cv-pfsmsi_ing02.cv.perf:PF_SMSI_02:smsi:safi-smsi-server
  inar[2]=cv-pfsmsi_ing03.cv.perf:PF_SMSI_03:smsi:safi-smsi-server
  inar[3]=cv-pfsmsi_ing04.cv.perf:PF_SMSI_04:smsi:safi-smsi-server
 ;;
 SDC-session-collector)
  inar[0]=cv-pfscol01.cv.perf:PF_SESCOL_01:sdc-session-collector-server:sdc-session-collector-server
  inar[1]=cv-pfscol02.cv.perf:PF_SESCOL_02:sdc-session-collector-server:sdc-session-collector-server
  inar[2]=cv-pfscol03.cv.perf:PF_SESCOL_03:sdc-session-collector-server:sdc-session-collector-server
  inar[3]=cv-pfscol04.cv.perf:PF_SESCOL_04:sdc-session-collector-server:sdc-session-collector-server
  inar[4]=cv-pfscol05.cv.perf:PF_SESCOL_05:sdc-session-collector-server:sdc-session-collector-server
 ;;
 dai-smsi-relay)
  inar[0]=cv-pfsmsi_relay01.cv.perf:PF_SMSIREL_01:smsi-relay:smsi-relay-client:SMSI_RELAY_01:SMSI_RELAY_01:-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE
  inar[1]=cv-pfsmsi_relay02.cv.perf:PF_SMSIREL_02:smsi-relay:smsi-relay-client:SMSI_RELAY_02:SMSI_RELAY_02:-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE
  inar[2]=cv-pfsmsi_relay03.cv.perf:PF_SMSIREL_03:smsi-relay:smsi-relay-client:SMSI_RELAY_03:SMSI_RELAY_03:-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE
  inar[3]=cv-pfsmsi_relay04.cv.perf:PF_SMSIREL_04:smsi-relay:smsi-relay-client
  inar[4]=cv-pfsmsi_relay05.cv.perf:PF_SMSIREL_05:smsi-relay:smsi-relay-client
  inar[5]=cv-pfsmsi_relay06.cv.perf:PF_SMSIREL_06:smsi-relay:smsi-relay-client
 ;;
 smsi-msp-relay)
  inar[0]=cv-pfsmsi_relay01.cv.perf:MSP_RELAY01:smsi-relay:smsi-relay-msp
  inar[1]=cv-pfsmsi_relay02.cv.perf:MSP_RELAY02:smsi-relay:smsi-relay-msp
  inar[2]=cv-pfsmsi_relay03.cv.perf:MSP_RELAY03:smsi-relay:smsi-relay-msp
  inar[3]=cv-pfsmsi_relay04.cv.perf:MSP_RELAY04:smsi-relay:smsi-relay-msp
  inar[4]=cv-pfsmsi_relay05.cv.perf:MSP_RELAY05:smsi-relay:smsi-relay-msp
  inar[5]=cv-pfsmsi_relay06.cv.perf:MSP_RELAY06:smsi-relay:smsi-relay-msp
  inar[6]=cv-pfsmsi-relay07.cv.perf:MSP_RELAY07:smsi-relay:smsi-relay-msp
  inar[7]=cv-pfsmsi-relay08.cv.perf:MSP_RELAY08:smsi-relay:smsi-relay-msp
 ;;
 RentrakRelay)
  inar[0]=cv-pfsmsi-relay07.cv.perf:PF_SMSIREL_07:smsi-relay:smsi-relay-client:SMSI_RELAY_04:SMSI_RELAY_04:-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE
  inar[1]=cv-pfsmsi_relay08.cv.perf:PF_SMSIREL_08:smsi-relay:smsi-relay-client
 ;;
 int-test-support)
  inar[0]=cv-pffeeder01.cv.perf:mocksvr01:int-test-support:int-test-support
 ;;
 ad-load-manager)
  inar[0]=cv-pfcluster03.cv.perf:PF_ALM_01:ad-load-manager:alm-server:ALM:ALM
 ;;
 dai-dce)
  inar[0]=cv-pfdce.cv.perf:PF_DCE_01:dai-dce-server:dai-dce-server:DAIDCE:DAIDCE
 ;;
 dai-national-cis)
  inar[0]=cv-pfcluster01.cv.perf:PF_NCIS_01:nCisClient:nCisClient:NCIS:NCIS:-DCAAS_SCHEMA_NAME=CAAS_CORE
 ;;
 POIS)
  inar[0]=cv-pfpois01.cv.perf:PF_POIS_01:pois:pois
  inar[1]=cv-pfpois02.cv.perf:PF_POIS_02:pois:pois
 ;;
 impression_collector)
  inar[0]=cv-pfimp_coll01.cv.perf:PF_IMPCOL_01:impression_collector_server:impression_collector_server
  inar[1]=cv-pfimp_coll02.cv.perf:PF_IMPCOL_02:impression_collector_server:impression_collector_server
 ;;
 dai-cip)
  inar[0]=cv-pfcluster03.cv.perf:pf_dai_cip
 ;;
 acp)
  inar[0]=cv-pfcluster02.cv.perf:pf_acp
 ;;
esac
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
  echo "/tmp/mstrcmdmgr.scp contents"
  cat /tmp/mstrcmdmgr.scp
}

fnSendMDApp() {
  export ARCHIVE="MicroDev_${VERSION}.tar" ; echo "ARCHIVE=${ARCHIVE}"
  executeCommand "scp /opt/build/releaseTars/MicroDev/${ARCHIVE} ${SCP_BASE}:${WORKING_DIR}"
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
  echo "${VERSION}" > /var/www/html/zayo_perf/${Component}.txt
  date | awk '{print $2,$3,$4}' > /var/www/html/zayo_perf/${Component}.instdate.txt
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
#  Deployed_VERSION=`fnCheckDBVers`
  fnDBConf
  fnDB_Rebuild
  fnRetDB
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
#       fnZayos_Sys $Comp
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
        fnDeployApp
        k=$((k+1))
       done
       ;;
# -Dynamic-Ad-Insertion-cm
#  Uses the new array assignment method .vs. case logic
    Dynamic-Ad-Insertion-cm)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
        fnDeployApp
        k=$((k+1))
       done
       ;;
# -smsi-msp-relay
#  Uses the new array assignment method .vs. case logic
    smsi-msp-relay)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
        fnDeployApp
        k=$((k+1))
       done
       ;;
# -DMP Config
#  Uses the new array assignment method .vs. case logic
    dmp-config)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
        fnDeployApp
        k=$((k+1))
       done
       ;;
# -Mock Server
#  Uses the new array assignment method .vs. case logic
    int-test-support)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
        fnDeployApp
        k=$((k+1))
       done
       ;;
# ad-load-manager-
#  Uses the new array assignment method .vs. case logic
    ad-load-manager)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS LiqBaOPTS=$LiqBaOPTS"
        if test "$DB_USER"; then
         fnDeployDB
        fi
        fnDeployApp
        k=$((k+1))
       done
       ;;
# dai-dce-
#  Uses the new array assignment method .vs. case logic
    dai-dce)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS LiqBaOPTS=$LiqBaOPTS"
        if test "$DB_USER"; then
         fnDeployDB
        fi
        fnDeployApp
        k=$((k+1))
       done
       ;;
# -Pgmr-Cpgn-Int
#  Uses the new array assignment method .vs. case logic
    Pgmr-Cpgn-Int)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS LiqBaOPTS=$LiqBaOPTS"
        if test "$DB_USER"; then
         fnDeployDB
        fi
        fnDeployApp
        k=$((k+1))
       done
       ;;
# -dai-smsi
#  Uses the new array assignment method .vs. case logic
    dai-smsi)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
        fnDeployApp
        k=$((k+1))
       done
       ;;
# -SDC-session-collector
#  Uses the new array assignment method .vs. case logic
    SDC-session-collector)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS
"
        fnDeployApp
        k=$((k+1))
       done
       ;;
# -smsi-publisher
#  Uses the new array assignment method .vs. case logic
    smsi-publisher)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS LiqBaOPTS=$LiqBaOPTS"
        if test "$DB_USER"; then
         fnDeployDB
        fi
        fnDeployApp
        k=$((k+1))
       done
       ;;
# -rema-publisher
#  Uses a custom system definition due to it's temporary nature.  Will eventually be converted to the smsi-publisher section
    rema-publisher)
       export Comp=smsi-publisher
       export Component=smsi-publisher
       fnInitRpt
       export k=0
       inar[0]=cv-pfsmsi_pub01.cv.perf:PF_REMAPUB_01:smsi-pub:smsi-publisher:REMA_PUB:REMA_PUB
       inar[1]=cv-pfsmsi_pub02.cv.perf:PF_REMAPUB_02:smsi-pub:smsi-publisher:REMA_PUB_02:REMA_PUB_02
       inar[2]=cv-pfsmsi_pub03.cv.perf:PF_REMAPUB_03:smsi-pub:smsi-publisher:REMA_PUB_03:REMA_PUB_03
       inar[3]=cv-pfsmsi_pub04.cv.perf:PF_REMAPUB_04:smsi-pub:smsi-publisher
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS LiqBaOPTS=$LiqBaOPTS"
        if test "$DB_USER"; then
         echo "Building DB and Component -> $DB_USER  $DB_PASS  $Component"
         fnDeployDB
        fi
        fnDeployApp
         k=$((k+1))
       done
       export Component=rema-publisher
       fnRptVer
       ;;
# -dai-national-cis
#  Uses the new array assignment method .vs. case logic
    dai-national-cis)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS LiqBaOPTS=$LiqBaOPTS"
        if test "$DB_USER"; then
         fnDeployDB
        fi
        fnDeployApp
        k=$((k+1))
       done
       ;;
# -metadata-publisher
#  Uses the new array assignment method .vs. case logic
    metadata-publisher)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS $LiqBaOPTS"
        fnDeployApp
        k=$((k+1))
       done
       ;;
# -dai-smsi-relay
#  Uses the new array assignment method .vs. case logic
    dai-smsi-relay)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
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
       ;;
# -dai-cip-feedback
# Uses the new array assignment method .vs. case logic
    dai-cip-feedback)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS"
        fnDeployApp
        k=$((k+1))
       done
       ;;
# request-mgr
#  Uses the new array assignment method .vs. case logic
    request-mgr)
       fnInitRpt
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS"
        if test "$DB_USER"; then
         fnDeployDB
        fi
        fnDeployApp
        fnStopApp
        k=$((k+1))
       done
       ;;
# -acp
    acp)
       fnInitRpt
       export APP=$Component
       export APPSERVER_IP="cv-pfcluster02.cv.perf"
       export JarDirect="pf_acp"
       export JarLoc1="bin"
       export JarName1="acp"
       fnDeployJar
      ;;
# -dai-cip
    dai-cip)
       fnInitRpt
       export APP=$Component
       export APPSERVER_IP="cv-pfcluster03.cv.perf"
       export JarDirect="pf_dai_cip"
       export JarLoc1="bin"
       export JarName1="dai-cip"
       fnDeployJar
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
   ;;

# POIS-
#  Uses the new array assignment method .vs. case logic
    POIS)
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
       fnInitRpt
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS"
        fnDeployApp
        k=$((k+1))
       done
       ;;
# -impression_collector
#  Uses the new array assignment method .vs. case logic
    impression_collector)
       export k=0
       export Comp=$Component
       source /opt/build/scripts/zayos_sys_Perf.sh
#       fnZayos_Sys $Comp
       fnInitRpt
       for i in ${inar[@]}; do
        fnAssignInfo
        echo "$APPSERVER_IP $INSTANCE $WEBAPPS $APP $DB_USER $DB_PASS"
        fnDeployApp
        k=$((k+1))
       done
       ;;
# -caas-core
   caas-core)
     export DependApps="acp dai-cip-feedback ad-load-manager dai-smsi-relay smsi-msp-relay dai-smsi dai-cip Dynamic-Ad-Insertion-cm metadata-publisher Pgmr-Cpgn-Int dai-national-cis"
     export DependJars="dai-cip acp"
     export DB_USER="CAAS_CORE"
     export DB_PASS="CAAS_CORE"
     export LiqBaOPTS="-DADS_SCHEMA_NAME=ADS_CORE_MS01"
     echo "LiqBaOPTS=$LiqBaOPTS"
     fnDeployDB
     cd /opt/build/scripts/zayo_perf
     echo "Building Triggers in metadata-sync"
     export ADS_USER="ADS_CORE_MSO1,ADS_CORE_MSO2,ADS_CORE_MSO3"
     export CAAS_USER="CAAS_CORE"
     cd /tmp/deploymentWorkArea/metadata-sync/1.0.0_11
     echo "Running ./install.sh ${ADS_USER} ${CAAS_USER} against $DBIP 1522 $SIDTarg"
     chmod +x install.sh
     ./install.sh ${ADS_USER} ${CAAS_USER} cm_system Perf0ra $DBIP 1522 $SIDTarg
   ;;
# -ads-core
   ads-core)
     export DependApps="Dynamic-Ad-Insertion-engine"
     export adsCoreDB="adscore1 adscore2 adscore3"
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
   ;;
# -dai-etl-feeder
   dai-etl-feeder)
     export DependApps="dai-smsi dai-smsi-relay"
#     fnStopDepApp
     export DB_USER="DAI_REPORTING_SAFI"
     export DB_PASS="DAI_REPORTING_SAFI"
     export LiqBaOPTS="-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE -DBAR_SCHEMA_NAME=OSS_BAR -DBILLING_SCHEMA_NAME=DAI_BILLING -DREPORTING_SCHEMA_NAME=${DB_USER}"
     echo "LiqBaOPTS=$LiqBaOPTS"
     fnDeployDB
#     fnStartDepApp
   ;;
# -smsi_reporting
   smsi_reporting)
     export DependApps="dai-smsi dai-smsi-relay"
#     fnStopDepApp
     export DB_USER="SMSI_REPORTING"
     export DB_PASS="SMSI_REPORTING"
     export LiqBaOPTS="-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE -DINGEST_SCHEMA_NAME=DAI_REPORTING_SAFI"
     echo "LiqBaOPTS=$LiqBaOPTS"
     fnDeployDB
#     fnStartDepApp
   ;;
   bogus_app)
#     export DependApps="dai-cip acp"
     export DependApps="dai-cip-feedback ad-load-manager dai-smsi-relay dai-smsi Dynamic-Ad-Insertion-cm metadata-publisher Pgmr-Cpgn-Int dai-national-cis"
    echo "Bogus App - just an echo"
     fnStopDepApp
     fnStartDepApp
   ;; 
   *)
    print "No Deploy...";;
esac
