#!/bin/bash -x 
#######Check function#########

# A function to check to ensure that ensures that the users has seleceted for a db rebuild if they are rolling to a previous version
# of the database.

fnRebuildCheck() {
    echo "------------------------------------------------------"
    echo "Rebuild required to roll back to previous DB Version!"
    echo "------------------------------------------------------"
    echo "Please retry with DB rebuild!"
    exit 1
}

fn_CheckVerWar() {
       Deployed_Version=`ssh tcserver@${APPSERVER_IP} "grep Implementation-Version /opt/tcserver/instances/${INSTANCE}/webapps/${WEBAPP}/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
}

fnADSCoredep() {
      Deployed_Version=`./check_dbversions_lab2lab_${purpose}.sh -a ads-core -e ${DeployTarg}`
      echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

      /opt/build/scripts/tcServerAdmin.sh ${APPSERVER_IP} instances/${INSTANCE} stop
      /opt/build/scripts/tcServerAdmin.sh ${TC_CIS_IP} instances/${TC_CIS_APP} stop
if [[ ${DB_Rebuild} = "Yes" ]] ; then
        cd /opt/build/scripts/lab2lab
        export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"

if [[ $purpose = "base" ]]; then

sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTarg}'
define purpose='${purpose}'
define MSO='${MSO}'
set verify off
@dropUser.${Component}.${DeployTarg}_${purpose}_${MSO}.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema drop failed"
        exit ${STATUS}
      fi
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTarg}'
define purpose='${purpose}'
define MSO='${MSO}'
set verify off
@genUser.${Component}.${DeployTarg}_${purpose}_${MSO}.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema creation failed"
        exit ${STATUS}
      fi

       else

sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTarg}'
define purpose='${purpose}'
set verify off
@dropUser.${Component}.${DeployTarg}_${purpose}.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema drop failed"
        exit ${STATUS}
      fi
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTarg}'
define purpose='${purpose}'
set verify off
@genUser.${Component}.${DeployTarg}_${purpose}.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema creation failed"
        exit ${STATUS}
      fi
 fi
fi

    cd /opt/build/scripts/lab2lab

    ./deployRebuildDb.sh -a ads-core -t ads-core -i ${INSTANCE} -d ${purpose} -f ${ADSENV} -r ${Version} -e ${APPSERVER_IP} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v
      /opt/build/scripts/tcServerAdmin.sh ${APPSERVER_IP} instances/${INSTANCE} start
      /opt/build/scripts/tcServerAdmin.sh ${TC_CIS_IP} instances/${TC_CIS_APP} start

}

##############
# Execute a command and exit on failure.
##############
executeCommand() {

    if [ ${VERBOSE} -eq 1 ] ; then
        echo "Executing : $1"
    fi

    RESULT=`eval "$1"`

    if [ ${VERBOSE} -eq 1 ] ; then
        echo "Result : $RESULT"
    fi

    if [ $? -ne 0 ] ; then
        echo "ERROR: Error executing $1"
        exit 1
    fi
}
##############
# Execute a command. Do not fail on exit.
##############
executeCommandNoFail() {

    if [ ${VERBOSE} -eq 1 ] ; then
        echo "Executing : $1"
    fi

    RESULT=`eval "$1"`

    if [ ${VERBOSE} -eq 1 ] ; then
        echo "Result : $RESULT"
    fi
}

# Setup Environment specific variables
#
case $DeployTarg in
   devint)
   ;;
   lab2lab)
    case $Component in
      MicroDev)
#    export targname="pfmsdai01"
#    export APPSERVER_IP="10.13.18.58"
#    export JDBC_URL="jdbc:oracle:thin:@10.13.19.121:1522:scrum003"
#    export DB_USER="Administrator"
#    export DB_PASS="Perf_test01"
#    export MSDSN="Performance_TEST"
       ;;
     *)
    export SIDTarg="pro001"
    export DBIP="10.13.17.130"
    export JDBC_URL="jdbc:oracle:thin:@10.13.17.130:1522/pro001"
#    export ETL_CAAS="CAAS_CORE"
#    export ETL_BAR="OSS_BAR"
#    export ETL_BILLING="DAI_BILLING"
#    export REPORTING_SCHEMA_NAME="DAI_REPORTING_SAFI"
  ;;
 esac
;;
esac

# Verify User supplies a Username and Purpose for the Deployment
#
if [ -z ${DeployUser} ] ; then
    echo "<h2>User must supply a user name and summary of deploy purpose</h2>"
    exit 1
fi

cd /opt/build/scripts/lab2lab

case $Component in
################################################
   dai-billing) 
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/billing/webapps/dai-billing/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
      echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       /opt/build/scripts/tcServerAdmin.sh ${targname} billing stop
      if [[ ${Clear_Logs} = "Yes" ]] ; then
	echo "Removing log files from dai-billing on ${targname}"
	ClearList=`ssh tcserver@${targname} "ls /opt/tcserver/instances/billing/logs"`
        echo ${ClearList}
        `ssh tcserver@${targname} "rm /opt/tcserver/instances/billing/logs/*log*"`
        echo "--------------------------------------------------"
	ClearList=`ssh tcserver@${targname} "ls /opt/tcserver/instances/billing/logs"`
        echo ${ClearList}
      fi       
       cd /opt/build/scripts
       ./deployapp.sh -a ${Component} -t ${Component} -e ${DeployTarg} -r ${Version} -i billing -v
       echo "${Version}" > /var/www/html/${DeployTarg}/bill.txt
       ;;
################################################
   MicroDev)
     echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
    ./deployjar.sh -a ${Component} -t ${Component} -e ${APPSERVER_IP} -r ${Version} -v -m ${MSDSN}
      undo="undo_${VERSION}"
      echo "MicroDev Component: ${Component} Deploy to: ${DeployTarg} ${targname} at Version: ${Version}"
      echo "targname=$targname"
      echo "APPSERVER_IP=$APPSERVER_IP"
      echo "JDBC_URL=$JDBC_URL"
      echo "DB_USER=$DB_USER"
      echo "DB_PASS=$DB_PASS"
      echo "MSDSN=$MSDSN"
      echo "${Version}" > /var/www/html/${DeployTarg}/MicroDev.txt 
      ;;
################################################
     caas-admin)
       for i in $purpose; do
        case $i in
         base)
           echo "No Base installation"
           exit
         ;;
          fw)
           echo "No FW installation"
           exit
         ;;
          kodiak)
          export APPSERVER_IP="l2lcmtwl01"
          export INSTANCE="caas_admin"
          export WEBAPP="caas_admin"
         ;;
        esac
       done
       Deployed_Version=`ssh tcserver@${APPSERVER_IP} "grep Implementation-Version /opt/tcserver/instances/caas-admin/webapps/caas-admin/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       cd /opt/build/scripts/lab2lab
       ./deployapp.sh -a ${Component} -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
      echo "${Version}" > /var/www/html/${DeployTarg}/caas-admin.txt
      date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
    ;;
################################################
    Dynamic-Ad-Insertion-engine)
       for i in $purpose; do
        case $i in
         base)
          # ADS Section
          export APPSERVER_IP="l2ladstw01"
          export INSTANCE="ads0101"
          export WEBAPP="ads-1.2.0"
          fn_CheckVerWar
          cd /opt/build/scripts/lab2lab
          ./deployapp.sh -a ads -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
          export APPSERVER_IP="l2ladscom01"
          export INSTANCE="ads0201"
          export WEBAPP="ads"
          fn_CheckVerWar
          cd /opt/build/scripts/lab2lab
          ./deployapp.sh -a ads -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
          # PSN Section
          export APPSERVER_IP="l2lpsntw01"
          export INSTANCE="psn0101"
          export WEBAPP="ads-1.2.0"
          echo "<b>Upgrading ${Component} PSN1 from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
          cd /opt/build/scripts/lab2lab
          ./deployapp.sh -a ads -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
          export APPSERVER_IP="l2lpsncom01"
          export INSTANCE="psn0201"
          export WEBAPP="ads"
          echo "<b>Upgrading ${Component} PSN2 from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
          cd /opt/build/scripts/lab2lab
          ./deployapp.sh -a ads -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
          #  CIS Section
          export APPSERVER_IP="l2lcis01"
          export INSTANCE="cis01"
          export WEBAPP="cis-1.2.0"
          echo "<b>Upgrading ${Component} CIS1 from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
          cd /opt/build/scripts/lab2lab
          ./deployapp.sh -a cis -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
          export APPSERVER_IP="l2lcis01"
          export INSTANCE="cis02"
          export WEBAPP="cis"
          echo "<b>Upgrading ${Component} CIS2 from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
          cd /opt/build/scripts/lab2lab
          ./deployapp.sh -a cis -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
         ;;
         fw)
          # ADS Section
          export APPSERVER_IP="l2lpsntwl01"
          export INSTANCE="ADS_FW"
          export WEBAPP="ads_fw"
          fn_CheckVerWar
          cd /opt/build/scripts/lab2lab
          ./deployapp.sh -a ads -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
          # CIS Section
          export APPSERVER_IP="l2lcistwl01"
          export INSTANCE="CIS_FW"
          export WEBAPP="cis-fw"
          echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
          cd /opt/build/scripts/lab2lab
          ./deployapp.sh -a cis -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
         ;;
         kodiak)
          # ADS Section
          export APPSERVER_IP="l2ladstwl01"
          export INSTANCE="ads0101"
          export WEBAPP="ads-1.2.0"
          fn_CheckVerWar
         cd /opt/build/scripts/lab2lab
         ./deployapp.sh -a ads -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
          # PSN Section
          export APPSERVER_IP="l2lpsntwl01"
          export INSTANCE="psn0101"
          export WEBAPP="ads-1.2.0"
          echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
          cd /opt/build/scripts/lab2lab
          ./deployapp.sh -a ads -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
         # CIS Section
          export APPSERVER_IP="l2lcistwl01"
          export INSTANCE="cis01"
          export WEBAPP="cis-1.2.0"
          echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
          cd /opt/build/scripts/lab2lab
          ./deployapp.sh -a cis -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
         ;;
         broadway)
          # ADS Section
          export APPSERVER_IP="l2lbrd02"
          export INSTANCE="BRD_ADS_001"
          export WEBAPP="ads-brd"
          fn_CheckVerWar
         cd /opt/build/scripts/lab2lab
         ./deployapp.sh -a ads -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
        ;;
        esac
       done
       echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/Dynamic-Ad-Insertion-engine.txt
       date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
       ;;
