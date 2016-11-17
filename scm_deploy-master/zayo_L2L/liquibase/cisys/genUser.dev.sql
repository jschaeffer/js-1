CREATE USER REMA IDENTIFIED BY REMA DEFAULT TABLESPACE canoe_data_compress
TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;

ALTER USER REMA QUOTA UNLIMITED ON CANOE_DATA_COMPRESS;
ALTER USER REMA QUOTA UNLIMITED ON CANOE_DATA;
ALTER USER REMA QUOTA UNLIMITED ON CANOE_INDEX;
GRANT resource, create session, create table, create sequence, DBA, scheduler_admin to REMA;