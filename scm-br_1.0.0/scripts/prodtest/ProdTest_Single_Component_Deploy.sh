#!/bin/ksh -x
#
# Prod_Single_Component_Deploy.sh
# Expected inputs - Component, Clear_Logs, Version
#
# Edits for component/system additions
# 
#  APP - The .war name within the .tar file (if the name is different than the .tar)
#  APPSERVER_IP - The hostname/IP of the target system
#  INSTANCE     - The tcserver instance specific to what is being deployed
#  WEBAPPS      - The As Installed naming of the deployed application (should match the Context line of server.xml)
#  Verify User supplies a Username and Purpose for the Deployment

if [ -z ${BUILD_USER_ID} ] ; then
    print "<h2>User must supply a user name and summary of deploy purpose</h2>"
    exit 1
fi

export TAR=${Component}
cd /opt/build/scripts/prodtest

######################################################################
#                      Utility Functions of script 
######################################################################
executeCommand() {
 print Executing : $1
 FUNC_RV=eval $1
 if [ $? -ne 0 ] ; then
     print ERROR: Error executing $1
     exit 1
 fi
}

fnInitRpt() { 
echo "<b>&nbsp<u> Upgrading ${Component}</u> :</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
}

fnVersionCheck() {
 Deployed_Version=`ssh tcserver@${APPSERVER_IP} "grep Implementation-Version /opt/tcserver/instances/${INSTANCE}/webapps/${WEBAPPS}/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
 echo "---------------------------------------------------------------------"
 echo "Upgrading ${Component} : in instance ${INSTANCE} to ${Version}"
 echo "---------------------------------------------------------------------"
 echo "<b>&nbsp ... on ${APPSERVER_IP}</b> in instance <b>${INSTANCE}</b> from <b>${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
}

fnJarVersionCheck() {
 Deployed_Version=`ssh tcserver@${APPSERVER_IP} "cd /var/tmp; jar xf /opt/tcserver/${JarDirect}${JarLoc1}/${JarName1}.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"` 
 echo "---------------------------------------------------------------------"
 echo "Upgrading ${Component} : in instance ${INSTANCE} to ${Version}"
 echo "---------------------------------------------------------------------"
 echo "<b>&nbsp ... on ${APPSERVER_IP}</b> in <b>${JarDirect}</b> from <b>${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
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
  export TAR="${Component}_${Version}"
#  export DESTBASE="/opt/tcserver/${JarDirect}" ; echo "DESTBASE=${DESTBASE}" 
  export WORKING_DIR="/opt/tcserver/App_Files" ; echo "WORKING_DIR=${WORKING_DIR}"
#  export SSH_CP_BIN_DIR="tcserver@${APPSERVER_IP}:/var/tmp" ; echo "SSH_CP_BIN_DIR=${SSH_CP_BIN_DIR}"
  export CP_BIN_DIR="tcserver@${APPSERVER_IP}:/var/tmp" ; echo "CP_BIN_DIR=${CP_BIN_DIR}"
  export SSH_BASE="ssh -X tcserver@${APPSERVER_IP}" ; echo "SSH_BASE=${SSH_BASE}"
  export APPSERVER_BASE=${APPSERVER_BASE-/var/tmp} ; echo "APPSERVER_BASE=${APPSERVER_BASE}"
  export APPSERVER_BIN="${APPSERVER_BASE}" ; echo "APPSERVER_BIN=${APPSERVER_BIN}"
  export ARCHIVE="${Component}_${Version}.tar" ; echo "ARCHIVE=${ARCHIVE}"
  export SCP_BASE="tcserver@${APPSERVER_IP}" ; echo "SCP_BASE=${SCP_BASE}"
}

#Deliver Application function
fnSendApp() {
  export ARCHIVE="${Component}_${Version}.tar" ; echo "ARCHIVE=${ARCHIVE}"
  executeCommand "scp /opt/build/releaseTars/${Component}/${ARCHIVE} ${SCP_BASE}:/${WORKING_DIR}"
}

#Copy jar to location.
fnCpyJarScpts() {
  executeCommand "scp deployJar.sh ${CP_BIN_DIR}"
}

#Copy scripts to remote application server.
fnCpyScpts() {
  executeCommand "scp stop.sh ${SSH_CP_BIN_DIR}"
  executeCommand "scp deployWar.sh ${SSH_CP_BIN_DIR}"
}

# Stop the application server
fnStopApp() {
  ${SSH_BASE} ${APPSERVER_BIN}/stop.sh -a ${INSTANCE}
}

# Stop the .jar application
fnStopJar() {
  if [[ ${Component} = "acp" ]]; then
    ${SSH_BASE} "cd /opt/tcserver/${JarDirect}${JarLoc1}; ./launcher.sh stop"
  elif [[ ${Component} = "dai-cip" ]]; then
    ${SSH_BASE} "cd /opt/tcserver/${JarDirect}${JarLoc1}; ./launcher.sh stop"
  fi
}

# Deploy the war to the app server.
fnDepWar() {
  executeCommand "${SSH_BASE} ${APPSERVER_BIN}/deployWar.sh -a ${APP} -t ${Component} -r ${Version} -i ${INSTANCE} -w ${WEBAPPS} -e ${APPSERVER_IP} -v"
}

fnDepJar() {
 executeCommand "${SSH_BASE} ${APPSERVER_BIN}/deployJar.sh -a ${APP} -t ${Component} -r ${Version} -e ${APPSERVER_IP} -j ${JarDirect} -k ${JarName1} -l ${JarName2} -m ${JarLoc1} -n ${JarLoc2} -v"
}

# clean up
fnCleanup() {
  executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/stop.sh"
  executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/deployWar.sh"
}

# Report Version & Date info
fnRptProdTestVer() {
  echo "${Version}" > /var/www/html/prodtest/${Component}.txt
  date | awk '{print $2,$3,$4}' > /var/www/html/prodtest/${Component}.instdate.txt
}


######################################################################
#                 End of Utility Functions of script
######################################################################

######################################################################
#                   Begin Deployment Function calls 
######################################################################
# When testing, use as modular sequential functions.
# fnVersionCheck- Check the existing deployed version 
# fnBaseAppSet  - Base Application server, workarea setup related variables.
# fnSendApp     - Deliver Application to target Workarea (App_Files)
# fnCpyScpts    - Deliver deployWar.sh and stop.sh to target instance bindir
# fnStopApp     - Stop the target application server
# fnDepWar      - Run the deployWar.sh script on target server
# fnCleanup     - Clean up any delivered scripts, temporary files
# fnRptVer      - Report version of deployment
 
fnDeployApp() {
  fnVersionCheck
  fnBaseAppSet
  fnSendApp 
  fnCpyScpts
  fnStopApp
  fnDepWar
  fnCleanup
  fnRptProdTestVer
}

fnDeployJar() {
  fnJarVersionCheck
  fnBaseJarAppSet
  fnSendApp
  fnCpyJarScpts
  fnStopJar
  fnDepJar
  #fnJarCln
  fnRptProdTestVer
}

######################################################################
#                End Deployment Functions of script
######################################################################

######################################################################
#                Components and Systems Definitions 
######################################################################

case $Component in
 Dynamic-Ad-Insertion-engine)
       export APP="ads"
       fnInitRpt
       if [[ ${CompSet} = "ADS1" ]]; then
         export ADSComponents="ads01 ads02"
       elif [[ ${CompSet} = "ADS2" ]]; then
         export ADSComponents="ads03 ads04"
       elif [[ ${CompSet} = "ALL" ]]; then
         export ADSComponents="ads01 ads02 ads03 ads04 ads05 ads06 ads07 ads08 ads09 ads10 ads11 ads12"
       fi
        for i in $ADSComponents; do
          case $i in
             ads01)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="CMC_ADS_001"
                export WEBAPPS="ads"
             ;;
             ads02)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="CMC_ADS_002"
                export WEBAPPS="ads"
             ;;
             ads03)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="CMC_PSN_001"
                export WEBAPPS="ads"
             ;;
             ads04)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="CMC_PSN_001"
                export WEBAPPS="ads"
             ;;
             ads05)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="TWC_CIP_ADS01"
                export WEBAPPS="ads-1.2.0"
             ;;
             ads06)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="TWC_CIP_ADS02"
                export WEBAPPS="ads-1.2.0"
             ;;
             ads07)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="TWC_CIP_INGEST1"
                export WEBAPPS="ads-1.2.0"
             ;;
             ads08)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="TWC_CIP_INGEST2"
                export WEBAPPS="ads-1.2.0"
             ;;
             ads09)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="TWC_CIP_PSN01"
                export WEBAPPS="ads-1.2.0"
             ;;
             ads10)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="TWC_CIP_PSN02"
                export WEBAPPS="ads-1.2.0"
             ;;
             ads11)
                export APP="cis"
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="CMC_CIS_001"
                export WEBAPPS="cis"
             ;;
             ads12)
                export APP="cis"
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="TWC_CIP_CIS01"
                export WEBAPPS="cis-1.2.0"
             ;;
          esac
          fnDeployApp
        done
       ;;
    Dynamic-Ad-Insertion-cm)
       fnInitRpt
       export APP=$Component
       export CMComponents="Dynamic-Ad-Insertion-cm02"
        for i in $CMComponents; do
          case $i in
             Dynamic-Ad-Insertion-cm01)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="CampMan_001"
                export WEBAPPS="cm"
             ;;
             Dynamic-Ad-Insertion-cm02)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="CampMan_002"
                export WEBAPPS="cm"
             ;;
          esac
          fnDeployApp
        done
       ;;
    caas-admin)
       fnInitRpt
       export APP=$Component
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="caas_admin"
                export WEBAPPS="caas_admin"
          fnDeployApp
       ;;

    acp)
       fnInitRpt
       export APP=$Component
                export APPSERVER_IP="162.150.72.107"
                export JarDirect="acp"
                export JarLoc1="/"
                export JarName1="acp"
          fnDeployJar
       ;;
    dai-cip)
       fnInitRpt
       export APP=$Component
                export APPSERVER_IP="162.150.72.107"
                export JarDirect="dai-cip"
                export JarLoc1="/cip-batch"
                export JarName1="dai-cip-batch"
          fnDeployJar
       ;;
    dai-metadata-ingestion)
       fnInitRpt
       export APP=$Component
                export APPSERVER_IP="162.150.72.107"
                export JarDirect="dai-metadata-ingestion"
                export JarLoc1="/"
                export JarName="ingester"
          fnDeployJar
       ;;
    scte-feeder)
       fnInitRpt
       export APP=$Component
                export APPSERVER_IP="162.150.72.107"
                export JarDirect="scte-feeder"
                export JarLoc1="/"
                export JarName="scte-feeder"
          fnDeployJar
       ;;
    dai_amm)
       fnInitRpt
       export APP=$Component
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="amm"
                export WEBAPPS="amm"
          fnDeployApp
       ;;
    ops-dce-metadata-agent)
       fnInitRpt
       export APP=ops-dce-metadata-agent
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="ops-bas"
                export WEBAPPS="bas"
          fnDeployApp
       ;;

    ops-dt)
       fnInitRpt
       export APP=$Component
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="ops-dt"
                export WEBAPPS="dai_dt"
          fnDeployApp
       ;;

    oss_bar)
       fnInitRpt
       export APP=$Component
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="barf"
                export WEBAPPS="barf"
          fnDeployApp
       ;;

    Pgmr-Cpgn-Int)
       fnInitRpt
       export APP=pci
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="FW_CIP_ING_01"
                export WEBAPPS="fw_cip-ingest"
          fnDeployApp
       ;;

    dai-smsi)
       fnInitRpt
       export APP=safi-smsi-server
       export SMSIComponents="smsi01 smsi02 smsi03 smsi04"
        for i in $SMSIComponents; do
          case $i in
             smsi01)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="CMC_SMSI_001"
                export WEBAPPS="smsi"
             ;;
             smsi02)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="COM_SMSI1"
                export WEBAPPS="smsi"
             ;;
             smsi03)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="COM_SMSI3"
                export WEBAPPS="smsi"
             ;;
             smsi04)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="TWC_SMSI1"
                export WEBAPPS="smsi"
             ;;
          esac
          fnDeployApp
        done
       ;;

#    microdev)
#       export APP=$Component
#                export APPSERVER_IP="162.150.72.107"
#                export MSDSN=""
#      #From the scrum Single we'll need all of this plus ^
#      echo "targname=$targname"
#      echo "JDBC_URL=$JDBC_URL"
#      echo "DB_USER=$DB_USER"
#      echo "DB_PASS=$DB_PASS"
#      echo "MSDSN=$MSDSN"
#          fnDeployApp #this deploy won't work
#       ;;
#
#    ms-data-analysis)
#       export APP=$component
#                export APPSERVER_IP="162.150.72.107"
#                export MSDSN=""
#      #From the scrum Single we'll need all of this plus ^
#      echo "targname=$targname"
#      echo "JDBC_URL=$JDBC_URL"
#      echo "DB_USER=$DB_USER"
#      echo "DB_PASS=$DB_PASS"
#      echo "MSDSN=$MSDSN"
#          fnDeployApp #this deploy won't work
#       ;;

    smsi-admin)
       fnInitRpt
       export APP=$Component
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="smsi-admin"
                export WEBAPPS="smsi-admin"
          fnDeployApp
       ;;

    smsi-publisher)
       fnInitRpt
       export APP=$Component
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="smsi-pub"
                export WEBAPPS="smsi-pub"
          fnDeployApp
       ;;

    dai-smsi-relay)
       fnInitRpt
       export APP=smsi-relay-client
       export SMSIComponents="smsi-relay01 smsi-relay02"
        for i in $SMSIComponents; do
          case $i in
             smsi-relay01)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="FW_SMSI_RELAY01"
                export WEBAPPS="fw_smsi-relay"
             ;;
             smsi-relay02)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="FW_SMSI_RELAY02"
                export WEBAPPS="fw_smsi-relay"
             ;;
          esac
          fnDeployApp
        done
       ;;

    dai-cip-feedback)
       fnInitRpt
       export APP=cip-server
#       export CIPComponents="cipfn01 cipfn02 cipfn03 cipfn04 cipfn05"
      export CIPComponents="cipfn06"
        for i in $CIPComponents; do
          case $i in
#             cipfn01)
#                export APPSERVER_IP="162.150.72.107"
#                export INSTANCE="CMC_CIPFN_001"
#                export WEBAPPS="cip-feedback"
#             ;;
#             cipfn02)
#                export APPSERVER_IP="162.150.72.107"
#                export INSTANCE="COM_CIP_FN1"
#                export WEBAPPS="cip-feedback"
#             ;;
#             cipfn03)
#                export APPSERVER_IP="162.150.72.107"
#                export INSTANCE="COM_CIP_FN2"
#                export WEBAPPS="cip-feedback"
#             ;;
#             cipfn04)
#                export APPSERVER_IP="162.150.72.107"
#                export INSTANCE="TWC_CIP_FN1"
#                export WEBAPPS="cip-feedback"
#             ;;
#             cipfn05)
#                export APPSERVER_IP="162.150.72.107"
#                export INSTANCE="TWC_CIP_FN2"
#                export WEBAPPS="cip-feedback"
#             ;;
             cipfn06)
                export APPSERVER_IP="162.150.72.107"
                export INSTANCE="dai-cip-feedback"
                export WEBAPPS="cip-feedback"
             ;;
          esac
	  fnDeployApp
        done
       ;;
################################################
    impression_collector)
          export APP=impression_collector_server
          export APPSERVER_IP="162.150.72.107"
          export INSTANCE="impression_collector"
          export WEBAPP="impression_collector_server"
       fn_CheckVerWar
       cd /opt/build/scripts/prodtest
       #./deployapp.sh -a impression_collector_server -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
       fnDeployApp
       ;;
################################################
    *)
      print "No Deploy...";;
esac