################################################    
    dai-cip-feedback)
       for i in $purpose; do
        case $i in
         base)
          export APPSERVER_IP="l2lcip01"
          export INSTANCE="cip-feedback"
          export WEBAPP="cip-feedback"
         ;;
          fw)
          export APPSERVER_IP="l2lcip01"
          export INSTANCE="CIP_FN_FW"
          export WEBAPP="cip-fn-fw"
         ;;
          kodiak)
          export APPSERVER_IP="l2lciptwl01"
          export INSTANCE="cip-feedback"
          export WEBAPP="cip-feedback"
         ;;
        esac
       fn_CheckVerWar
       cd /opt/build/scripts/lab2lab
       ./deployapp.sh -a cip-server -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
       done
       echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/${Component}.txt 
       date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
       ;;
################################################
    impression_collector)
          export APPSERVER_IP="l2lsmsi01"
          export INSTANCE="impression_collector"
          export WEBAPP="impression_collector_server"
       fn_CheckVerWar
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       cd /opt/build/scripts/lab2lab
       ./deployapp.sh -a impression_collector_server -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
       echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/${Component}.txt
       date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
       ;;
################################################
    dai-metadata-ingestion)
       for i in $purpose; do
        case $i in
         base)
           echo "No Base installation"
           exit
         ;;
          fw)
          export APPSERVER_IP="l2lfwciping01"
         ;;
          kodiak)
           echo "No Kodiak installation"
           exit
         ;;
        esac
       Deployed_Version=`ssh tcserver@${APPSERVER_IP} "cd /opt/tcserver/dai-metadata-ingestion; jar xf ingester.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       cd /opt/build/scripts/lab2lab
       ./deployjar.sh -a ${Component} -t ${Component} -e ${DeployTarg} -r ${Version} -v
       done
       echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/${Component}.txt
       date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
       ;;
################################################
    Dynamic-Ad-Insertion-cm)
       for i in $purpose; do
        case $i in
         base)
          export APPSERVER_IP="l2lcm01"
          export INSTANCE="cm_40"
          export WEBAPP="cm"
         ;;
          fw)
          export APPSERVER_IP="l2lcm01"
          export INSTANCE="FW_CM"
          export WEBAPP="cm_fw"
         ;;
          kodiak)
          export APPSERVER_IP="l2lcmtwl01"
          export INSTANCE="cm_40"
          export WEBAPP="cm"
         ;;
          broadway)
          export APPSERVER_IP="l2lbrd01"
          export INSTANCE="CampMan_BRD"
          export WEBAPP="cm-brd"
         ;;
        esac
        fn_CheckVerWar
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
        cd /opt/build/scripts/lab2lab
        ./deployapp.sh -a ${Component} -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
       done
      echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/${Component}.txt
      date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
       ;;
################################################
#    int-test-support)
#        export targname="pffwmock01"
#        Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/mocksvr01/webapps/int-test-support/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
#       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
#       export APPSERVER_IP="pffwmock01"
#       export INSTANCE="mocksvr01"
#       cd /opt/build/scripts/lab2lab
#       ./deployapp.sh -a int-test-support -t ${Component} -e ${DeployTarg} -r ${Version} -i mocksvr01 -v
#       echo "${Version} > /var/www/html/${Deploytarg}/int-test-support.txt"
#       ;;
################################################
    dai-smsi)
       for i in $purpose; do
        case $i in
         base)
          export APPSERVER_IP="l2lsmsi01"
          export INSTANCE="smsi"
          export WEBAPP="smsi"
         ;;
          fw)
          export APPSERVER_IP="l2lfwciping01"
          export INSTANCE="FW_SMSI"
          export WEBAPP="smsi_fw"
         ;;
          kodiak)
          export APPSERVER_IP="l2lsmsitwl01"
          export INSTANCE="smsi"
          export WEBAPP="smsi"
         ;;
          broadway)
          export APPSERVER_IP="l2lbrd03"
          export INSTANCE="BRD_SMSI"
          export WEBAPP="smsi_brd"
         ;;
        esac
       fn_CheckVerWar
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       cd /opt/build/scripts/lab2lab
        ./deployapp.sh -a safi-smsi-server -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
       echo "${Version} > /var/www/html/${DeployTarg}/${purpose}/dai-smsi.txt"
       date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
       done
       ;;
################################################
    old_dai-cip)
      for i in $purpose; do
       case $i in
        base)
         export APPSERVER_IP="l2lcip01"
        ;;
         fw)
         export APPSERVER_IP="l2lfwciping01"
        ;;
         kodiak)
         export APPSERVER_IP="l2lciptwl01"
        ;;
       esac
       Deployed_Version=`ssh tcserver@${APPSERVER_IP} "cd /opt/tcserver/dai-cip/cip-batch; jar xf dai-cip-batch.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       ssh tcserver@${APPSERVER_IP} "cd dai-cip/cip-immediate; ./cipstartstop.sh stop"
       ssh tcserver@${APPSERVER_IP} "cd dai-cip/cip-batch; ./cipstartstop.sh stop"
       cd /opt/build/scripts/lab2lab
       ./deployjar.sh -a dai-cip -t ${Component} -e ${APPSERVER_IP} -r ${Version} -v 
       echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/dai-cip.txt
       date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
       done
       ;;
