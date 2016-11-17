#!/bin/ksh 
#
# Prod_Single_Component_Deploy.sh
# Expected inputs - Component, Clear_Logs, Version, StealthDeploy
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
cd /opt/build/scripts/production

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
 Deployed_Version=`ssh tcserver@${APPSERVER_IP} "cd /var/tmp; jar xf /opt/tcserver/${JarDirect}/${JarLoc1}/${JarName1}.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
 echo "---------------------------------------------------------------------"
 echo "Upgrading ${Component} : in instance ${JarDirect} to ${Version}"
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
  export WORKING_DIR="/opt/tcserver/App_Files" ; echo "WORKING_DIR=${WORKING_DIR}"
  export CP_BIN_DIR="tcserver@${APPSERVER_IP}:/var/tmp" ; echo "CP_BIN_DIR=${CP_BIN_DIR}"
  export SSH_BASE="ssh tcserver@${APPSERVER_IP}" ; echo "SSH_BASE=${SSH_BASE}"
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
  executeCommand "scp deployWarnoRestart.sh ${SSH_CP_BIN_DIR}"
}

# Stop the application server
fnStopApp() {
  ${SSH_BASE} ${APPSERVER_BIN}/stop.sh -a ${INSTANCE}
}

# Deploy the war to the app server.
fnDepWar() {
  executeCommand "${SSH_BASE} ${APPSERVER_BIN}/deployWar.sh -a ${APP} -t ${Component} -r ${Version} -i ${INSTANCE} -w ${WEBAPPS} -e ${APPSERVER_IP} -v"
}

fnDepJar() {
 executeCommand "${SSH_BASE} ${APPSERVER_BIN}/deployJar.sh -a ${APP} -t ${Component} -r ${Version} -e ${APPSERVER_IP} -j ${JarDirect} -k ${JarName1} -m ${JarLoc1} -v"
}

# Stealth Deploy - Deploy the war to the app server but don't preclean or stop the server only deliver the .war file.
fnDepWarNoRestart() {
  executeCommand "${SSH_BASE} ${APPSERVER_BIN}/deployWarnoRestart.sh -a ${APP} -t ${Component} -r ${Version} -i ${INSTANCE} -w ${WEBAPPS} -e ${APPSERVER_IP} -v"
}

# clean up
fnCleanup() {
  executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/stop.sh"
  executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/deployWar.sh"
  executeCommand "${SSH_BASE} rm ${APPSERVER_BIN}/deployWarnoRestart.sh"
}

fnJarCln() {
  executeCommand "${SSH_BASE} rm ${CP_BIN_DIR}/deployJar.sh"
}

# Report Production Version info
fnRptVer() {
  echo "${Version}" > /var/www/html/prod/production/${Component}.txt
  date | awk '{print $2,$3,$4}' > /var/www/html/production/${Component}.instdate.txt
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
  fnRptVer
}

fnDeployAppNoRestart() {
  fnVersionCheck
  fnBaseAppSet
  fnSendApp
  fnCpyScpts
  fnDepWarNoRestart
  fnCleanup
  fnRptVer
}

fnDeployJar() {
  fnJarVersionCheck
  fnBaseJarAppSet
  fnSendApp
  fnCpyJarScpts
  fnDepJar
  #fnJarCln
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
 Dynamic-Ad-Insertion-engine)
       export APP=ads
       fnInitRpt
       if [[ ${CompSet} = "ADS_Ingesters" ]]; then
         export ADSComponents="ads01 ads02 ads03 ads04 ads05 ads06 ads19 ads20"
       elif [[ ${CompSet} = "ADS_GroupAlpha" ]]; then
         export ADSComponents="ads07 ads08 ads09 ads10 ads11 ads12"
       elif [[ ${CompSet} = "ADS_GroupBeta" ]]; then
         export ADSComponents="ads13 ads14 ads15 ads16 ads17 ads18"
       fi

#       export ADSComponents="ads01 ads02 ads03 ads04 ads05 ads06 ads07 ads08 ads09 ads10 ads11 ads12 ads13 ads14 ads15 ads16 ads17 ads18 ads19 ads20"
        for i in $ADSComponents; do
          case $i in
             ads01)
                export APPSERVER_IP="cv-de_ciping01.cv.prod"
                export INSTANCE="CMC_CIP_INGEST01"
                export WEBAPPS="ads"
             ;;
             ads02)
                export APPSERVER_IP="cv-de_ciping02.cv.prod"
                export INSTANCE="CMC_CIP_INGEST02"
                export WEBAPPS="ads"
             ;;
             ads03)
                export APPSERVER_IP="cv-de_ciping03.cv.prod"
                export INSTANCE="TWC_CIP_INGEST01"
                export WEBAPPS="ads-1.2.0"
             ;;
             ads04)
                export APPSERVER_IP="cv-de_ciping04.cv.prod"
                export INSTANCE="TWC_CIP_INGEST02"
                export WEBAPPS="ads-1.2.0"
             ;;
             ads05)
                export APPSERVER_IP="cv-de_ciping05.cv.prod"
                export INSTANCE="COX_CIP_INGEST01"
                export WEBAPPS="ads"
             ;;
             ads06)
                export APPSERVER_IP="cv-de_ciping06.cv.prod"
                export INSTANCE="COX_CIP_INGEST02"
                export WEBAPPS="ads"
             ;;
             ads07)
                export APPSERVER_IP="cv-dec_eng01.cv.prod"
                export INSTANCE="CMC_CIP_DE01"
                export WEBAPPS="ads"
             ;;
             ads08)
                export APPSERVER_IP="cv-dec_eng02.cv.prod"
                export INSTANCE="CMC_CIP_DE02"
                export WEBAPPS="ads"
             ;;
             ads09)
                export APPSERVER_IP="cv-dec_eng05.cv.prod"
                export INSTANCE="TWC_CIP_ADS01"
                export WEBAPPS="ads-1.2.0"
             ;;
             ads10)
                export APPSERVER_IP="cv-dec_eng07.cv.prod"
                export INSTANCE="TWC_CIP_PSN01"
                export WEBAPPS="ads-1.2.0"
             ;;
             ads11)
                export APPSERVER_IP="cv-dec_eng09.cv.prod"
                export INSTANCE="COX_CIP_ADS01"
                export WEBAPPS="ads"
             ;;
             ads12)
                export APPSERVER_IP="cv-dec_eng11.cv.prod"
                export INSTANCE="COX_CIP_PSN01"
                export WEBAPPS="ads"
             ;;
             ads13)
                export APPSERVER_IP="cv-dec_eng03.cv.prod"
                export INSTANCE="CMC_CIP_DE03"
                export WEBAPPS="ads"
             ;;
             ads14)
                export APPSERVER_IP="cv-dec_eng04.cv.prod"
                export INSTANCE="CMC_CIP_DE04"
                export WEBAPPS="ads"
             ;;
             ads15)
                export APPSERVER_IP="cv-dec_eng06.cv.prod"
                export INSTANCE="TWC_CIP_ADS02"
                export WEBAPPS="ads-1.2.0"
             ;;
             ads16)
                export APPSERVER_IP="cv-dec_eng08.cv.prod"
                export INSTANCE="TWC_CIP_PSN02"
                export WEBAPPS="ads-1.2.0"
             ;;
             ads17)
                export APPSERVER_IP="cv-dec_eng10.cv.prod"
                export INSTANCE="COX_CIP_ADS02"
                export WEBAPPS="ads"
             ;;
             ads18)
                export APPSERVER_IP="cv-dec_eng12.cv.prod"
                export INSTANCE="COX_CIP_PSN02"
                export WEBAPPS="ads"
             ;;
             ads19)
                export APP="cis"
                export APPSERVER_IP="cv-de_cis01.cv.prod"
                export INSTANCE="TWC_CIP_CIS01"
                export WEBAPPS="cis"
             ;;
             ads20)
                export APP="cis"
                export APPSERVER_IP="cv-de_cis02.cv.prod"
                export INSTANCE="COX_CIP_CIS01"
                export WEBAPPS="cis"
             ;;
          esac
          if [[ ${StealthDeploy} = "Yes" ]] ; then 
             fnDeployAppNoRestart
          else
             fnDeployApp
          fi
        done
       ;;
# -Dynamic-Ad-Insertion-cm
    Dynamic-Ad-Insertion-cm)
       fnInitRpt
        export APP=$Component
        export APPSERVER_IP="cv-cm01.cv.prod"
        export INSTANCE="CampMan_001"
        export WEBAPPS="cm"
          if [[ ${StealthDeploy} = "Yes" ]] ; then
             fnDeployAppNoRestart
          else
             fnDeployApp
          fi
       ;;
# -ops-dce-metadata-agent
    ops-dce-metadata-agent)
       fnInitRpt
       export APP=ops-dce-metadata-agent
                export APPSERVER_IP="cv-bas01.cv.prod"
                export INSTANCE="ops-bas"
                export WEBAPPS="bas"
          if [[ ${StealthDeploy} = "Yes" ]] ; then
             fnDeployAppNoRestart
          else
             fnDeployApp
          fi
       ;;
# -Pgmr-Cpgn-Int
    Pgmr-Cpgn-Int)
       fnInitRpt
       export APP=pci
       export pciComps="pci01 pci02"
        for i in $pciComps; do
          case $i in
             pci01)
                export APPSERVER_IP="cv-pci01.cv.prod"
                export INSTANCE="FW_CIP_ING_01"
                export WEBAPPS="fw_cip-ingest"
             ;;
             pci02)
                export APPSERVER_IP="cv-pci03.cv.prod"
                export INSTANCE="GGL_CIP_ING_01"
                export WEBAPPS="ggl_cip-ingest"
             ;;
          esac
          if [[ ${StealthDeploy} = "Yes" ]] ; then
             fnDeployAppNoRestart
          else
             fnDeployApp
          fi
        done
       ;;
# -Request Manager
    request-mgr)
       fnInitRpt
       export APP="request-manager"
       export ReqComps="req01 req02"
        for i in $ReqComps; do
          case $i in
             req01)
                export APPSERVER_IP="cv-reqman01.cv.prod"
                export INSTANCE="TWC_REQMAN01"
                export WEBAPPS="request-manager"
             ;;
             req02)
                export APPSERVER_IP="cv-reqman02.cv.prod"
                export INSTANCE="TWC_REQMAN02"
                export WEBAPPS="request-manager"
             ;;
          esac
          if [[ ${StealthDeploy} = "Yes" ]] ; then
             fnDeployAppNoRestart
          else
             fnDeployApp
          fi
        done
       ;;
# -dai-smsi
    dai-smsi)
       fnInitRpt
       export APP=safi-smsi-server
       export SMSIComponents="smsi01 smsi02 smsi03 smsi04 smsi05 smsi06"
        for i in $SMSIComponents; do
          case $i in
             smsi01)
                export APPSERVER_IP="cv-smsi_ing01.cv.prod"
                export INSTANCE="CV_SMSI1"
                export WEBAPPS="smsi"
             ;;
             smsi02)
                export APPSERVER_IP="cv-smsi_ing02.cv.prod"
                export INSTANCE="CV_SMSI2"
                export WEBAPPS="smsi"
             ;;
             smsi03)
                export APPSERVER_IP="cv-smsi_ing03.cv.prod"
                export INSTANCE="CV_SMSI3"
                export WEBAPPS="smsi"
             ;;
             smsi04)
                export APPSERVER_IP="cv-smsi_ing04.cv.prod"
                export INSTANCE="CV_SMSI4"
                export WEBAPPS="smsi"
             ;;
            smsi05)
               export APPSERVER_IP="cv-smsi_ing05.cv.prod"
               export INSTANCE="CV_SMSI5"
               export WEBAPPS="smsi"
            ;;
            smsi06)
               export APPSERVER_IP="cv-smsi_ing06.cv.prod"
               export INSTANCE="CV_SMSI6"
               export WEBAPPS="smsi"
            ;;
          esac
          if [[ ${StealthDeploy} = "Yes" ]] ; then
             fnDeployAppNoRestart
          else
             fnDeployApp
          fi
        done
       ;;

# -smsi-publisher
    smsi-publisher)
       fnInitRpt
       export APP=$Component
       export SMSIPubComps="smsiP01 smsiP02 smsiP03 smsiP04 smsiP05 smsiP06"
        for i in $SMSIPubComps; do
          case $i in
             smsiP01)
                export APPSERVER_IP="cv-smsi_pub01.cv.prod"
                export INSTANCE="CMC_SMSI_PUB01"
                export WEBAPPS="smsi-pub"
             ;;
             smsiP02)
                export APPSERVER_IP="cv-smsi_pub02.cv.prod"
                export INSTANCE="CMC_SMSI_PUB02"
                export WEBAPPS="smsi-pub"
             ;;
             smsiP03)
                export APPSERVER_IP="cv-smsi_pub03.cv.prod"
                export INSTANCE="TWC_SMSI_PUB01"
                export WEBAPPS="smsi-pub"
             ;;
             smsiP04)
                export APPSERVER_IP="cv-smsi_pub04.cv.prod"
                export INSTANCE="TWC_SMSI_PUB02"
                export WEBAPPS="smsi-pub"
            ;;
             smsiP05)
                export APPSERVER_IP="cv-smsi_pub05.cv.prod"
                export INSTANCE="COX_SMSI_PUB01"
                export WEBAPPS="smsi-pub"
             ;;
             smsiP06)
                export APPSERVER_IP="cv-smsi_pub06.cv.prod"
                export INSTANCE="COX_SMSI_PUB02"
                export WEBAPPS="smsi-pub"
            ;;
          esac
          if [[ ${StealthDeploy} = "Yes" ]] ; then
             fnDeployAppNoRestart
          else
             fnDeployApp
          fi
        done
       ;;
# -dai-national-cis
    dai-national-cis)
       fnInitRpt
       export APP=nCisClient
       export ncisComps="ncis01"
        for i in $ncisComps; do
          case $i in
             ncis01)
                export APPSERVER_IP="cv-ncis01.cv.prod"
                export INSTANCE="NCIS01"
                export WEBAPPS="ncis"
             ;;
          esac
          if [[ ${StealthDeploy} = "Yes" ]] ; then
             fnDeployAppNoRestart
          else
             fnDeployApp
          fi
        done
       ;;
# -metadata-publisher
    metadata-publisher)
       fnInitRpt
       export APP=publisher
       export mdpComps="mdp01"
        for i in $mdpComps; do
          case $i in
             mdp01)
                export APPSERVER_IP="cv-meta_pub01.cv.prod"
                export INSTANCE="MD_PUB01"
                export WEBAPPS="md_publisher"
             ;;
          esac
          if [[ ${StealthDeploy} = "Yes" ]] ; then
             fnDeployAppNoRestart
          else
             fnDeployApp
          fi
        done
       ;;
# -dai-smsi-relay
    dai-smsi-relay)
       fnInitRpt
       export APP=smsi-relay-client
       export SMSIComponents="smsi-relay01 smsi-relay02"
        for i in $SMSIComponents; do
          case $i in
             smsi-relay01)
                export APPSERVER_IP="cv-smsi_relay01.cv.prod"
                export INSTANCE="FW_SMSI_RELAY01"
                export WEBAPPS="fw_smsi-relay"
             ;;
             smsi-relay02)
                export APPSERVER_IP="cv-smsi_relay02.cv.prod"
                export INSTANCE="FW_SMSI_RELAY02"
                export WEBAPPS="fw_smsi-relay"
             ;;
          esac
          if [[ ${StealthDeploy} = "Yes" ]] ; then
             fnDeployAppNoRestart
          else
             fnDeployApp
          fi
        done
       ;;
# -dai-cip-feedback
    dai-cip-feedback)
       fnInitRpt
       export APP=cip-server
       export CIPComponents="cipfn01 cipfn02 cipfn03 cipfn04"
        for i in $CIPComponents; do
          case $i in
             cipfn01)
                export APPSERVER_IP="cv-cip_feedbk01.cv.prod"
                export INSTANCE="CV_CIP_FN1"
                export WEBAPPS="cip-feedback"
             ;;
             cipfn02)
                export APPSERVER_IP="cv-cip_feedbk02.cv.prod"
                export INSTANCE="CV_CIP_FN2"
                export WEBAPPS="cip-feedback"
             ;;
             cipfn03)
                export APPSERVER_IP="cv-cip_feedbk03.cv.prod"
                export INSTANCE="CV_CIP_FN3"
                export WEBAPPS="cip-feedback"
             ;;
             cipfn04)
                export APPSERVER_IP="cv-cip_feedbk04.cv.prod"
                export INSTANCE="CV_CIP_FN4"
                export WEBAPPS="cip-feedback"
             ;;
          esac
          if [[ ${StealthDeploy} = "Yes" ]] ; then
             fnDeployAppNoRestart
          else
             fnDeployApp
          fi
        done
       ;;
# -acp
    acp)
       fnInitRpt
       export APP=$Component
       export APPSERVER_IP="cv-acp01.cv.prod"
#       export APPSERVER_IP="162.150.72.107"
       export JarDirect="acp"
       export JarLoc1="bin"
       export JarName1="acp"
       fnDeployJar
      ;;
# -dai-cip
    dai-cip)
       fnInitRpt
       export APP=$Component
       export APPSERVER_IP="cv-cip_sndr01.cv.prod"
#       export APPSERVER_IP="162.150.72.107"
       export JarDirect="dai-cip_40/dai-cip"
       export JarLoc1="bin"
       export JarName1="dai-cip"
       fnDeployJar
      ;;
# -impression_collector
    impression_collector)
       fnInitRpt
       export APP=$Component
       export ImpComps="cmcimp01 twcimp02 coximp03"
        for i in $ImpComps; do
          case $i in
             cmcimp01)
                export APPSERVER_IP="cv-imp_coll01.cv.prod"
                export INSTANCE="CMC_IMPCOL01"
                export WEBAPPS="imp_coll"
             ;;
            twcimp02)
               export APPSERVER_IP="cv-imp_coll02.cv.prod"
               export INSTANCE="TWC_IMPCOL01"
               export WEBAPPS="imp_coll"
            ;;
             coximp03)
                export APPSERVER_IP="cv-imp_coll03.cv.prod"
                export INSTANCE="COX_IMPCOL01"
                export WEBAPPS="imp_coll"
             ;;
          esac
          if [[ ${StealthDeploy} = "Yes" ]] ; then
             fnDeployAppNoRestart
          else
             fnDeployApp
          fi
        done
       ;;
# -Ad-Load-Manager
    ad-load-manager)
       fnInitRpt
       export APP="alm-server"
       export ALMComps="COX_ALM01 COX_ALM02"
        for i in $ALMComps; do
          case $i in
             COX_ALM01)
                export APPSERVER_IP="cv-alm01.cv.prod"
                export INSTANCE="COX_ALM01"
                export WEBAPPS="alm"
             ;;
             COX_ALM02)
                export APPSERVER_IP="cv-alm01.cv.prod"
                export INSTANCE="COX_ALM02"
                export WEBAPPS="alm"
             ;;
          esac
          if [[ ${StealthDeploy} = "Yes" ]] ; then
             fnDeployAppNoRestart
          else
             fnDeployApp
          fi
        done
       ;;
# -POIS
    POIS)
       fnInitRpt
       export APP="pois"
       export POISComps="COX_POIS01 COX_POIS02"
        for i in $POISComps; do
          case $i in
             COX_POIS01)
                export APPSERVER_IP="cv-pois01.cv.prod"
                export INSTANCE="COX_POIS01"
                export WEBAPPS="pois"
             ;;
             COX_POIS02)
                export APPSERVER_IP="cv-pois02.cv.prod"
                export INSTANCE="COX_POIS02"
                export WEBAPPS="pois"
             ;;
          esac
          if [[ ${StealthDeploy} = "Yes" ]] ; then
             fnDeployAppNoRestart
          else
             fnDeployApp
          fi
        done
       ;;
    *)
      print "No Deploy...";;
esac
