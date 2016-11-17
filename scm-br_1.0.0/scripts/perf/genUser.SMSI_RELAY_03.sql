CREATE USER SMSI_RELAY_03 IDENTIFIED BY SMSI_RELAY_03 DEFAULT TABLESPACE canoe_data_compress
TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;
 
GRANT SELECT ANY DICTIONARY TO SMSI_RELAY_03;
GRANT ON COMMIT REFRESH TO SMSI_RELAY_03;
GRANT GLOBAL QUERY REWRITE TO SMSI_RELAY_03;
GRANT UNLIMITED TABLESPACE TO SMSI_RELAY_03;
GRANT CREATE TRIGGER TO SMSI_RELAY_03;
GRANT CREATE SESSION TO SMSI_RELAY_03;
GRANT CREATE ANY JOB TO SMSI_RELAY_03;
GRANT CREATE ANY MATERIALIZED VIEW TO SMSI_RELAY_03;
GRANT CREATE SYNONYM TO SMSI_RELAY_03;
GRANT CREATE MATERIALIZED VIEW TO SMSI_RELAY_03;
GRANT CREATE TABLE TO SMSI_RELAY_03;
GRANT CREATE VIEW TO SMSI_RELAY_03;
GRANT CREATE SEQUENCE TO SMSI_RELAY_03;
GRANT QUERY REWRITE TO SMSI_RELAY_03;
GRANT CREATE JOB TO SMSI_RELAY_03;
GRANT CREATE TYPE TO SMSI_RELAY_03;
GRANT CREATE PROCEDURE TO SMSI_RELAY_03;
GRANT SCHEDULER_ADMIN TO SMSI_RELAY_03;
 
GRANT RESOURCE TO SMSI_RELAY_03;
Grant create session, alter session to SMSI_RELAY_03;
 
 
GRANT SELECT, REFERENCES ON CAAS_CORE.PROGRAMMER TO SMSI_RELAY_03;
GRANT SELECT, REFERENCES ON CAAS_CORE.PROVIDER_NETWORK TO SMSI_RELAY_03;
GRANT SELECT, REFERENCES ON CAAS_CORE.NETWORK TO SMSI_RELAY_03;