################################################
    dai-cip)
      for i in $purpose; do
       case $i in
        base)
         export APPSERVER_IP="l2lcip01"
        ;;
         fw)
         export APPSERVER_IP="l2lfwciping01"
        ;;
         kodiak)
         export APPSERVER_IP="l2lciptwl01"
        ;;
         broadway)
         export APPSERVER_IP="l2lbrd01"
        ;;
       esac
       Deployed_Version=`ssh tcserver@${APPSERVER_IP} "cd /opt/tcserver/dai-cip/bin; jar xf dai-cip.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       ssh tcserver@${APPSERVER_IP} "cd dai-cip/; ./launcher.sh stop"
       cd /opt/build/scripts/lab2lab
       ./deployjar.sh -a dai-cip -t ${Component} -e ${APPSERVER_IP} -r ${Version} -v
       echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/dai-cip.txt
       date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
       done
       ;;
################################################
    Pgmr-Cpgn-Int)
     for i in $purpose; do
      case $i in
       base)
           export APPSERVER_IP="l2lpci01"
           export INSTANCE="CIP_ING_01"
           export WEBAPP="cip-ingest"
           export DB_USER="PCI_BASE"
           export DB_PASS="PCI_BASE"
           ;;
       fw)
          export APPSERVER_IP="l2lfwciping01"
          export INSTANCE="FW_CIP_ING_01"
          export WEBAPP="fw_cip-ingest"
          export DB_USER="PCI_FW"
          export DB_PASS="PCI_FW"
          ;;
       kodiak)
          export APPSERVER_IP="l2lpciggl01"
          export INSTANCE="GL_CIP_ING_01"
          export WEBAPP="gl_cip-ingest"
          export DB_USER="PCI_KODIAK"
          export DB_PASS="PCI_KODIAK"
          ;;
       broadway)
          export APPSERVER_IP="l2lbrd01"
          export INSTANCE="BRD_CIP_ING_01"
          export WEBAPP="brd_cip-ingest"
          export DB_USER="PCI_BRD"
          export DB_PASS="PCI_BRD"
          ;;
      esac
      fn_CheckVerWar
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
      cd /opt/build/scripts/lab2lab
      /opt/build/scripts/tcServerAdmin.sh ${APPSERVER_IP} instances/${INSTANCE} stop

      if [[ ${DB_Rebuild} = "Yes" ]] ; then
       cd /opt/build/scripts/lab2lab
       export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTarg}'
define purpose='${purpose}'
set verify off
@dropUser.${Component}.${DeployTarg}_${purpose}.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema drop failed"
        exit ${STATUS}
      fi
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTarg}'
define purpose='${purpose}'
set verify off
@genUser.${Component}.${DeployTarg}_${purpose}.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema creation failed"
        exit ${STATUS}
      fi
    fi
      ./deployRebuildDb.sh -a pci -t ${Component} -i ${INSTANCE} -r ${Version} -e ${APPSERVER_IP} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v
       ./deployapp.sh -a pci -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
       echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/${Component}.txt
       date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
      done
      ;;
################################################   
    dai-lincoln)
        Deployed_Version=`ssh tcserver@${targname} "cd /opt/tcserver/log_splitter; jar xf lincoln-1.2.0.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       cd /opt/build/scripts
       ./deployjar.sh -a dai-lincoln -t ${Component} -e ${DeployTarg} -r ${Version} -v
       echo "${Version}" > /var/www/html/${DepolyTarg}/log.txt
       ;;
