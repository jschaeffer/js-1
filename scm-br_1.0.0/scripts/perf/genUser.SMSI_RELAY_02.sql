CREATE USER SMSI_RELAY_02 IDENTIFIED BY SMSI_RELAY_02 DEFAULT TABLESPACE canoe_data_compress
TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;
 
GRANT SELECT ANY DICTIONARY TO SMSI_RELAY_02;
GRANT ON COMMIT REFRESH TO SMSI_RELAY_02;
GRANT GLOBAL QUERY REWRITE TO SMSI_RELAY_02;
GRANT UNLIMITED TABLESPACE TO SMSI_RELAY_02;
GRANT CREATE TRIGGER TO SMSI_RELAY_02;
GRANT CREATE SESSION TO SMSI_RELAY_02;
GRANT CREATE ANY JOB TO SMSI_RELAY_02;
GRANT CREATE ANY MATERIALIZED VIEW TO SMSI_RELAY_02;
GRANT CREATE SYNONYM TO SMSI_RELAY_02;
GRANT CREATE MATERIALIZED VIEW TO SMSI_RELAY_02;
GRANT CREATE TABLE TO SMSI_RELAY_02;
GRANT CREATE VIEW TO SMSI_RELAY_02;
GRANT CREATE SEQUENCE TO SMSI_RELAY_02;
GRANT QUERY REWRITE TO SMSI_RELAY_02;
GRANT CREATE JOB TO SMSI_RELAY_02;
GRANT CREATE TYPE TO SMSI_RELAY_02;
GRANT CREATE PROCEDURE TO SMSI_RELAY_02;
GRANT SCHEDULER_ADMIN TO SMSI_RELAY_02;
 
GRANT RESOURCE TO SMSI_RELAY_02;
Grant create session, alter session to SMSI_RELAY_02;
 
 
GRANT SELECT, REFERENCES ON CAAS_CORE.PROGRAMMER TO SMSI_RELAY_02;
GRANT SELECT, REFERENCES ON CAAS_CORE.PROVIDER_NETWORK TO SMSI_RELAY_02;
GRANT SELECT, REFERENCES ON CAAS_CORE.NETWORK TO SMSI_RELAY_02;
