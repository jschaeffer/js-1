#!/bin/ksh -x

#######Check function#########

#A function to check to ensure that ensures that the users has seleceted for a db rebuild if they are rolling to a previous version of the database.

fnRebuildCheck() {
    echo "------------------------------------------------------"
    echo "Rebuild required to roll back to previous DB Version!"
    echo "------------------------------------------------------"
    echo "Please retry with DB rebuild!"
    exit 1
}


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

# Setup APP/DB specific variables
#
case $Component in
   caas-core)
     export DB_USER="CAAS_CORE"
     export DB_PASS="CAAS_CORE"
     export RACSIDTarg="CIP_PUBLISHER"
     export INSTANCE="cip-feedback"
   ;;
   ads-core)
     export DB_USER="ADS_CORE_MSO1"
     export DB_PASS="ADS_CORE_MSO1"
     export RACSIDTarg="ADS"
     export INSTANCE="ads0101_40"
   ;;
   dai-smsi-relay)
     export RACSIDTarg="SMSI"
   ;;
   dai-etl-feeder)
     export DB_USER="DAI_REPORTING_SAFI" 
     export DB_PASS="DAI_REPORTING_SAFI"
     export RACSIDTarg="SMSI"
     export INSTANCE="smsi_40"
   ;;
   smsi_reporting)
     export DB_USER="SMSI_REPORTING"
     export DB_PASS="SMSI_REPORTING"
     export RACSIDTarg="SMSI"
     export INSTANCE="smsi_40"
   ;;
   ad-load-manager)
     export DB_USER="ALM"
     export DB_PASS="ALM"
     export RACSIDTarg="SMSI"
     export INSTANCE="ad-load-manager"
   ;;
   smsi-publisher)
     export DB_USER="SMSI_PUB"
     export DB_PASS="SMSI_PUB"
     export RACSIDTarg="SMSI"
     export INSTANCE="smsi-pub"
   ;;
   dai-national-cis)
     export DB_USER="NCIS"
     export DB_PASS="NCIS"
     export RACSIDTarg="SMSI"
     export APPSERVER_IP="pfncis01"
     export INSTANCE="dai-national-cis"
   ;;
   dai-dce)
     export DB_USER="DAIDCE"
     export DB_PASS="DAIDCE"
     export RACSIDTarg="bucket"
     export APPSERVER_IP="pfdceap01"
     export INSTANCE="DAI-DCE"
   ;;
   Pgmr-Cpgn-Int)
     export DB_USER="PCI_PERF"
     export DB_PASS="PCI_PERF"
     export APPSERVER_IP="pffwciping01"
     export INSTANCE="FW_CIP_ING_01"
     export RACSIDTarg="CIP_PUBLISHER"
   ;;
esac

# Setup Environment specific variables
#
case $DeployTarg in
   devint)
   ;;
   performance)
    case $Component in
      MicroDev)
    export targname="pfmsdai01"
    export APPSERVER_IP="10.13.18.58"
    export JDBC_URL="jdbc:oracle:thin:@10.13.19.121:1522:scrum003"
    export DB_USER="Administrator"
    export DB_PASS="Perf_test01"
    export MSDSN="Performance_TEST"
       ;;
     *)
    export SIDTarg="bucket"
    export DBIP="10.13.19.67"
    export JDBC_URL="jdbc:oracle:thin:@perf-rac-scan.co.canoe-ventures.com:1522/$RACSIDTarg"
    export ETL_CAAS="CAAS_CORE"
    export ETL_BAR="OSS_BAR"
    export ETL_BILLING="DAI_BILLING"
    export REPORTING_SCHEMA_NAME="DAI_REPORTING_SAFI"
  ;;
 esac
;;
esac

# Verify User supplies a Username and Purpose for the Deployment
#
if [ -z ${DeployUser} ] ; then
    print "<h2>User must supply a user name and summary of deploy purpose</h2>"
    exit 1
fi

cd /opt/build/scripts/perf

