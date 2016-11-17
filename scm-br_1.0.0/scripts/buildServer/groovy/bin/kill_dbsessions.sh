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
	    export DB_USER=REPORTING_ODS
         ;;
        scte-feeder)
           export DB_USER=REPORTING_SCTE
        ;;
	 oss_bar)
	    export DB_USER=OSS_BAR
         ;;
	 dai-billing)
	    export DB_USER=BILLING
         ;;
	 Dynamic-Ad-Insertion-core)
	    export DB_USER=CORE
         ;;
         caas-core)
            export DB_USER=CAAS
         ;;
         ads-core)
            export DB_USER=ADS
         ;;
        ops-dt-domain)
           export DB_USER=OPS_DT
        ;;
        smsi-publisher)
           export DB_USER=SMSIPUB
        ;;
        dai_amm)
           export DB_USER=AMM
        ;;
       dce-mdata)
          export DB_USER=DCE_MDATA
       ;;
	esac
        ;;
      e)
        TARGENV=${OPTARG}
	case $TARGENV in
	  devint)
            export DB_IP=10.13.18.61
            export DB_USER=DI_${DB_USER}
            export DB_SID=scrum004
	  ;;	   
	  scrum1)
           export DB_IP=10.13.18.61
           export DB_USER=SC1_${DB_USER}
           export DB_SID=scrum004
         ;;
          scrum2)
           export DB_IP=10.13.18.61
           export DB_USER=SC2_${DB_USER}
           export DB_SID=scrum004
         ;;
          scrum3)
           export DB_IP=10.13.18.61
           export DB_USER=SC3_${DB_USER}
           export DB_SID=scrum004
         ;;
          MicroDev)
           export DB_IP=10.13.18.61
           export DB_USER=DI4_${DB_USER}
           export DB_SID=scrum004
         ;;
          Marley)
           export DB_IP=10.13.18.61
           export DB_USER=MAR_${DB_USER}
           export DB_SID=scrum004
         ;;
          scrum4)
           export DB_IP=10.13.18.61
           export DB_USER=SC4_${DB_USER}
           export DB_SID=scrum004
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


echo $DB_USER
echo $DB_IP
echo $DB_SID


echo "Killing DB Sessions to enable drop user and rebuld"
echo "--------------------------------------------------"

export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DB_IP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${DB_SID})))"

echo "$SQLCONN"
sqlplus -S cm_system/oracle123@$SQLCONN <<!
set feedback off;
set heading off;

spool /tmp/ora_session_kill.sql
define DB_USER='$DB_USER'
set verify off
@kill_sessions_genscrum.sql
spool off
@/tmp/ora_session_kill.sql
exit
!
