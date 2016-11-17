#!/bin/bash 

export JDBC_URL="jdbc:oracle:thin:@dbrac03.cv.dr:1521:pro001"
export DB_IP="dbrac03.cv.dr"
export DB_SID="pro001"


export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DB_IP})(PORT=1522)))(CONNECT_DATA=(SERVICE_NAME=${DB_SID})))"
sqlplus -S ${DB_USER}/${DB_PASS}@$SQLCONN <<!
set heading off;
set feedback off;
define DB_USER='$DB_USER'
set verify off
@/opt/build/scripts/check_dbversions.sql
exit
!