case $Component in
################################################
   dai-billing) 
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/billing/webapps/dai-billing/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       if [ ${getVer} = "1" ] ; then
             Version=`ssh tcserver@dvappdai01 "grep Implementation-Version /opt/tcserver/instances/billing/webapps/dai-billing/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       fi
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
       export targname="pfcm01"
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/caas-admin/webapps/caas-admin/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       export APPSERVER_IP="pfcm01"
       export INSTANCE="caas-admin"
       cd /opt/build/scripts/perf
       ./deployapp.sh -a ${Component} -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
      echo "${Version}" > /var/www/html/${DeployTarg}/caas-admin.txt
    ;;
################################################
    Dynamic-Ad-Insertion-engine)
       Deployed_Version=`ssh tcserver@pfadsdai01 "grep Implementation-Version /opt/tcserver/instances/ads0101_40/webapps/ads*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
      echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       cd /opt/build/scripts/perf
       export ADSComponents="ads1 ads2 psn1 psn2 cis1"
       for i in $ADSComponents; do
          case $i in
             ads1)
                export APPSERVER_IP="pfadsdai01"
                export INSTANCE="ads0101_40"
               ./deployapp.sh -a ads -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
               sleep 30
             ;;
             ads2)
                export APPSERVER_IP="pfadsdai02"
                export INSTANCE="ads0201_40"
               ./deployapp.sh -a ads -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
               sleep 30
             ;;
             psn1)
                export APPSERVER_IP="pfpsndai01"
                export INSTANCE="psn0102_40"
              ./deployapp.sh -a ads -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
              sleep 30
             ;;
             psn2)
                export APPSERVER_IP="pfpsndai02"
                export INSTANCE="psn0102_40"
              ./deployapp.sh -a ads -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
              sleep 30
             ;;
             cis1)
                export APPSERVER_IP="pfcis01"
                export INSTANCE="cis02"
              ./deployapp.sh -a cis -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
              sleep 30
             ;;
         esac
       done
       echo "${Version}" > /var/www/html/${DeployTarg}/Dynamic-Ad-Insertion-engine.txt
       ;;