################################################
    dai-smsi-relay)
       for i in $purpose; do
        case $i in
         base)
          export APP_IP="l2lsmsi01"
          export APP_IN="smsi"
          export APPSERVER_IP="l2lsmsr01"
          export INSTANCE="smsi-relay"
          export WEBAPP="smsi-relay-client"
          export DB_USER="SMSI_RELAY"
          export DB_PASS="SMSI_RELAY"
          export LiqBaOPTS="-DCAMPAIGN_SCHEMA_NAME=CAAS40"
          echo "LiqBaOPTS=$LiqBaOPTS  - APP=$APP"
         ;;
          fw)
          export APP_IP="l2lfwciping01"
          export APP_IN="FW_SMSI"
          export APPSERVER_IP="l2lfwciping01"
          export INSTANCE="FW_SMSI_RELAY"
          export WEBAPP="fw_smsi-relay"
          export DB_USER="SMSI_RELAY_FW"
          export DB_PASS="SMSI_RELAY_FW"
          export LiqBaOPTS="-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE_FW"
          echo "LiqBaOPTS=$LiqBaOPTS  - APP=$APP"
         ;;
          kodiak)
          export APP_IP="l2lsmsitwl01"
          export APP_IN="smsi"
          export APPSERVER_IP="l2lsmsitwl01"
          export INSTANCE="GL_SMSI_RELAY"
          export WEBAPP="GL_SMSI_RELAY"
          export DB_USER="SMSI_RELAY_GL"
          export DB_PASS="SMSI_RELAY_GL"
          export LiqBaOPTS="-DCAMPAIGN_SCHEMA_NAME=CAAS_LOCAL"
          echo "LiqBaOPTS=$LiqBaOPTS  - APP=$APP"
         ;;
          broadway)
          export APP_IP="l2lbrd03"
          export APP_IN="BRD_SMSI"
          export APPSERVER_IP="l2lbrd03"
          export INSTANCE="BRD_SMSI_RELAY"
          export WEBAPP="brd_smsi-relay"
          export DB_USER="SMSI_RELAY_BRD"
          export DB_PASS="SMSI_RELAY_BRD"
          export LiqBaOPTS="-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE_BRD"
          echo "LiqBaOPTS=$LiqBaOPTS  - APP=$APP"
         ;;
        esac

        /opt/build/scripts/tcServerAdmin.sh ${APP_IP} instances/${APP_IN} stop
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

      if [[ ${DB_Rebuild} = "Yes" ]] ; then
        cd /opt/build/scripts/lab2lab
        export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTar}'
define purpose='${purpose}'
set verify off
@dropUser.${Component}.${DeployTarg}_${purpose}.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema drop failed"
        exit ${STATUS}
      fi
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTar}'
define purpose='${purpose}'
set verify off
@genUser.${Component}.${DeployTarg}_${purpose}.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema creation failed"
        exit ${STATUS}
      fi
    fi
    cd /opt/build/scripts/lab2lab
    fn_CheckVerWar
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       ./deployRebuildDb.sh -a smsi-relay-client -t ${Component} -i ${INSTANCE} -r ${Version} -e ${APPSERVER_IP} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v

       ./deployapp.sh -a smsi-relay-client -t ${Component} -e ${APPSERVER_IP} -i ${INSTANCE} -r ${Version} -v
       done

        /opt/build/scripts/tcServerAdmin.sh ${APP_IP} instances/${APP_IN} start

       echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/dai-smsi-relay.txt
       date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
       ;;
################################################          
    oss_bar)
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/oss_bar/webapps/oss_bar/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
      echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       /opt/build/scripts/tcServerAdmin.sh ${targname} oss_bar stop
       cd /opt/build/scripts
       ./kill_dbsessions.sh -a oss_bar -e ${DeployTarg}
       if [[ ${DB_Rebuild} = "Yes" ]] ; then
        cd /opt/cvbuild/wa/DB_Extracts; mkdir ${BUILD_TAG}; cd ${BUILD_TAG}
        echo "Extracting DB creation scripts for ${Version} of ${Component}"
        tar -xvf /opt/build/releaseTars/${Component}/${Component}_${Version}.tar liquibase/cisys
        cd liquibase/cisys
        export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
sqlplus -S cm_system/oracle123@$SQLCONN <<!
set heading off
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
      if [[ ${Clear_Logs} = "Yes" ]] ; then
	echo "Removing log files from oss_bar on ${targname}"
	ClearList=`ssh tcserver@${targname} "ls /opt/tcserver/instances/oss_bar/logs"`
        echo ${ClearList}
        `ssh tcserver@${targname} "rm /opt/tcserver/instances/oss_bar/logs/*log*"`
        echo "--------------------------------------------------"
	ClearList=`ssh tcserver@${targname} "ls /opt/tcserver/instances/oss_bar/logs"`
        echo ${ClearList}
       fi 
       cd /opt/build/scripts
       ./deploy.sh -a oss_bar -e ${DeployTarg} -r ${Version}
       echo "${Version}" > /var/www/html/${DeployTarg}/oss_bar.txt
       ;;
################################################
    smsi-admin)
      Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/smsi-admin/webapps/smsi-admin/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
     echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       if [[ ${Clear_Logs} = "Yes" ]] ; then
	echo "Removing log files from smsi-admin on ${targname}"
	ClearList=`ssh tcserver@${targname} "ls /opt/tcserver/instances/smsi-admin/logs"`
        echo ${ClearList}
        `ssh tcserver@${targname} "rm /opt/tcserver/instances/smsi-admin/logs/*log*"`
        echo "--------------------------------------------------"
	ClearList=`ssh tcserver@${targname} "ls /opt/tcserver/smsi-admin/billing/logs"`
        echo ${ClearList}
       fi 
       cd /opt/build/scripts
       ./deployapp.sh -a smsi-admin -t ${Component} -e ${DeployTarg} -r ${Version} -i smsi-admin -v
       echo "${Version}" > /var/www/html/${DeployTarg}/smsi-admin.txt
       date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
       ;;
