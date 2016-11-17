#!/bin/bash -x
#
# Script - SCMSysVars.sh 
# Sourced in from various scripts to define common system level information for deploymens
fnSetScrum() {
     export SIDTarg="scrmtst1"
     export DBIP="10.13.18.61"
     export JDBC_URL="jdbc:oracle:thin:@10.13.18.61:1522:scrmtst1"
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
   TEST_O12)
     export DeployTarg
     export targname=""
     export DB_PREFIX="TEST_O12"
     export APPSERVER_IP=""
     fnSetScrum
   ;;
esac