################################################
    dai-national-cis)
       export targname="pfncis01"
       export APPSERVER_IP="pfncis01"
       export INSTANCE="dai-national-cis"
       cd /opt/build/scripts/perf
      Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/dai-natinoal-cis/webapps/nCisClient/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`

       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       /opt/build/scripts/tcServerAdmin.sh ${targname} dai-national-cis stop
      if [[ ${DB_Rebuild} = "No" ]]; then
        Compcheck=`./compareVersions.sh -n $Version -o $Deployed_Version`
        if [[ $Compcheck = "-1" ]]; then
          fnRebuildCheck
        fi
      fi

      if [[ ${DB_Rebuild} = "Yes" ]] ; then
        cd /opt/build/scripts/perf
        export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
sqlplus -S cm_system/Perf0ra@$SQLCONN <<!
set heading off
define DeployTarg='${DB_USER}'
set verify off
@dropUser.${DB_USER}.performance.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema drop failed"
        exit ${STATUS}
      fi
sqlplus -S cm_system/Perf0ra@$SQLCONN <<!
set heading off
define DeployTarg='${DB_USER}'
set verify off
@genUser.${DB_USER}.performance.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema creation failed"
        exit ${STATUS}
      fi
    fi
    cd /opt/build/scripts/perf

    ./deployRebuildDb.sh -a ${Component} -t ${Component} -i ${INSTANCE} -r ${Version} -e ${APPSERVER_IP} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v
    ./deployapp.sh -a nCisClient -t ${Component} -e ${INSTANCE} -r ${Version} -i ${INSTANCE} -v
    echo "${Version}" > /var/www/html/${DeployTarg}/${Component}.txt
       ;;
################################################
    dai-cip-feedback)
       export targname="pfcipdai01"
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/cip-feedback/webapps/cip-feedback*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       export APPSERVER_IP="pfcipdai01"
       export INSTANCE="cip-feedback"
       cd /opt/build/scripts/perf
       ./deployapp.sh -a cip-server -t ${Component} -e ${DeployTarg} -r ${Version} -i ${INSTANCE} -v
       echo "${Version}" > /var/www/html/${DeployTarg}/${Component}.txt 
       ;;
################################################
    Dynamic-Ad-Insertion-cm)
       export targname="pfcm01"
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/cm01/webapps/Dynamic-Ad-Insertion-cm*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       export APPSERVER_IP="pfcm01"
       export INSTANCE="cm01"
       cd /opt/build/scripts/perf
       ./deployapp.sh -a ${Component} -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i cm01 -v
       echo "${Version}" > /var/www/html/${DeployTarg}/Dynamic-Ad-Insertion-cm.txt
       ;;
################################################
    dai-dce)
       export targname="pfdceap01"
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/DAI-DCE/webapps/dai-dce-server/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       export APPSERVER_IP="pfdceap01"
       export INSTANCE="DAI-DCE"
       cd /opt/build/scripts/perf
      /opt/build/scripts/tcServerAdmin.sh pfdceap01 DAI-DCE stop

      if [[ ${DB_Rebuild} = "Yes" ]] ; then
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
define DeployTarg='$DeployTarg'
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
       cd /opt/build/scripts/perf
       ./deployRebuildDb.sh -a dai-dce-server -t ${Component} -i ${INSTANCE} -r ${Version} -e ${APPSERVER_IP} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v
       ./deployapp.sh -a dai-dce-server -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
       echo "${Version}" > /var/www/html/${DeployTarg}/dai-dce.txt
       ;;
################################################
    POIS)
       export targname="pfpois01"
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/POIS/webapps/pois*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       export POISComponents="pois1 pois2"
       for i in $POISComponents; do
        case $i in
         pois1)
          export APPSERVER_IP="pfpois01"
          export INSTANCE="POIS"
          export WEBAPP="pois"
          ;;
         pois2)
          export APPSERVER_IP="pfpois02"
          export INSTANCE="POIS"
          export WEBAPP="pois"
          ;;
        esac
       cd /opt/build/scripts/perf
       ./deployapp.sh -a pois -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
       done
       echo "${Version}" > /var/www/html/${DeployTarg}/Dynamic-Ad-Insertion-cm.txt
       ;;
################################################
    metadata-publisher)
       export targname="pfmdp01"
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/metadata-publsiher/webapps/publisher*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       export APPSERVER_IP="pfmdp01"
       export INSTANCE="metadata-publisher"
       cd /opt/build/scripts/perf
       ./deployapp.sh -a publisher -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
       echo "${Version}" > /var/www/html/${DeployTarg}/metadata-publisher.txt
       ;;
################################################
    impression_collector)
       export targname="10.13.19.151"
#       export targname="pfimpcol01"
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/impression_collector/webapps/impression_collector_server/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       export APPSERVER_IP="10.13.19.151"
#       export APPSERVER_IP="pfimpcol01"
       export INSTANCE="impression_collector"
       cd /opt/build/scripts/perf
       ./deployapp.sh -a impression_collector_server -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
       echo "${Version}" > /var/www/html/${DeployTarg}/impression_collector.txt
       ;;
################################################
    int-test-support)
        export targname="pffwmock01"
        Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/mocksvr01/webapps/int-test-support/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       export APPSERVER_IP="pffwmock01"
       export INSTANCE="mocksvr01"
       cd /opt/build/scripts/perf
       ./deployapp.sh -a int-test-support -t ${Component} -e ${DeployTarg} -r ${Version} -i mocksvr01 -v
       print ${Version} > /var/www/html/${Deploytarg}/int-test-support.txt
       ;;
################################################
    dai-smsi)
       export targname="pfsmsidai01"
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/smsi_40/webapps/s*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       cd /opt/build/scripts/perf
       export SMSIComponents="smsi1 smsi2"
       for i in $SMSIComponents; do
          case $i in
             smsi1)
                export APPSERVER_IP="pfsmsidai01"
                export INSTANCE="smsi_40"
               ./deployapp.sh -a safi-smsi-server -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
             ;;
             smsi2)
                export APPSERVER_IP="pfsmsidai02"
                export INSTANCE="smsi_40"
               ./deployapp.sh -a safi-smsi-server -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
             ;;
          esac
       done
       print ${Version} > /var/www/html/${DeployTarg}/dai-smsi.txt
       ;;
################################################
    dai-cip)
       export targname="pfcipdai01"
       Deployed_Version=`ssh tcserver@${targname} "cd /opt/tcserver/dai-cip_40/bin; jar xf dai-cip.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       ssh tcserver@${targname} "cd dai-cip_40/; ./launcher.sh stop"
       cd /opt/build/scripts/perf
       ./deployjar.sh -a dai-cip -t ${Component} -e ${DeployTarg} -r ${Version} -v
       echo "${Version}" > /var/www/html/${DeployTarg}/dai-cip.txt
       ;;
