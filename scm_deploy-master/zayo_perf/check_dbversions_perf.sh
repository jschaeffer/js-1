#!/bin/bash -x

#############
# Usage message
#############
usage() {
    cat << EOF
usage: $0 options

This script checks the version of a deployed database which uses liquibase and the TAG element.

OPTIONS:
  -h   Show this message
  -a   Required. Application/DB name. ex. caas-core
  -e   Required. Environment to which the database exists
  -v   Verbose
EOF
}

###############################################################
#                       Main script
###############################################################

export VERBOSE=0

# Function return value
FUNC_RV=""

while getopts "h:a:e:v" OPTION
do
 case $OPTION in
   a)
    APP=${OPTARG}
    case $APP in
     dai-etl-feeder)
      export DB_USER=DAI_REPORTING_SAFI
     ;;
     caas-core)
      export DB_USER=CAAS_CORE
     ;;
     ads-core)
       export DB_USER=ADS_CORE_MSO1
     ;;
     smsi_reporting)
      export DB_USER=SMSI_REPORTING
     ;;
    esac
   ;;
   e)
    TARGENV=${OPTARG}
     case $TARGENV in
      performance)
        export JDBC_URL="jdbc:oracle:thin:@208.54.248.212:1522:PERF1"
        export DB_IP="pfdbrac01-vip.cv.perf"
        export DB_SID="bucket"
      ;;	   
     esac
   ;;
   h)
    usage
    exit 1
   ;;
   v)
    VERBOSE=1
   ;;
   ?)
    usage
    exit
   ;;
 esac
done


export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DB_IP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${DB_SID})))"
sqlplus -S ${DB_USER}/${DB_USER}@$SQLCONN <<!
set heading off;
set feedback off;
define DB_USER='$DB_USER'
set verify off
@/opt/build/scripts/check_dbversions.sql
exit
!
