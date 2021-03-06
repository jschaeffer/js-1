CREATE USER SC3_REMA IDENTIFIED BY SC3_REMA DEFAULT TABLESPACE canoe_data_compress
TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;

ALTER USER SC3_REMA QUOTA UNLIMITED ON CANOE_DATA_COMPRESS;
ALTER USER SC3_REMA QUOTA UNLIMITED ON CANOE_DATA;
ALTER USER SC3_REMA QUOTA UNLIMITED ON CANOE_INDEX;
GRANT resource, create session, create table, create sequence, DBA, scheduler_admin to SC3_REMA;