################################################
    metadata-publisher)
       cd /opt/build/scripts/lab2lab
       for i in $purpose; do
        case $i in
         base)
          export APPSERVER_IP="l2lacpmdpub01"
          export INSTANCE="metadata-publisher"
          export WEBAPP="metadata-publisher"
         ;;
          fw)
          export APPSERVER_IP="l2lacpmdpub02"
          export INSTANCE="metadata-publisher"
          export WEBAPP="metadata-publisher"
         ;;
        esac
       fn_CheckVerWar
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       done
       cd /opt/build/scripts/lab2lab
       ./deployapp.sh -a publisher -t ${Component} -e ${DeployTarg} -r ${Version} -i metadata-publisher -v
       echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/${Component}.txt
       date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
       ;;
################################################
    acp)
       cd /opt/build/scripts/lab2lab
       for i in $purpose; do
        case $i in
         base)
          export APPSERVER_IP="l2lacpmdpub01"
         ;;
          fw)
          export APPSERVER_IP="l2lacpmdpub02"
         ;;
         kodiak)
           echo "No Kodiak/Google installation"
           exit
         ;;
        esac
       Deployed_Version=`ssh tcserver@${APPSERVER_IP} "cd /opt/tcserver/acp/bin; jar xf acp.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
       done
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       cd /opt/build/scripts/lab2lab
       echo "./deployjar.sh -a ${Component} -t ${Component} -e ${DeployTarg} -r ${Version} -v"
       ./deployjar.sh -a ${Component} -t ${Component} -e ${DeployTarg} -r ${Version} -v
       echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/${Component}.txt
       date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
       ;;
################################################
    dai-national-cis)
       cd /opt/build/scripts/lab2lab
       for i in $purpose; do
        case $i in
         base)
           echo "No Base installation"
           exit
         ;;
          fw)
          export APPSERVER_IP="l2lcis01"
          export INSTANCE="dai-national-cis"
          export WEBAPP="nCisClient"
          export DB_USER="NCIS_FW"
          export DB_PASS="FREEWHEEL"
	  export LiqBaOPTS="-DCAAS_SCHEMA_NAME=CAAS_CORE_FW"
  	  echo "LiqBaOPTS=$LiqBaOPTS  - APP=$Component"
         ;;
          kodiak)
           echo "No Kodiak installation"
           exit 1
         ;;
        esac
#       Deployed_Version=`./check_dbversions_lab2lab_${purpose}.sh -a dai-national-cis -e lab2lab`
        fn_CheckVerWar
#      if [[ ${DB_Rebuild} = "No" ]]; then
#        Compcheck=`./compareVersions.sh -n $Version -o $Deployed_Version`
#        if [[ $Compcheck = "-1" ]]; then
#          fnRebuildCheck
#        fi
#      fi

       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

       if [[ ${DB_Rebuild} = "Yes" ]] ; then
        export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTar}'
define purpose='${purpose}'
set verify off
@dropUser.${Component}.${DeployTarg}_${purpose}.sql
exit sql.sqlcode
!
      STATUS=${?}
       if [[ ${STATUS} != "0" ]]; then
        echo "Schema drop failed"
        exit ${STATUS}
       fi
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTar}'
define purpose='${purpose}'
set verify off
@genUser.${Component}.${DeployTarg}_${purpose}.sql
exit sql.sqlcode
!
      STATUS=${?}
       if [[ ${STATUS} != "0" ]]; then
        echo "Schema creation failed"
        exit ${STATUS}
       fi
       fi
       cd /opt/build/scripts/lab2lab
       ./deployapp.sh -a ${WEBAPP} -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
       echo " After deployapp.sh | $?"
       ./deployRebuildDb.sh -a ${Component} -t ${Component} -i ${INSTANCE} -r ${Version} -e ${APPSERVER_IP} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v
        if [ $? -ne 0 ] ; then
         print ERROR: Error executing $1
         exit 1
        fi
       done
       echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/${Component}.txt
       date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
       ;;
################################################
    smsi-publisher)
       cd /opt/build/scripts/lab2lab
       for i in $purpose; do
        case $i in
         base)
          export APPSERVER_IP="l2lsmspub01"
          export INSTANCE="smsi-pub"
          export WEBAPP="smsi-pub"
          export DB_USER="SMSI_PUB"
          export DB_PASS="SMSI_PUB" 
          export TC_ADS_IP1="l2ladstw01"
          export TC_ADS_APP1="ads0101"
          export TC_ADS_IP2="l2ladscom01"
          export TC_ADS_APP2="ads0201"
          export TC_PSN_IP1="l2lpsntw01"
          export TC_PSN_APP1="psn0101"
          export TC_PSN_IP2="l2lpsncom01"
          export TC_PSN_APP2="psn0201"
          export TC_CIS_IP1="l2lcis01"
          export TC_CIS_APP1="cis01"
          export TC_CIS_IP2="l2lcis01"
          export TC_CIS_APP2="cis02"
           /opt/build/scripts/tcServerAdmin.sh ${TC_ADS_IP1} instances/${TC_ADS_APP1} stop
           /opt/build/scripts/tcServerAdmin.sh ${TC_PSN_IP1} instances/${TC_PSN_APP1} stop
           /opt/build/scripts/tcServerAdmin.sh ${TC_CIS_IP1} instances/${TC_CIS_APP1} stop
           /opt/build/scripts/tcServerAdmin.sh ${TC_ADS_IP2} instances/${TC_ADS_APP2} stop
           /opt/build/scripts/tcServerAdmin.sh ${TC_PSN_IP2} instances/${TC_PSN_APP2} stop
           /opt/build/scripts/tcServerAdmin.sh ${TC_CIS_IP2} instances/${TC_CIS_APP2} stop
         ;;
          fw)
          export APPSERVER_IP="l2lsmspubtwl01"
          export INSTANCE="SMSI_PUB_FW"
          export WEBAPP="smsi-pub"
          export DB_USER="SMSI_PUB_FW"
          export DB_PASS="FREEWHEEL"
          export TC_ADS_IP1="l2lpsntwl01"
          export TC_ADS_APP1="ADS_FW"
          export TC_CIS_IP1="l2lcistwl01"
          export TC_CIS_APP1="CIS_FW"
          /opt/build/scripts/tcServerAdmin.sh ${TC_ADS_IP1} /${TC_ADS_APP1} stop
          /opt/build/scripts/tcServerAdmin.sh ${TC_CIS_IP1} /${TC_CIS_APP1} stop
         ;;
          kodiak)
          export APPSERVER_IP="l2lsmspubtwl01"
          export INSTANCE="smsi-pub"
          export WEBAPP="smsi-pub"
          export DB_USER="SMSI_PUB_TWL"
          export DB_PASS="KODIAK"
         ;;
          broadway)
          export APPSERVER_IP="l2lbrd02"
          export INSTANCE="smsi-pub"
          export WEBAPP="smsi-pub"
          export DB_USER="SMSI_PUB_BRD"
          export DB_PASS="SMSI_PUB_BRD"
         ;;
        esac
        fn_CheckVerWar
#        Deployed_Version=`./check_dbversions_lab2lab_${purpose}.sh -a smsi-publisher -e ${DeployTarg}`

        if [[ ${DB_Rebuild} = "Yes" ]] ; then
        /opt/build/scripts/tcServerAdmin.sh ${APPSERVER_IP} /${INSTANCE} stop
        cd /opt/build/scripts/lab2lab
        export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTar}'
define purpose='${purpose}'
set verify off
@dropUser.${Component}.${DeployTarg}_${purpose}.sql
exit sql.sqlcode
!
      STATUS=${?}
       if [[ ${STATUS} != "0" ]]; then
        echo "Schema drop failed"
        exit ${STATUS}
       fi
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTar}'
define purpose='${purpose}'
set verify off
@genUser.${Component}.${DeployTarg}_${purpose}.sql
exit sql.sqlcode
!
      STATUS=${?}
       if [[ ${STATUS} != "0" ]]; then
        echo "Schema creation failed"
        exit ${STATUS}
       fi
       fi

#        echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
        cd /opt/build/scripts/lab2lab    

       ./deployapp.sh -a smsi-pub -t smsi-publisher -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
       ./deployRebuildDb.sh -a smsi-pub -t smsi-publisher -i ${INSTANCE} -r ${Version} -e ${APPSERVER_IP} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v
       done
        case $purpose in
         base)
           /opt/build/scripts/tcServerAdmin.sh ${TC_ADS_IP1} instances/${TC_ADS_APP1} start
           /opt/build/scripts/tcServerAdmin.sh ${TC_PSN_IP1} instances/${TC_PSN_APP1} start
           /opt/build/scripts/tcServerAdmin.sh ${TC_CIS_IP1} instances/${TC_CIS_APP1} start
           /opt/build/scripts/tcServerAdmin.sh ${TC_ADS_IP2} instances/${TC_ADS_APP2} start
           /opt/build/scripts/tcServerAdmin.sh ${TC_PSN_IP2} instances/${TC_PSN_APP2} start
           /opt/build/scripts/tcServerAdmin.sh ${TC_CIS_IP2} instances/${TC_CIS_APP2} start
         ;;
          fw)
          /opt/build/scripts/tcServerAdmin.sh ${TC_ADS_IP1} instances/${TC_ADS_APP1} start
          /opt/build/scripts/tcServerAdmin.sh ${TC_CIS_IP1} instances/${TC_CIS_APP1} start
         ;;
        esac
       echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/smsi-publisher.txt
       date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
       ;;

################################################
    caas-core)
      cd /opt/build/scripts/lab2lab
       for i in $purpose; do
        case $i in
         base)
           export APPSERVER_IP="l2lcip01"
           export INSTANCE="cip-feedback"
           export DB_USER="CAAS40"
           export DB_PASS="CAAS40"
           export TC_CIP_IP="l2lcip01"
           export TC_CIP_APP="cip-feedback"
           export TC_CM_IP="l2lcm01"
           export TC_CM_APP="cm_40"
           export TC_CA_IP="l2lcm01"
           export TC_CA_APP="caas_admin"
           export TC_MD_IP="l2lacpmdpub01"
           export TC_MD_APP="metadata-publisher"
           export TC_PCI_IP="l2lpci01"
           export TC_PCI_APP="CIP_ING_01"
           export CIP_IP="l2lcip01"
         ;;
          fw)
          export APPSERVER_IP="l2lcip01"
          export INSTANCE="CIP_FN_FW"
          export DB_USER="CAAS_CORE_FW"
          export DB_PASS="FREEWHEEL"
          export TC_CIP_IP="l2lcip01"
          export TC_CIP_APP="CIP_FN_FW"
          export TC_CM_IP="l2lcm01"
          export TC_CM_APP="FW_CM"
          export TC_MD_IP="l2lacpmdpub02"
          export TC_MD_APP="metadata-publisher"
          export TC_PCI_IP="l2lfwciping01"
          export TC_PCI_APP="FW_CIP_ING_01"
          export TC_SMS_IP="l2lfwciping01"
          export TC_SMS_APP="FW_SMSI"
          export CIP_IP="l2lfwciping01"
         ;;
          kodiak)
          export APPSERVER_IP="l2lciptwl01"
          export INSTANCE="cip-feedback"
          export DB_USER="CAAS_LOCAL"
          export DB_PASS="KODIAK"
          export TC_CIP_IP="l2lciptwl01"
          export TC_CIP_APP="cip-feedback"
          export TC_CM_IP="l2lcmtwl01"
          export TC_CM_APP="cm_40"
          export TC_CA_IP="l2lcmtwl01"
          export TC_CA_APP="caas_admin"
          export TC_PCI_IP="l2lpciggl01"
          export TC_PCI_APP="GL_CIP_ING_01"
          export CIP_IP="l2lciptwl01"
         ;;
          broadway)
          export APPSERVER_IP="l2lbrd01"
          export INSTANCE="CampMan_BRD"
          export DB_USER="CAAS_CORE_BRD"
          export DB_PASS="BROADWAY"
          export TC_CIP_IP="l2lbrd01"
         # export TC_CIP_APP=""
          export TC_CM_IP="l2lbrd01"
          export TC_CM_APP="CampMan_BRD"
          export TC_PCI_IP="l2lbrd01"
          export TC_PCI_APP="BRD_CIP_ING_01"
          export CIP_IP="l2lbrd01"
         ;;
        esac
       cd /opt/build/scripts/lab2lab
       Deployed_Version=`./check_dbversions_lab2lab_${purpose}.sh -a caas-core -e ${DeployTarg}`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
        /opt/build/scripts/tcServerAdmin.sh ${TC_CIP_IP} instances/${TC_CIP_APP} stop
        /opt/build/scripts/tcServerAdmin.sh ${TC_CM_IP} /${TC_CM_APP} stop
        /opt/build/scripts/tcServerAdmin.sh ${TC_CA_IP} /${TC_CA_APP} stop
        /opt/build/scripts/tcServerAdmin.sh ${TC_MD_IP} instances/${TC_MD_APP} stop
        /opt/build/scripts/tcServerAdmin.sh ${TC_PCI_IP} instances/${TC_PCI_APP} stop
        /opt/build/scripts/tcServerAdmin.sh ${TC_SMS_IP} instances/${TC_SMS_APP} stop
        ssh tcserver@${TC_MD_IP} "cd acp; ./launcher.sh stop"
        ssh tcserver@${CIP_IP} "cd dai-cip/cip-immediate; ./cipstartstop.sh stop"
        ssh tcserver@${CIP_IP} "cd dai-cip/cip-batch; ./cipstartstop.sh stop"
       #./kill_dbsessions.sh -a caas-core -e ${DeployTarg}
      if [[ ${DB_Rebuild} = "Yes" ]] ; then
       cd /opt/build/scripts/lab2lab
       export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off;
set feedback on;
set echo on;
define DB_USER='$DB_USER'
set verify on
set serveroutput on
@/opt/build/scripts/lab2lab/drop_flshbk.sql
exit
!
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTarg}'
define purpose='${purpose}'
set verify off
@dropUser.${Component}.${DeployTarg}_${purpose}.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema creation failed"
        exit ${STATUS}
      fi

sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTarg}'
define purpose='${purpose}'
set verify off
@genUser.${Component}.${DeployTarg}_${purpose}.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema creation failed"
        exit ${STATUS}
      fi
    fi
    cd /opt/build/scripts/lab2lab
    echo "Running:  ./deployRebuildDb.sh -a caas-core -t caas-core -i ${INSTANCE} -r ${Version} -d ${purpose} -e ${APPSERVER_IP} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v"
    ./deployRebuildDb.sh -a caas-core -t caas-core -i ${INSTANCE} -r ${Version} -d ${purpose} -e ${APPSERVER_IP} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v

    cd /opt/build/scripts/lab2lab
### Mike's metadata-sync project run for trigger enablement
#    if [[ ${DB_Rebuild} = "Yes" ]] ; then
#JWS424      Trig_Version=`cat /opt/build/releaseTars/metadata-sync/latest`
#JWS424      echo $Trig_Version
#JWS424      ./deployjar.sh -a metadata-sync -t metadata-sync -e lab2lab -d ${purpose} -r ${Trig_Version}
#   fi
###  End Trigger setup
       /opt/build/scripts/tcServerAdmin.sh ${TC_CIP_IP} instances/${TC_CIP_APP} start
       /opt/build/scripts/tcServerAdmin.sh ${TC_CM_IP} /${TC_CM_APP} start
       /opt/build/scripts/tcServerAdmin.sh ${TC_CA_IP} /${TC_CA_APP} start
       /opt/build/scripts/tcServerAdmin.sh ${TC_MD_IP} instances/${TC_MD_APP} start
       /opt/build/scripts/tcServerAdmin.sh ${TC_PCI_IP} instances/${TC_PCI_APP} start
       /opt/build/scripts/tcServerAdmin.sh ${TC_SMS_IP} instances/${TC_SMS_APP} start
    echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/caas-core.txt
    date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
    done
;;
################################################
    ads-core)
      cd /opt/build/scripts/lab2lab
       for i in $purpose; do
        case $i in
         base)
          bases="twc com"
          for j in $bases; do
            case $j in
              twc)
                 export MSO="twc"
                 export APPSERVER_IP="l2ladstw01"
                 export INSTANCE="ads0101"
                 export TC_CIS_IP="l2lcis01"
                 export TC_CIS_APP="cis01"
                 export DB_USER="ADS_CORE_TWC"
                 export DB_PASS="ADS_CORE_TWC"
                 export ADSENV="prod"
                 fnADSCoredep
               ;;
              com)
                 export MSO="com"
                 export APPSERVER_IP="l2ladscom01"
                 export INSTANCE="ads0201"
                 export TC_CIS_IP="l2lcis01"
                 export TC_CIS_APP="cis02"
                 export DB_USER="ADS_CORE_COM"
                 export DB_PASS="ADS_CORE_COM"
                 export ADSENV="dev"
                 fnADSCoredep
               ;;
            esac
          done
         ;;
          fw)
          export APPSERVER_IP="l2lpsntwl01"
          export INSTANCE="ADS_FW"
          export DB_USER="ADS_CORE_FW"
          export DB_PASS="FREEWHEEL"
          export ADSENV="prod"
          fnADSCoredep
         ;;
          kodiak)
          export APPSERVER_IP="l2ladstwl01"
          export INSTANCE="ads0101"
          export DB_USER="ADS_CORE_TWC_L"
          export DB_PASS="KODIAK"
          export ADSENV="prod"
          fnADSCoredep
         ;;
          broadway)
          export APPSERVER_IP="l2lbrd02"
          export INSTANCE="BRD_ADS_001"
          export DB_USER="ADS_CORE_BRD"
          export DB_PASS="BROADWAY"
          export ADSENV="prod"
          fnADSCoredep
         ;;
        esac
    echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/ads-core.txt
    date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
   done

;;
################################################
    smsi_reporting)

      for i in $purpose; do
       case $i in
         base)
           echo "No Base installation"
           exit
         ;;
          fw)
           echo "No FW installation"
           exit
         ;;
         kodiak)
          export DB_USER="L2L_SMSI_RPTG"
          export DB_PASS="L2L_SMSI_RPTG"
          export CAMPAIGN_SCHEMA_NAME="CAAS_LOCAL"
          export REPORTING_SCHEMA_NAME="DAI_REPORTING_SAFI_TWL"
          export SMSI_REL_APP="smsi"
        ;;
       esac
#      /opt/build/scripts/tcServerAdmin.sh ${APPSERVER_IP} instances/${SMSI_REL_APP} stop

      cd /opt/build/scripts/lab2lab
      echo "Running check_dbversions_lab2lab_${purpose}.sh -a dai-etl-feeder -e ${DeployTarg}"
#      Deployed_Version=`./check_dbversions_lab2lab_${purpose}.sh -a dai-etl-feeder -e ${DeployTarg}`
      echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

    if [[ ${DB_Rebuild} = "Yes" ]] ; then
      #./kill_dbsessions.sh -a dai-etl-feeder -e ${DeployTarg}

      export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTarg}'
define purpose='${purpose}'
set verify off
@dropUser.${Component}.${DeployTarg}_${purpose}.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema drop failed"
        exit ${STATUS}
      fi
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTarg}'
define purpose='${purpose}'
set verify off
@genUser.${Component}.${DeployTarg}_${purpose}.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema creation failed.  Are there users sessions that need to be destroyed?"
        exit ${STATUS}
      fi
    fi
    cd /opt/build/scripts/lab2lab

     ./deployJarRebuild.sh -a ${Component} -t ${Component} -e ${APPSERVER_IP} -d ${purpose} -r ${Version} -j "${JDBC_URL}" -p ${DB_PASS}  -u ${DB_USER} -c ${ETL_CAAS} -w ${REPORTING_SCHEMA_NAME} -v

#      /opt/build/scripts/tcServerAdmin.sh ${APPSERVER_IP} instances/${INSTANCE} start
#     /opt/build/scripts/tcServerAdmin.sh instances/${SMSI_REL_APP} start

    echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/dai-etl-feeder.txt
    date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
    done
;;
################################################
    dai-etl-feeder)

      for i in $purpose; do
       case $i in
        base)
          export APPSERVER_IP="l2lsmsi01"
          export INSTANCE="smsi"
          export DB_USER="DAI_REPORTING_SAFI"
          export DB_PASS="DAI_REPORTING_SAFI"
          export ETL_CAAS="CAAS40"
          export REPORTING_SCHEMA_NAME="${DB_USER}" 
          export SMSI_APP="l2lsmsi01 smsi"
        ;;
         fw)
          export APPSERVER_IP="l2lfwciping01"
          export INSTANCE="FW_SMSI"
          export DB_USER="DAI_REPORTING_SAFI_FW"
          export DB_PASS="FREEWHEEL"
          export ETL_CAAS="CAAS_CORE_FW"
          export REPORTING_SCHEMA_NAME="${DB_USER}"
          export SMSI_APP="l2lfwciping01 FW_SMSI"
          export SMSI_REL_APP="l2lfwciping01 FW_SMSI_RELAY"
        ;;
         kodiak)
          export APPSERVER_IP="l2lsmsitwl01"
          export INSTANCE="smsi"
          export DB_USER="DAI_REPORTING_SAFI_TWL"
          export DB_PASS="KODIAK"
          export ETL_CAAS="CAAS_LOCAL"
          export REPORTING_SCHEMA_NAME="${DB_USER}"
          export SMSI_REL_APP="smsi"
        ;;
         broadway)
          export APPSERVER_IP="l2lbrd03"
          export INSTANCE="smsi"
          export DB_USER="DAI_REPORTING_SAFI_BRD"
          export DB_PASS="DAI_REPORTING_SAFI_BRD"
          export ETL_CAAS="CAAS_CORE_BRD"
          export REPORTING_SCHEMA_NAME="${DB_USER}"
          export SMSI_REL_APP="BRD_SMSI_RELAY"
        ;;
       esac
      /opt/build/scripts/tcServerAdmin.sh ${APPSERVER_IP} instances/${SMSI_REL_APP} stop

      cd /opt/build/scripts/lab2lab
      echo "Running check_dbversions_lab2lab_${purpose}.sh -a dai-etl-feeder -e ${DeployTarg}"
      Deployed_Version=`./check_dbversions_lab2lab_${purpose}.sh -a dai-etl-feeder -e ${DeployTarg}`
      echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

    if [[ ${DB_Rebuild} = "Yes" ]] ; then
      #./kill_dbsessions.sh -a dai-etl-feeder -e ${DeployTarg}
 
      export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTarg}'
define purpose='${purpose}'
set verify off
@dropUser.${Component}.${DeployTarg}_${purpose}.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema drop failed"
        exit ${STATUS}
      fi
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
define Component='${Component}'
define DeployTarg='${DeployTarg}'
define purpose='${purpose}'
set verify off
@genUser.${Component}.${DeployTarg}_${purpose}.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema creation failed.  Are there users sessions that need to be destroyed?"
        exit ${STATUS}
      fi
    fi
    cd /opt/build/scripts/lab2lab

     ./deployJarRebuild.sh -a ${Component} -t ${Component} -e ${APPSERVER_IP} -d ${purpose} -r ${Version} -j "${JDBC_URL}" -p ${DB_PASS}  -u ${DB_USER} -c ${ETL_CAAS} -w ${REPORTING_SCHEMA_NAME} -v

      /opt/build/scripts/tcServerAdmin.sh ${APPSERVER_IP} instances/${INSTANCE} start
#     /opt/build/scripts/tcServerAdmin.sh instances/${SMSI_REL_APP} start

    echo "${Version}" > /var/www/html/${DeployTarg}/${purpose}/dai-etl-feeder.txt
    date | awk '{print $2,$3,$4}' > /var/www/html/${DeployTarg}/${purpose}/${Component}.instdate.txt
    done
;;
    *)
      echo "No Deploy...";;
esac

echo "<b>Version: </b>Specified by user<br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
