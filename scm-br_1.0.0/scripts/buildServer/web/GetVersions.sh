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
        TARGENV=${OPTARG}
	case $TARGENV in
	 devint)
	    Dynamic-Ad-Insertion-cm=
	    DB_USER=REPORTING_ODS
         ;;
	 scrum1)
	    export DB_USER=OSS_BAR
         ;;
	 scrum2)
	    export DB_USER=BILLING
         ;;
	 scrum3)
	    export DB_USER=CORE
         ;;
	esac
        ;;
      e)
        TARGENV=${OPTARG}
        if [[ $OPTARG = "MicroDev" ]]; then
            export DB_IP=10.13.18.55
	    export DB_USER=DI4_${DB_USER}
	    export DB_SID=dev004
        else
            export DB_IP=10.13.18.55
            export TARGENV=""
        fi
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


#echo "Identifying Sessions which are not tcserver application server sessions"
#echo "----------------------------------------------------------------------"

#echo "@id_sessiong_genscrum.sql ${DB_USER}; | 'cm_system/oracle123@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DB_IP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${DB_SID})))'"

#echo "@id_sessions_genscrum.sql ${DB_USER};" | sqlplus -s 'cm_system/oracle123@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DB_IP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${DB_SID})))'

echo "Killing Sessions which are not tcserver application server sessions"
echo "---------------------------------------------------------------------"

#echo "@kill_sessions_genscrum.sql $DB_IP $DB_USER;" | sqlplus -s 'cm_system/oracle123@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=$DB_IP)(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=$DB_SID)))' 

SQLPLUS="sqlplus -s /nolog 'cm_system/oracle123@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=$DB_IP)(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=$DB_SID)))'"

`$SQLPLUS`

set feedback off;
set heading off;

spool /tmp/ora_session_kill.sql

WITH vs AS
  (SELECT rownum rnum,
    sid,
    serial#,
    status,
    username,
    last_call_et,
    command,
    machine,
    osuser,
    module,
    action,
    resource_consumer_group,
    client_info,
    client_identifier,
    type,
    terminal
  FROM v$session
  )
SELECT 'ALTER SYSTEM KILL SESSION '''||vs.sid||', '||serial#||''' IMMEDIATE' ,
  vs.sid ,
  serial# serial,
  vs.username "Username",
  vs.machine "Machine",
  vs.osuser "OS User",
  lower(vs.status) "Status"
FROM vs
WHERE vs.USERNAME      = '&DB_USER'
AND NVL(vs.osuser,'x') <> 'SYSTEM'
AND vs.type            <> 'BACKGROUND'
--AND vs.username        IN ('MV_ADMIN','SA_ADMIN', 'IAP_ODS', 'DT_ADMIN', 'SYSDATA')
ORDER BY 1 ;

spool off;

--@/tmp/ora_session_kill.sql

