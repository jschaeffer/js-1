#!/bin/bash

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

#############
# Usage message
#############
usage() {
    cat << EOF
usage: $0 options

This script deploys an application to a specified environment.

OPTIONS:
  -h   Show this message
  -a   Required. Application name. ex. oss_bar
  -e   Required. Environment to which the application will be d
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
	    export DB_USER=REPORTING_SAFI
         ;;
        caas-core)
           export DB_USER=CAAS_CORE
        ;;
        ads-core)
           export DB_USER=ADS_CORE_MSO1
        ;;
	 oss_bar)
	    export DB_USER=OSS_BAR
         ;;
	 dai-billing)
	    export DB_USER=DAI_BILLING
         ;;
        smsi-publisher)
           export DB_USER=SMSI_PUB
        ;;
	esac
        ;;
      e)
        TARGENV=${OPTARG}
	case $TARGENV in
	  performance)
            export DB_IP="10.13.19.67"
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


export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DB_IP})(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=${DB_SID})))"
sqlplus -S cm_system/Perf0ra@$SQLCONN <<!
set heading off;
set feedback off;
define DB_USER='$DB_USER'
define DB_PASSWORD='$DB_USER'
set verify off
@/opt/build/scripts/gen_schema.sql
exit
!
