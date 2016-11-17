CREATE USER SMSI_RELAY_FW IDENTIFIED BY SMSI_RELAY_FW DEFAULT TABLESPACE canoe_data_compress
TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;

GRANT SELECT ANY DICTIONARY TO SMSI_RELAY_FW;
GRANT ON COMMIT REFRESH TO SMSI_RELAY_FW;
GRANT GLOBAL QUERY REWRITE TO SMSI_RELAY_FW;
GRANT UNLIMITED TABLESPACE TO SMSI_RELAY_FW;
GRANT CREATE TRIGGER TO SMSI_RELAY_FW;
GRANT CREATE SESSION TO SMSI_RELAY_FW;
GRANT CREATE ANY JOB TO SMSI_RELAY_FW;
GRANT CREATE ANY MATERIALIZED VIEW TO SMSI_RELAY_FW;
GRANT CREATE SYNONYM TO SMSI_RELAY_FW;
GRANT CREATE MATERIALIZED VIEW TO SMSI_RELAY_FW;
GRANT CREATE TABLE TO SMSI_RELAY_FW;
GRANT CREATE VIEW TO SMSI_RELAY_FW;
GRANT CREATE SEQUENCE TO SMSI_RELAY_FW;
GRANT QUERY REWRITE TO SMSI_RELAY_FW;
GRANT CREATE JOB TO SMSI_RELAY_FW;
GRANT CREATE TYPE TO SMSI_RELAY_FW;
GRANT CREATE PROCEDURE TO SMSI_RELAY_FW;
GRANT SCHEDULER_ADMIN TO SMSI_RELAY_FW;

GRANT RESOURCE TO SMSI_RELAY_FW;
Grant create session, alter session to SMSI_RELAY_FW;


GRANT SELECT, REFERENCES ON CAAS_CORE_FW.PROGRAMMER TO SMSI_RELAY_FW;
GRANT SELECT, REFERENCES ON CAAS_CORE_FW.PROVIDER_NETWORK TO SMSI_RELAY_FW;
GRANT SELECT, REFERENCES ON CAAS_CORE_FW.NETWORK TO SMSI_RELAY_FW;

CREATE USER SMSI_RELAY_FW1 IDENTIFIED BY SMSI_RELAY_FW1 DEFAULT TABLESPACE canoe_data_compress
TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;

GRANT SELECT ANY DICTIONARY TO SMSI_RELAY_FW1;
GRANT ON COMMIT REFRESH TO SMSI_RELAY_FW1;
GRANT GLOBAL QUERY REWRITE TO SMSI_RELAY_FW1;
GRANT UNLIMITED TABLESPACE TO SMSI_RELAY_FW1;
GRANT CREATE TRIGGER TO SMSI_RELAY_FW1;
GRANT CREATE SESSION TO SMSI_RELAY_FW1;
GRANT CREATE ANY JOB TO SMSI_RELAY_FW1;
GRANT CREATE ANY MATERIALIZED VIEW TO SMSI_RELAY_FW1;
GRANT CREATE SYNONYM TO SMSI_RELAY_FW1;
GRANT CREATE MATERIALIZED VIEW TO SMSI_RELAY_FW1;
GRANT CREATE TABLE TO SMSI_RELAY_FW1;
GRANT CREATE VIEW TO SMSI_RELAY_FW1;
GRANT CREATE SEQUENCE TO SMSI_RELAY_FW1;
GRANT QUERY REWRITE TO SMSI_RELAY_FW1;
GRANT CREATE JOB TO SMSI_RELAY_FW1;
GRANT CREATE TYPE TO SMSI_RELAY_FW1;
GRANT CREATE PROCEDURE TO SMSI_RELAY_FW1;
GRANT SCHEDULER_ADMIN TO SMSI_RELAY_FW1;

GRANT RESOURCE TO SMSI_RELAY_FW1;
Grant create session, alter session to SMSI_RELAY_FW1;


GRANT SELECT, REFERENCES ON CAAS_CORE_FW.PROGRAMMER TO SMSI_RELAY_FW1;
GRANT SELECT, REFERENCES ON CAAS_CORE_FW.PROVIDER_NETWORK TO SMSI_RELAY_FW1;
GRANT SELECT, REFERENCES ON CAAS_CORE_FW.NETWORK TO SMSI_RELAY_FW1;

CREATE USER SMSI_RELAY_FW2 IDENTIFIED BY SMSI_RELAY_FW2 DEFAULT TABLESPACE canoe_data_compress
TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;
 
GRANT SELECT ANY DICTIONARY TO SMSI_RELAY_FW2;
GRANT ON COMMIT REFRESH TO SMSI_RELAY_FW2;
GRANT GLOBAL QUERY REWRITE TO SMSI_RELAY_FW2;
GRANT UNLIMITED TABLESPACE TO SMSI_RELAY_FW2;
GRANT CREATE TRIGGER TO SMSI_RELAY_FW2;
GRANT CREATE SESSION TO SMSI_RELAY_FW2;
GRANT CREATE ANY JOB TO SMSI_RELAY_FW2;
GRANT CREATE ANY MATERIALIZED VIEW TO SMSI_RELAY_FW2;
GRANT CREATE SYNONYM TO SMSI_RELAY_FW2;
GRANT CREATE MATERIALIZED VIEW TO SMSI_RELAY_FW2;
GRANT CREATE TABLE TO SMSI_RELAY_FW2;
GRANT CREATE VIEW TO SMSI_RELAY_FW2;
GRANT CREATE SEQUENCE TO SMSI_RELAY_FW2;
GRANT QUERY REWRITE TO SMSI_RELAY_FW2;
GRANT CREATE JOB TO SMSI_RELAY_FW2;
GRANT CREATE TYPE TO SMSI_RELAY_FW2;
GRANT CREATE PROCEDURE TO SMSI_RELAY_FW2;
GRANT SCHEDULER_ADMIN TO SMSI_RELAY_FW2;
 
GRANT RESOURCE TO SMSI_RELAY_FW2;
Grant create session, alter session to SMSI_RELAY_FW2;
 
 
GRANT SELECT, REFERENCES ON CAAS_CORE_FW.PROGRAMMER TO SMSI_RELAY_FW2;
GRANT SELECT, REFERENCES ON CAAS_CORE_FW.PROVIDER_NETWORK TO SMSI_RELAY_FW2;
GRANT SELECT, REFERENCES ON CAAS_CORE_FW.NETWORK TO SMSI_RELAY_FW2;