################################################
    old_dai-cip)
       export targname="pfcipdai01"
       Deployed_Version=`ssh tcserver@${targname} "cd /opt/tcserver/dai-cip_40/cip-batch; jar xf dai-cip-batch.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       ssh tcserver@${targname} "cd dai-cip_40/cip-immediate; ./cipstartstop.sh stop"
       ssh tcserver@${targname} "cd dai-cip_40/cip-batch; ./cipstartstop.sh stop"
       cd /opt/build/scripts/perf
       ./deployjar.sh -a dai-cip -t ${Component} -e ${DeployTarg} -r ${Version} -v 
       echo "${Version}" > /var/www/html/${DeployTarg}/dai-cip.txt
       ;;
################################################
    Pgmr-Cpgn-Int)

/opt/build/scripts/tcServerAdmin.sh pffwciping01 FW_CIP_ING_01 stop
/opt/build/scripts/tcServerAdmin.sh pffwciping01 FW_CIP_ING_01 stop

              export targname="pffwciping01"
              Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/FW_CIP_ING_01/webapps/fw_cip-ingest/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       cd /opt/build/scripts/perf
       export PCIComponents="pci1 pci2 pci3"
        for i in $PCIComponents; do
         case $i in
          pci1)
             export APPSERVER_IP="pffwciping01"
             export INSTANCE="FW_CIP_ING_01"

      if [[ ${DB_Rebuild} = "No" ]]; then
        Compcheck=`./compareVersions.sh -n $Version -o $Deployed_Version`
        if [[ $Compcheck = "-1" ]]; then
          fnRebuildCheck
        fi
      fi

      if [[ ${DB_Rebuild} = "Yes" ]] ; then
        cd /opt/build/scripts/perf
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
define DeployTarg='${DB_USER}'
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
             ./deployRebuildDb.sh -a ${Component} -t ${Component} -i ${INSTANCE} -r ${Version} -e ${DeployTarg} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v
             /opt/build/scripts/tcServerAdmin.sh pffwciping01 FW_CIP_ING_01 start
             /opt/build/scripts/tcServerAdmin.sh pffwciping02 GOOGLE_CIP_ING_01 start
             ./deployapp.sh -a pci -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
          ;;
          pci2)
             export APPSERVER_IP="pffwciping02"
             export INSTANCE="GOOGLE_CIP_ING_01"
             ./deployapp.sh -a pci -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
          ;;
          pci3)
             export APPSERVER_IP="pfbrdciping01"
             export INSTANCE="PCI_BRD"
            ./deployapp.sh -a pci -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
          ;;
          esac
         done
       echo "${Version}" > /var/www/html/${DeployTarg}/Pgmr-Cpgn-Int.txt
       ;;
################################################
    acp)
       export targname="pfcm01"
       Deployed_Version=`ssh tcserver@${targname} "cd /opt/tcserver/acp/bin; jar xf acp.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       cd /opt/build/scripts/perf
       ./deployjar.sh -a ${Component} -t ${Component} -e ${DeployTarg} -r ${Version} -v
       echo "${Version}" > /var/www/html/${DeployTarg}/acp.txt
       ;;
################################################   
    dai-lincoln)
        Deployed_Version=`ssh tcserver@${targname} "cd /opt/tcserver/log_splitter; jar xf lincoln-1.2.0.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
       if [ ${getVer} = "1" ] ; then
             Version=`ssh tcserver@dvappdai01 "cd /opt/tcserver/log_splitter; jar xf lincoln-1.2.0.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
       fi
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       cd /opt/build/scripts
       ./deployjar.sh -a dai-lincoln -t ${Component} -e ${DeployTarg} -r ${Version} -v
       echo "${Version}" > /var/www/html/${DepolyTarg}/log.txt
       ;;
################################################
    dai-smsi-relay)
       export targname="pffwsmsr01"
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/FW_SMSI_RELAY_01/webapps/fw_smsi-relay/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

     /opt/build/scripts/tcServerAdmin.sh pfsmsidai01 smsi_40 stop
     /opt/build/scripts/tcServerAdmin.sh pfsmsidai02 smsi_40 stop


      export SMSIRelayDB="relay1 relay2 relay3"
      for i in $SMSIRelayDB; do
         case $i in
            relay1)
               export DB_USER="SMSI_RELAY_01"
               export DB_PASS="SMSI_RELAY_01"
               export APPSERVER_IP="pffwsmsr01"
               export INSTANCE="FW_SMSI_RELAY_01"
               export targname="pffwsmsr01"
             ;;
            relay2)
               export DB_USER="SMSI_RELAY_02"
               export DB_PASS="SMSI_RELAY_02"
               export APPSERVER_IP="pffwsmsr03"
               export INSTANCE="GL_SMSI_RELAY_01"
               export targname="pffwsmsr03"
             ;;
            relay3)
               export DB_USER="SMSI_RELAY_03"
               export DB_PASS="SMSI_RELAY_03"
               export APPSERVER_IP="pfbrdsmsr01"
               export INSTANCE="BRD_SMSI_RELAY_01"
               export targname="pfbrdsmsr01"
            ;;
         esac

      if [[ ${DB_Rebuild} = "No" ]]; then
