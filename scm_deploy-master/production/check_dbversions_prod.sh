#!/bin/bash 

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

while getopts "h:a:v" OPTION
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
       export DB_USER=ADS_CORE_CMC
     ;;
     smsi_reporting)
      export DB_USER=BRA_REPORTING_ODS
      echo "DB_USER is: $DB_USER"
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


export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=prod-rac-scan.cv.prod)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=node4)))"
sqlplus -S Cm_system/Prod0ra@$SQLCONN <<!
set heading off;
set feedback off;
define DB_USER='$DB_USER'
set verify off
@/opt/build/scripts/production/check_dbversions.sql
exit
!
