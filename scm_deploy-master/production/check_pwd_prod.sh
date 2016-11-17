#!/bin/bash 

export DB_USER="COX_ALM2"

export SQLCONN="(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=prod-rac-scan.cv.prod)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=node4)))"
sqlplus -S Cm_system/Prod0ra@$SQLCONN <<!
set heading off;
set feedback off;
define DB_USER='$DB_USER'
set verify off
@/opt/build/scripts/production/check_pwd.sql
exit
!