#        Compcheck=`./compareVersions.sh -n $Version -o $Deployed_Version`
#        if [[ $Compcheck = "-1" ]]; then
#          fnRebuildCheck
         echo "Version check disabled temporarily"
#        fi
      fi

      if [[ ${DB_Rebuild} = "Yes" ]] ; then
        cd /opt/build/scripts/perf
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
define DeployTarg='${DB_USER}'
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
    cd /opt/build/scripts/perf
echo "Running  ./deployRebuildDb.sh -a ${Component} -t ${Component} -i ${INSTANCE} -r ${Version} -e ${DeployTarg} -j ${JDBC_URL} -p ${DB_PASS} -u ${DB_USER} -v"

    ./deployRebuildDb.sh -a ${Component} -t ${Component} -i ${INSTANCE} -r ${Version} -e ${DeployTarg} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v

   done

       cd /opt/build/scripts/perf
       export RelComp="rel1 rel2 rel3 rel4 rel5 rel6"

       for i in $RelComp; do
         case $i in
            rel1)
	       export APPSERVER_IP="pffwsmsr01"
               export INSTANCE="FW_SMSI_RELAY_01"
            ;;
            rel2)
               export APPSERVER_IP="pffwsmsr02"
               export INSTANCE="FW_SMSI_RELAY_02"
            ;;
            rel3)
               export APPSERVER_IP="pffwsmsr03"
               export INSTANCE="GL_SMSI_RELAY_01"
            ;;
            rel4)
               export APPSERVER_IP="pffwsmsr04"
               export INSTANCE="GL_SMSI_RELAY_02"
            ;;
            rel5)
               export APPSERVER_IP="pfbrdsmsr01"
               export INSTANCE="BRD_SMSI_RELAY_01"
            ;;
            rel6)
               export APPSERVER_IP="pfbrdsmsr02"
               export INSTANCE="BRD_SMSI_RELAY_02"
            ;;
         esac
      ./deployapp.sh -a smsi-relay-client -t ${Component} -e ${APPSERVER_IP} -i ${INSTANCE} -r ${Version} -v
       done

     /opt/build/scripts/tcServerAdmin.sh pfsmsidai01 smsi_40 start
     /opt/build/scripts/tcServerAdmin.sh pfsmsidai02 smsi_40 start


       echo "${Version}" > /var/www/html/${DeployTarg}/dai-smsi-relay.txt
       ;;
################################################          
    oss_bar)
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/oss_bar/webapps/oss_bar/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       if [ ${getVer} = "1" ] ; then
             Version=`ssh tcserver@dvappdai01 "grep Implementation-Version /opt/tcserver/instances/oss_bar/webapps/oss_bar/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       fi
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
       if [ ${getVer} = "1" ] ; then
          Version=`ssh tcserver@dvappdai01 "grep Implementation-Version /opt/tcserver/instances/smsi-admin/webapps/smsi-admin/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
          print "Deploying version: ${Version}"
       fi
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
       ;;
################################################
    ad-load-manager)
      export APPSERVER_IP="pfalm01"
      export INSTANCE="ad-load-manager"
      cd /opt/build/scripts/perf
      Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/${Component}/webapps/alm-server/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
      if [[ ${DB_Rebuild} = "No" ]]; then
        Compcheck=`./compareVersions.sh -n $Version -o $Deployed_Version`
        if [[ $Compcheck = "-1" ]]; then
          fnRebuildCheck
        fi
      fi
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       if [[ ${DB_Rebuild} = "Yes" ]] ; then
        export SSH_BASE="tcserver@${APPSERVER_IP}"
        export APPSERVER_BIN="instances/${INSTANCE}/bin"
        scp stop.sh ${SSH_BASE}:$APPSERVER_BIN
        ssh ${SSH_BASE} ${APPSERVER_BIN}/stop.sh -a ${INSTANCE}

       cd /opt/build/scripts
       ./kill_dbsessions.sh -a ad-load-manager -e performance
        echo "Dropping database users"
        cd /opt/build/scripts/perf
        export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
