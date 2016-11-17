#!/bin/bash -x

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
	 smsi_reporting)
	    export DB_USER=SMSI_REPORTING
         ;;
         scte-feeder)
            export DB_USER=REPORTING_SCTE
         ;;
        caas-core)
           export DB_USER=CAAS
        ;;
        request-mgr)
            export DB_USER=REMA
         ;;
        ads-core)
           export DB_USER=ADS
        ;;
	 oss_bar)
	    export DB_USER=OSS_BAR
         ;;
         dai-smsi-relay)
            export DB_USER=RELAY
         ;;
	 dai-billing)
	    export DB_USER=BILLING
         ;;
	 Dynamic-Ad-Insertion-core)
	    export DB_USER=CORE
         ;;
        ops-dt-domain)
           export DB_USER=OPS_DT
        ;;
        ops-dce-domain)
           export DB_USER=OPS_DCE
        ;;
        smsi-publisher)
           export DB_USER=SMSIPUB
        ;;
       dai-etl-feeder)
          export DB_USER=REPORTING_ODS
       ;;
       dce-mdata)
          export DB_USER=DCE_MDATA
       ;;
       dai-national-cis)
          export DB_USER=NCIS
       ;;
	esac
        ;;
      e)
        TARGENV=${OPTARG}
	case $TARGENV in
	  devint)
           export DB_USER=DI_${DB_USER}
	  ;;	   
	  scrum1)
           export DB_USER=SC1_${DB_USER}
         ;;
          scrum2)
           export DB_USER=SC2_${DB_USER}
         ;;
          scrum3)
           export DB_USER=SC3_${DB_USER}
         ;;
          MicroDev)
           export DB_USER=DI4_${DB_USER}
         ;;
          Marley)
           export DB_USER=MAR_${DB_USER}
         ;;
          RH65)
           export DB_USER=RH65_${DB_USER}
         ;;
          scrum4)
           export DB_USER=SC4_${DB_USER}
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

export DB_IP="dbrac03.cv.dr"
export DB_SID=scrum004
export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DB_IP})(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=${DB_SID})))"
#sqlplus -S ${DB_USER}/${DB_USER}@$SQLCONN <<!
sqlplus -S cm_system/oracle123@$SQLCONN <<!
set heading off;
set feedback off;
define DB_USER='$DB_USER'
set verify off
@/opt/build/scripts/check_dbversions.sql
exit
!
