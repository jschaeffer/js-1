#!/bin/ksh 

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
     export DB_USER="CAAS_CORE_COX"
     export DB_PASS="CAAS_CORE_COX"
     export INSTANCE="CampMan_COX"
   ;;
   ads-core)
     export DB_USER="ADS_CORE_COX"
     export DB_PASS="ADS_CORE_COX"
     export INSTANCE="COX_ADS_001"
   ;;
   smsi-publisher)
     export DB_USER="SMSI_PUB_COX"
     export DB_PASS="SMSI_PUB_COX"
     export INSTANCE="COX_CIS_001"
   ;;
esac

# Setup Environment specific variables
#
export SIDTarg="pro001"
export DBIP="10.13.17.130"
export JDBC_URL="jdbc:oracle:thin:@10.13.17.130:1522/pro001"
export ETL_CAAS="CAAS_CORE_COX"
export ETL_BAR="OSS_BAR"
export ETL_BILLING="DAI_BILLING"
export REPORTING_SCHEMA_NAME="DAI_REPORTING_SAFI"

# Verify User supplies a Username and Purpose for the Deployment
#
if [ -z ${DeployUser} ] ; then
    print "<h2>User must supply a user name and summary of deploy purpose</h2>"
    exit 1
fi

cd /opt/build/scripts/coxlab

case $Component in
################################################
    Dynamic-Ad-Insertion-engine)
       Deployed_Version=`ssh tcserver@l2ladscox01 "grep Implementation-Version /opt/tcserver/instances/COX_ADS_001/webapps/ads*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
      echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       cd /opt/build/scripts/coxlab
       export ADSComponents="ads1 psn1 cis1"
       for i in $ADSComponents; do
          case $i in
             ads1)
                export APPSERVER_IP="l2ladscox01"
                export INSTANCE="COX_ADS_001"
               ./deployapp.sh -a ads -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
             ;;
             psn1)
                export APPSERVER_IP="l2lpsncox01"
                export INSTANCE="COX_PSN_001"
              ./deployapp.sh -a ads -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
              sleep 120
             ;;
             cis1)
                export APPSERVER_IP="l2ladscox01"
                export INSTANCE="COX_CIS_001"
              ./deployapp.sh -a cis -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
              sleep 120
             ;;
         esac
       done
       echo "${Version}" > /var/www/html/${DeployTarg}/Dynamic-Ad-Insertion-engine.txt
       ;;
################################################    
    dai-cip-feedback)
       export targname=""
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/cip-feedback/webapps/cip-feedback*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       export APPSERVER_IP=""
       export INSTANCE="cip-feedback"
       cd /opt/build/scripts/coxlab
       ./deployapp.sh -a cip-server -t ${Component} -e ${DeployTarg} -r ${Version} -i ${INSTANCE} -v
       echo "${Version}" > /var/www/html/${DeployTarg}/${Component}.txt 
       ;;
################################################
    ad-load-manager)
       export targname="l2lpsncox01"
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/ad-load-manager/webapps/alm-server*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       export APPSERVER_IP="l2lpsncox01"
       export INSTANCE="ad-load-manager"
       export DB_USER="ALM_COX"
       export DB_PASS="ALM_COX"
       cd /opt/build/scripts/coxlab
       if [[ ${DB_Rebuild} = "No" ]]; then
        Compcheck=`./compareVersions.sh -n $Version -o $Deployed_Version`
        if [[ $Compcheck = "-1" ]]; then
          fnRebuildCheck
        fi
       fi
     if [[ ${DB_Rebuild} = "Yes" ]] ; then
       export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
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
       ./deployRebuildDb.sh -a alm-server -t ${Component} -i ${INSTANCE} -r ${Version} -e ${APPSERVER_IP} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v
       ./deployapp.sh -a alm-server -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
       echo "${Version}" > /var/www/html/${DeployTarg}/ad-load-manager.txt
       ;;
################################################
    Dynamic-Ad-Insertion-cm)
       export targname="l2lpsncox01"
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/CampMan_COX/webapps/cm*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       export APPSERVER_IP="l2lpsncox01"
       export INSTANCE="CampMan_COX"
       cd /opt/build/scripts/coxlab
       ./deployapp.sh -a ${Component} -t ${Component} -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
       echo "${Version}" > /var/www/html/${DeployTarg}/Dynamic-Ad-Insertion-cm.txt
       ;;
################################################
    POIS)
       export targname="l2lpois01"
       Deployed_Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/POIS/webapps/pois*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       export POISComponents="pois1 pois2"
       for i in $POISComponents; do
        case $i in
         pois1)
          export APPSERVER_IP="l2lpois01"
          export INSTANCE="POIS"
          export WEBAPP="pois"
          ;;
         pois2)
          export APPSERVER_IP="l2lpois02"
          export INSTANCE="POIS"
          export WEBAPP="pois"
          ;;
        esac
       cd /opt/build/scripts/coxlab
       ./deployapp.sh -a pois -t POIS -e ${APPSERVER_IP} -r ${Version} -i ${INSTANCE} -v
       done
       echo "${Version}" > /var/www/html/${DeployTarg}/$(Component).txt
       ;;
################################################
    old_dai-cip)
       export targname="l2ladscox01"
       Deployed_Version=`ssh tcserver@${targname} "cd /opt/tcserver/dai-cip/cip-batch; jar xf dai-cip-batch.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       ssh tcserver@${targname} "cd dai-cip/cip-immediate; ./cipstartstop.sh stop"
       ssh tcserver@${targname} "cd dai-cip/cip-batch; ./cipstartstop.sh stop"
       cd /opt/build/scripts/coxlab
       ./deployjar.sh -a dai-cip -t ${Component} -e ${DeployTarg} -r ${Version} -v 
       echo "${Version}" > /var/www/html/${DeployTarg}/dai-cip.txt
       ;;
