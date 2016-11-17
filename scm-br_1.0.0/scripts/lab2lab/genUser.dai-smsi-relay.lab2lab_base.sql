CREATE USER SMSI_RELAY IDENTIFIED BY SMSI_RELAY DEFAULT TABLESPACE canoe_data_compress
TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;

GRANT SELECT ANY DICTIONARY TO SMSI_RELAY;
GRANT ON COMMIT REFRESH TO SMSI_RELAY;
GRANT GLOBAL QUERY REWRITE TO SMSI_RELAY;
GRANT UNLIMITED TABLESPACE TO SMSI_RELAY;
GRANT CREATE TRIGGER TO SMSI_RELAY;
GRANT CREATE SESSION TO SMSI_RELAY;
GRANT CREATE ANY JOB TO SMSI_RELAY;
GRANT CREATE ANY MATERIALIZED VIEW TO SMSI_RELAY;
GRANT CREATE SYNONYM TO SMSI_RELAY;
GRANT CREATE MATERIALIZED VIEW TO SMSI_RELAY;
GRANT CREATE TABLE TO SMSI_RELAY;
GRANT CREATE VIEW TO SMSI_RELAY;
GRANT CREATE SEQUENCE TO SMSI_RELAY;
GRANT QUERY REWRITE TO SMSI_RELAY;
GRANT CREATE JOB TO SMSI_RELAY;
GRANT CREATE TYPE TO SMSI_RELAY;
GRANT CREATE PROCEDURE TO SMSI_RELAY;
GRANT SCHEDULER_ADMIN TO SMSI_RELAY;

GRANT RESOURCE TO SMSI_RELAY;
Grant create session, alter session to SMSI_RELAY;


GRANT SELECT, REFERENCES ON CAAS40.PROGRAMMER TO SMSI_RELAY;
GRANT SELECT, REFERENCES ON CAAS40.PROVIDER_NETWORK TO SMSI_RELAY;
GRANT SELECT, REFERENCES ON CAAS40.NETWORK TO SMSI_RELAY;


CREATE USER SMSI_RELAY1 IDENTIFIED BY SMSI_RELAY1 DEFAULT TABLESPACE canoe_data_compress
TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;

GRANT SELECT ANY DICTIONARY TO SMSI_RELAY1;
GRANT ON COMMIT REFRESH TO SMSI_RELAY1;
GRANT GLOBAL QUERY REWRITE TO SMSI_RELAY1;
GRANT UNLIMITED TABLESPACE TO SMSI_RELAY1;
GRANT CREATE TRIGGER TO SMSI_RELAY1;
GRANT CREATE SESSION TO SMSI_RELAY1;
GRANT CREATE ANY JOB TO SMSI_RELAY1;
GRANT CREATE ANY MATERIALIZED VIEW TO SMSI_RELAY1;
GRANT CREATE SYNONYM TO SMSI_RELAY1;
GRANT CREATE MATERIALIZED VIEW TO SMSI_RELAY1;
GRANT CREATE TABLE TO SMSI_RELAY1;
GRANT CREATE VIEW TO SMSI_RELAY1;
GRANT CREATE SEQUENCE TO SMSI_RELAY1;
GRANT QUERY REWRITE TO SMSI_RELAY1;
GRANT CREATE JOB TO SMSI_RELAY1;
GRANT CREATE TYPE TO SMSI_RELAY1;
GRANT CREATE PROCEDURE TO SMSI_RELAY1;
GRANT SCHEDULER_ADMIN TO SMSI_RELAY1;

GRANT RESOURCE TO SMSI_RELAY1;
Grant create session, alter session to SMSI_RELAY1;


GRANT SELECT, REFERENCES ON CAAS40.PROGRAMMER TO SMSI_RELAY1;
GRANT SELECT, REFERENCES ON CAAS40.PROVIDER_NETWORK TO SMSI_RELAY1;
GRANT SELECT, REFERENCES ON CAAS40.NETWORK TO SMSI_RELAY1;

CREATE USER SMSI_RELAY2 IDENTIFIED BY SMSI_RELAY2 DEFAULT TABLESPACE canoe_data_compress
TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;
 
GRANT SELECT ANY DICTIONARY TO SMSI_RELAY2;
GRANT ON COMMIT REFRESH TO SMSI_RELAY2;
GRANT GLOBAL QUERY REWRITE TO SMSI_RELAY2;
GRANT UNLIMITED TABLESPACE TO SMSI_RELAY2;
GRANT CREATE TRIGGER TO SMSI_RELAY2;
GRANT CREATE SESSION TO SMSI_RELAY2;
GRANT CREATE ANY JOB TO SMSI_RELAY2;
GRANT CREATE ANY MATERIALIZED VIEW TO SMSI_RELAY2;
GRANT CREATE SYNONYM TO SMSI_RELAY2;
GRANT CREATE MATERIALIZED VIEW TO SMSI_RELAY2;
GRANT CREATE TABLE TO SMSI_RELAY2;
GRANT CREATE VIEW TO SMSI_RELAY2;
GRANT CREATE SEQUENCE TO SMSI_RELAY2;
GRANT QUERY REWRITE TO SMSI_RELAY2;
GRANT CREATE JOB TO SMSI_RELAY2;
GRANT CREATE TYPE TO SMSI_RELAY2;
GRANT CREATE PROCEDURE TO SMSI_RELAY2;
GRANT SCHEDULER_ADMIN TO SMSI_RELAY2;
 
GRANT RESOURCE TO SMSI_RELAY2;
Grant create session, alter session to SMSI_RELAY2;
 
 
GRANT SELECT, REFERENCES ON CAAS40.PROGRAMMER TO SMSI_RELAY2;
GRANT SELECT, REFERENCES ON CAAS40.PROVIDER_NETWORK TO SMSI_RELAY2;
GRANT SELECT, REFERENCES ON CAAS40.NETWORK TO SMSI_RELAY2;