sqlplus -S cm_system/Perf0ra@$SQLCONN <<!
set heading off
define DeployTarg='$DeployTarg'
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
define DeployTarg='$DeployTarg'
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
      if [[ ${Clear_Logs} = "Yes" ]] ; then
        echo "Removing log files from ad-load-manager on ${targname}"
        ClearList=`ssh tcserver@${targname} "ls /opt/tcserver/instances/ad-load-manager/logs"`
        echo ${ClearList}
        `ssh tcserver@${targname} "rm /opt/tcserver/instances/ad-load-manager/logs/*log*"`
        echo "--------------------------------------------------"
        ClearList=`ssh tcserver@${targname} "ls /opt/tcserver/instances/ad-load-manager/logs"`
        echo ${ClearList}
       fi
       cd /opt/build/scripts/perf
       ./deployapp.sh -a alm-server -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
       ./deployRebuildDb.sh -a alm-server -t ${Component} -i ${INSTANCE} -r ${Version} -e ${APPSERVER_IP} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v
       echo "${Version}" > /var/www/html/${DeployTarg}/${Component}.txt
       ;;
################################################
    smsi-publisher)

      cd /opt/build/scripts/perf
      Deployed_Version=`./check_dbversions_perf.sh -a smsi-publisher -e ${DeployTarg}`
      echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

      export SMSIPubDB="pub1 pub2"
      for i in $SMSIPubDB; do
         case $i in
            pub1)
               export DB_USER="SMSI_PUB"
               export DB_PASS="SMSI_PUB"
               export APPSERVER_IP="pfsmspub01"
               export INSTANCE="smsi-pub"
            ;;
            pub2)
               export DB_USER="SMSI_PUB_02"
               export DB_PASS="SMSI_PUB_02"
               export APPSERVER_IP="pfsmspub02"
               export INSTANCE="smsi-pub"
            ;;
         esac

      if [[ ${DB_Rebuild} = "No" ]]; then
        Compcheck=`./compareVersions.sh -n $Version -o $Deployed_Version`
        if [[ $Compcheck = "-1" ]]; then
          fnRebuildCheck
        fi
      fi


      if [[ ${DB_Rebuild} = "Yes" ]] ; then
      #  Stopping APP servers in case of rebuild to disconnect user sessions from database schema
          export SSH_BASE="tcserver@${APPSERVER_IP}"
          export APPSERVER_BIN="instances/${INSTANCE}/bin"
          scp stop.sh ${SSH_BASE}:$APPSERVER_BIN
          ssh ${SSH_BASE} ${APPSERVER_BIN}/stop.sh -a ${INSTANCE}
       export ADSComponents="ads1 ads2 psn1 psn2 cis1"
       for i in $ADSComponents; do
          case $i in
             ads1)
                export APPEXT="pfadsdai01"
                export INSEXT="ads0101_40"
             ;;
             ads2)
                export APPEXT="pfadsdai02"
                export INSEXT="ads0201_40"
             ;;
             psn1)
                export APPEXT="pfpsndai01"
                export INSEXT="psn0102_40"
             ;;
             psn2)
                export APPEXT="pfpsndai02"
                export INSEXT="psn0102_40"
             ;;
             cis1)
                export APPEXT="pfcis01"
                export INSEXT="cis02"
             ;;
         esac
                export SSH_BASE="tcserver@${APPEXT}"
                export APPEXT_BIN="instances/${INSEXT}/bin"
                scp stop.sh ${SSH_BASE}:$APPEXT_BIN
                ssh ${SSH_BASE} ${APPEXT_BIN}/stop.sh -a ${INSEXT}
       done

        cd /opt/build/scripts/perf
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
define DeployTarg='$DeployTarg'
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
       cd /opt/build/scripts/perf
       ./deployapp.sh -a smsi-pub -t smsi-publisher -e ${APPSERVER_IP} -r ${Version} -i smsi-pub -v
       ./deployRebuildDb.sh -a smsi-pub -t smsi-publisher -i ${INSTANCE} -r ${Version} -e ${APPSERVER_IP} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v
       done
      # Restarting the Decision Engine app server instances to reconnect with the new smsi databases
       export ADSComponents="ads1 ads2 psn1 psn2 cis1"
       for i in $ADSComponents; do
          case $i in
             ads1)
                export APPEXT="pfadsdai01"
                export INSEXT="ads0101_40"
             ;;
             ads2)
                export APPEXT="pfadsdai02"
                export INSEXT="ads0201_40"
             ;;
             psn1)
                export APPEXT="pfpsndai01"
                export INSEXT="psn0102_40"
             ;;
             psn2)
                export APPEXT="pfpsndai02"
                export INSEXT="psn0102_40"
             ;;
             cis1)
                export APPEXT="pfcis01"
                export INSEXT="cis02"
             ;;
         esac
                export SSH_BASE="tcserver@${APPEXT}"
                export APPEXT_BIN="instances/${INSEXT}/bin"
                ssh ${SSH_BASE} ${APPEXT_BIN}/tcruntime-ctl.sh start
       done
       echo "${Version}" > /var/www/html/${DeployTarg}/smsi-publisher.txt
       ;;