################################################
    dai-cip)
       export targname="l2ladscox01"
       Deployed_Version=`ssh tcserver@${targname} "cd /opt/tcserver/dai-cip/bin; jar xf dai-cip.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
       ssh tcserver@${targname} "cd dai-cip/; ./launcher.sh stop"
       cd /opt/build/scripts/coxlab
       ./deployjar.sh -a dai-cip -t ${Component} -e ${DeployTarg} -r ${Version} -v
       echo "${Version}" > /var/www/html/${DeployTarg}/dai-cip.txt
       ;;
################################################
    smsi-publisher)
   ##############################################################################################
   ####    IMPORTANT NOTE ON COX SYSTEM - NO SMSI PUBLISHER APP SERVER, ONLY DB  ################
   ##############################################################################################
      cd /opt/build/scripts/coxlab
      Deployed_Version=`./check_dbversions_cox.sh -a smsi-publisher -e ${DeployTarg}`
      echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

       export DB_USER="SMSI_PUB_COX"
       export DB_PASS="SMSI_PUB_COX"
       export APPSERVER_IP="l2ladscox01"
       export INSTANCE="COX_CIS_001"

      if [[ ${DB_Rebuild} = "No" ]]; then
        Compcheck=`./compareVersions.sh -n $Version -o $Deployed_Version`
        if [[ $Compcheck = "-1" ]]; then
          fnRebuildCheck
        fi
      fi


      if [[ ${DB_Rebuild} = "Yes" ]] ; then
      #  Stopping APP servers in case of rebuild to disconnect user sessions from database schema
       export ADSComponents="ads1 psn1 cis1"
       for i in $ADSComponents; do
          case $i in
             ads1)
                export APPEXT="l2ladscox01"
                export INSEXT="COX_ADS_001"
             ;;
             psn1)
                export APPEXT="l2lpsncox01"
                export INSEXT="COX_PSN_001"
             ;;
             cis1)
                export APPEXT="l2ladscox01"
                export INSEXT="COX_CIS_001"
             ;;
         esac
                export SSH_BASE="tcserver@${APPEXT}"
                export APPEXT_BIN="instances/${INSEXT}/bin"
                scp stop.sh ${SSH_BASE}:$APPEXT_BIN
                ssh ${SSH_BASE} ${APPEXT_BIN}/stop.sh -a ${INSEXT}
       done

        cd /opt/build/scripts/coxlab
        export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
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
       cd /opt/build/scripts/coxlab
#       ./deployapp.sh -a smsi-pub -t smsi-publisher -e ${APPSERVER_IP} -r ${Version} -i smsi-pub -v
       ./deployRebuildDb.sh -a smsi-pub -t smsi-publisher -i ${INSTANCE} -r ${Version} -e ${APPSERVER_IP} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v
      # Restarting the Decision Engine app server instances to reconnect with the new smsi databases
       export ADSComponents="ads1 psn1 cis1"
       for i in $ADSComponents; do
          case $i in
             ads1)
                export APPEXT="l2ladscox01"
                export INSEXT="COX_ADS_001"
             ;;
             psn1)
                export APPEXT="l2lpsncox01"
                export INSEXT="COX_PSN_001"
             ;;
             cis1)
                export APPEXT="l2ladscox01"
                export INSEXT="COX_CIS_001"
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
      cd /opt/build/scripts/coxlab
       Deployed_Version=`./check_dbversions_cox.sh -a caas-core -e ${DeployTarg}`
       echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

      if [[ ${DB_Rebuild} = "No" ]]; then
        Compcheck=`./compareVersions.sh -n $Version -o $Deployed_Version`
        if [[ $Compcheck = "-1" ]]; then
          fnRebuildCheck
        fi
      fi

      if [[ ${DB_Rebuild} = "Yes" ]] ; then

        cd /opt/cvbuild/wa/DB_Extracts; mkdir ${BUILD_TAG}; cd ${BUILD_TAG}
        echo "Extracting DB creation scripts for ${Version} of ${Component}"
        tar -xvf /opt/build/releaseTars/${Component}/${Component}_${Version}.tar liquibase/cisys
        cd /opt/build/scripts/coxlab
        export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off;
set feedback on;
set echo on;
define DB_USER='$DB_USER'
set verify on
set serveroutput on
@/opt/build/scripts/coxlab/caas_flshbk.sql $DB_USER
exit
!

sqlplus -S cm_system/L2L0ra@$SQLCONN <<!
set heading off
set verify off
@genUser.caas-core.coxlab.sql
exit sql.sqlcode
!
      STATUS=${?}
      if [[ ${STATUS} != "0" ]]; then
        echo "Schema creation failed"
        exit ${STATUS}
      fi
    fi
    cd /opt/build/scripts/coxlab
#echo "./deployRebuildDb.sh -a caas-core -t caas-core -i ${INSTANCE} -r ${Version} -e ${DeployTarg} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v"
    ./deployRebuildDb.sh -a caas-core -t caas-core -i ${INSTANCE} -r ${Version} -e ${DeployTarg} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v

    cd /opt/build/scripts/coxlab
### Mike's metadata-sync project run for trigger enablement
#    if [[ ${DB_Rebuild} = "Yes" ]] ; then
      Trig_Version=`cat /opt/build/releaseTars/metadata-sync/latest`
      echo $Trig_Version
     ./deployjar.sh -a metadata-sync -t metadata-sync -e cox -r ${Trig_Version}
#   fi
###  End Trigger setup
    echo "${Version}" > /var/www/html/${DeployTarg}/caas-core.txt
;;
################################################
    ads-core)

      cd /opt/build/scripts/coxlab
      Deployed_Version=`./check_dbversions_cox.sh -a ads-core -e ${DeployTarg}`
      echo "<b>Upgrading ${Component} from ${Deployed_Version} to ${Version}</b><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

      export DB_USER="ADS_CORE_COX"
      export DB_PASS="ADS_CORE_COX"

      if [[ ${DB_Rebuild} = "No" ]]; then
        Compcheck=`./compareVersions.sh -n $Version -o $Deployed_Version`
        if [[ $Compcheck = "-1" ]]; then
          fnRebuildCheck
        fi
      fi

      if [[ ${DB_Rebuild} = "Yes" ]] ; then
        cd /opt/build/scripts/coxlab
        export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DBIP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${SIDTarg})))"
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
    cd /opt/build/scripts/coxlab

   ./deployRebuildDb.sh -a ads-core -t ads-core -i COX_ADS_001 -r ${Version} -e ${DeployTarg} -j "${JDBC_URL}" -p ${DB_PASS} -u ${DB_USER} -v
    echo "${Version}" > /var/www/html/${DeployTarg}/ads-core.txt
;;
    *)
      print "No Deploy...";;
esac

if [ ${getVer} = "1" ] ; then
    echo "<b>Version: </b>Derived from DevInt by default<br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
else
   echo "<b>Version: </b>Specified by user<br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
fi
