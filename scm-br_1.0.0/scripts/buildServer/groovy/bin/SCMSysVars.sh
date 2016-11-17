#!/bin/bash -x
#
# Script - SCMSysVars.sh 
# Sourced in from various scripts to define common system level information for deploymens
fnSetMicro() {
     export targname="dvmsdai02"
     export APPSERVER_IP="10.13.18.59"
     export JDBC_URL="jdbc:oracle:thin:@10.13.18.121:1522:scrum003"
     export DB_USER="Administrator"
     export DB_PASS="test_1234"
}
fnSetScrum() {
     export SIDTarg="scrum004"
     export DBIP="10.13.18.61"
     export JDBC_URL="jdbc:oracle:thin:@10.13.18.61:1522:scrum004"
     export DB_USER="${DB_PREFIX}_${DB_USER}"
     export DB_PASS="${DB_PREFIX}_${DB_PASS}"
     export ETL_CAAS="${DB_PREFIX}_CAAS"
     export ETL_BAR="${DB_PREFIX}_OSS_BAR"
     export ETL_BILLING="${DB_PREFIX}_BILLING"
     export SCTE_ADS="${DB_PREFIX}_ADS"
     export REPORTING_SCHEMA_NAME="${DB_PREFIX}_REPORTING_ODS"
     export CAAS_SCHEMA_NAME="${DB_PREFIX}_CAAS"
     export CAMPAIGN_SCHEMA_NAME="${DB_PREFIX}_CAAS"
     export CAAS_DB_USER="${DB_PREFIX}_CAAS"
}

case $DeployTarg in
   devint)
     export DeployTarg
     export targname="dvappdai01"
     export DB_PREFIX="DI"
     export APPSERVER_IP="10.13.18.113"
     fnSetScrum
   ;;
   scrum1)
    case $Component in
      MicroDev)
	    fnSetMicro
            export MSDSN="scrum1_test"
            ;;
      *)
            export DeployTarg
            export targname="dvappdai02"
            export DB_PREFIX="SC1"
            export APPSERVER_IP="10.13.18.115"
            fnSetScrum
            ;;
     esac
   ;;
   scrum2)
    case $Component in
      MicroDev)
           fnSetMicro
           export MSDSN="scrum2_test_post_billing_rem"
           ;;
      MicroDev_bau)
           fnSetMicro
           export MSDSN="Scrum2_test_bau"
           ;;
      MicroDev_iir)
           fnSetMicro
           export MSDSN="Scrum2_test_iir"
           ;;
     *)
           export DeployTarg
           export targname="dvappdai03"
           export APPSERVER_IP="10.13.18.116"
           export DB_PREFIX="SC2"
           fnSetScrum
          ;;
    esac
   ;;
   scrum3)
    case $Component in
      MicroDev)
           fnSetMicro
           export MSDSN="scrum3_test"
           ;;
     *)
           export DeployTarg
           export targname="dvappdai04"
           export APPSERVER_IP="10.13.18.117"
           export DB_PREFIX="SC3"
           fnSetScrum
           ;;
    esac
   ;;
   scrum4)
    case $Component in
      MicroDev)
           fnSetMicro
           export MSDSN="scrum4_test"
           ;;
     *)
           export DeployTarg
           export targname="dvappdai05"
           export APPSERVER_IP="10.13.18.122"
           export DB_PREFIX="SC4"
           fnSetScrum
       ;;
    esac
   ;;
   Marley)
    case $Component in
      MicroDev)
           fnSetMicro
           export MSDSN="Marley"
         ;;
       *)
           export DeployTarg
           export targname="itappdai01"
           export APPSERVER_IP="10.13.18.118"
           export DB_PREFIX="MAR"
           fnSetScrum
       ;;
    esac
   ;;
esac