################################################
    caas-core)
      cd /opt/build/scripts/perf
       Deployed_Version=`./check_dbversions_perf.sh -a caas-core -e ${DeployTarg}`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

      if [[ ${DB_Rebuild} = "No" ]]; then
        Compcheck=`./compareVersions.sh -n $Version -o $Deployed_Version`
        if [[ $Compcheck = "-1" ]]; then
          fnRebuildCheck
        fi
      fi

      if [[ ${DB_Rebuild} = "Yes" ]] ; then
       #/opt/build/scripts/roottcServerAdmin.sh ${targname} stop
       #./kill_dbsessions.sh -a caas-core -e ${DeployTarg}
       # ssh tcserver@${targname} "cd dai-cip/cip-immediate; ./cipstartstop.sh stop"
       # ssh tcserver@${targname} "cd dai-cip/cip-batch; ./cipstartstop.sh stop"

        cd /opt/cvbuild/wa/DB_Extracts; mkdir ${BUILD_TAG}; cd ${BUILD_TAG}
        echo "Extracting DB creation scripts for ${Version} of ${Component}"
        tar -xvf /opt/build/releaseTars/${Component}/${Component}_${Version}.tar liquibase/cisys
        cd /opt/build/scripts/perf
        export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
sqlplus -S cm_system/Perf0ra@$SQLCONN <<!
set heading off
set verify off
@genUser.caas-core.performance.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema creation failed"
        exit ${STATUS}
      fi
    fi
    cd /opt/build/scripts/perf

    ./deployRebuildDb.sh -a caas-core -t caas-core -i ${INSTANCE} -r ${Version} -e ${DeployTarg} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v

    #/opt/build/scripts/roottcServerAdmin.sh ${targname} start
    cd /opt/build/scripts/perf
### Mike's metadata-sync project run for trigger enablement
#    if [[ ${DB_Rebuild} = "Yes" ]] ; then
      Trig_Version=`cat /opt/build/releaseTars/metadata-sync/latest`
      echo $Trig_Version
      ./deployjar.sh -a metadata-sync -t metadata-sync -e performance -r ${Trig_Version}
#   fi
###  End Trigger setup
    echo "${Version}" > /var/www/html/${DeployTarg}/caas-core.txt
;;
################################################
    ads-core)

      cd /opt/build/scripts/perf
      Deployed_Version=`./check_dbversions_perf.sh -a ads-core -e ${DeployTarg}`
      echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

      export adsCoreDB="adscore1 adscore2"
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
         esac

      if [[ ${DB_Rebuild} = "No" ]]; then
        Compcheck=`./compareVersions.sh -n $Version -o $Deployed_Version`
        if [[ $Compcheck = "-1" ]]; then
          fnRebuildCheck
        fi
      fi

      if [[ ${DB_Rebuild} = "Yes" ]] ; then
        cd /opt/build/scripts/perf 
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
define DeployTarg='${DB_USER}'
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
    cd /opt/build/scripts/perf

    ./deployRebuildDb.sh -a ads-core -t ads-core -i ads0101_40 -r ${Version} -e ${DeployTarg} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v
  done
    echo "${Version}" > /var/www/html/${DeployTarg}/ads-core.txt
;;
################################################
    dai-etl-feeder)

     /opt/build/scripts/tcServerAdmin.sh pfsmsidai01 smsi_40 stop
     /opt/build/scripts/tcServerAdmin.sh pfsmsidai02 smsi_40 stop
     /opt/build/scripts/tcServerAdmin.sh pffwsmsr01 FW_SMSI_RELAY_01 stop
     /opt/build/scripts/tcServerAdmin.sh pffwsmsr02 FW_SMSI_RELAY_02 stop

      cd /opt/build/scripts/perf
      Deployed_Version=`./check_dbversions_perf.sh -a dai-etl-feeder -e ${DeployTarg}`
      echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

      if [[ ${DB_Rebuild} = "No" ]]; then
        Compcheck=`./compareVersions.sh -n $Version -o $Deployed_Version`
        if [[ $Compcheck = "-1" ]]; then
          fnRebuildCheck
        fi
      fi

    if [[ ${DB_Rebuild} = "Yes" ]] ; then
      #./kill_dbsessions.sh -a dai-etl-feeder -e ${DeployTarg}
 
      export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
sqlplus -S cm_system/Perf0ra@$SQLCONN <<!
set heading off
define DeployTarg='$DeployTarg'
set verify off
@genUser.dai-etl-feeder.performance.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema creation failed.  Are there users sessions that need to be destroyed?"
        exit ${STATUS}
      fi
    fi
    cd /opt/build/scripts/perf

     ./deployJarRebuild.sh -a ${Component} -t ${Component} -e ${DeployTarg} -r ${Version} -j "${JDBC_URL}" -p ${DB_PASS}  -u ${DB_USER} -c ${ETL_CAAS} -b ${ETL_BAR} -o ${ETL_BILLING} -w ${REPORTING_SCHEMA_NAME} -v


     /opt/build/scripts/tcServerAdmin.sh pfsmsidai01 smsi_40 start
     /opt/build/scripts/tcServerAdmin.sh pfsmsidai02 smsi_40 start
     /opt/build/scripts/tcServerAdmin.sh pffwsmsr01 FW_SMSI_RELAY_01 start
     /opt/build/scripts/tcServerAdmin.sh pffwsmsr02 FW_SMSI_RELAY_02 start

    echo "${Version}" > /var/www/html/${DeployTarg}/dai-etl-feeder.txt
;;
################################################
    smsi_reporting)

#     /opt/build/scripts/tcServerAdmin.sh pfsmsidai01 smsi_40 stop
#     /opt/build/scripts/tcServerAdmin.sh pfsmsidai02 smsi_40 stop
#     /opt/build/scripts/tcServerAdmin.sh pffwsmsr01 FW_SMSI_RELAY_01 stop
#     /opt/build/scripts/tcServerAdmin.sh pffwsmsr02 FW_SMSI_RELAY_02 stop

      cd /opt/build/scripts/perf
      Deployed_Version=`./check_dbversions_perf.sh -a smsi_reporting -e ${DeployTarg}`
      echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

      if [[ ${DB_Rebuild} = "No" ]]; then
        Compcheck=`./compareVersions.sh -n $Version -o $Deployed_Version`
        if [[ $Compcheck = "-1" ]]; then
          fnRebuildCheck
        fi
      fi

    if [[ ${DB_Rebuild} = "Yes" ]] ; then

      export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
sqlplus -S cm_system/Perf0ra@$SQLCONN <<!
set heading off
define DeployTarg='$DeployTarg'
set verify off
@genUser.smsi_reporting.performance.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema creation failed.  Are there users sessions that need to be destroyed?"
        exit ${STATUS}
      fi
    fi
    cd /opt/build/scripts/perf

     ./deployJarRebuild.sh -a ${Component} -t ${Component} -e ${DeployTarg} -r ${Version} -j "${JDBC_URL}" -p ${DB_PASS}  -u ${DB_USER} -c ${ETL_CAAS} -w ${REPORTING_SCHEMA_NAME} -v


#     /opt/build/scripts/tcServerAdmin.sh pfsmsidai01 smsi_40 start
#     /opt/build/scripts/tcServerAdmin.sh pfsmsidai02 smsi_40 start
#     /opt/build/scripts/tcServerAdmin.sh pffwsmsr01 FW_SMSI_RELAY_01 start
#     /opt/build/scripts/tcServerAdmin.sh pffwsmsr02 FW_SMSI_RELAY_02 start

    echo "${Version}" > /var/www/html/${DeployTarg}/smsi_reporting.txt
;;
    *)
      print "No Deploy...";;
esac

if [ ${getVer} = "1" ] ; then
    echo "<b>Version: </b>Derived from DevInt by default<br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
else
   echo "<b>Version: </b>Specified by user<br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
fi
