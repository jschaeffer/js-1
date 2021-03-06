CREATE USER SMSI_RELAY_GL IDENTIFIED BY SMSI_RELAY_GL DEFAULT TABLESPACE canoe_data_compress
TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;

GRANT SELECT ANY DICTIONARY TO SMSI_RELAY_GL;
GRANT ON COMMIT REFRESH TO SMSI_RELAY_GL;
GRANT GLOBAL QUERY REWRITE TO SMSI_RELAY_GL;
GRANT UNLIMITED TABLESPACE TO SMSI_RELAY_GL;
GRANT CREATE TRIGGER TO SMSI_RELAY_GL;
GRANT CREATE SESSION TO SMSI_RELAY_GL;
GRANT CREATE ANY JOB TO SMSI_RELAY_GL;
GRANT CREATE ANY MATERIALIZED VIEW TO SMSI_RELAY_GL;
GRANT CREATE SYNONYM TO SMSI_RELAY_GL;
GRANT CREATE MATERIALIZED VIEW TO SMSI_RELAY_GL;
GRANT CREATE TABLE TO SMSI_RELAY_GL;
GRANT CREATE VIEW TO SMSI_RELAY_GL;
GRANT CREATE SEQUENCE TO SMSI_RELAY_GL;
GRANT QUERY REWRITE TO SMSI_RELAY_GL;
GRANT CREATE JOB TO SMSI_RELAY_GL;
GRANT CREATE TYPE TO SMSI_RELAY_GL;
GRANT CREATE PROCEDURE TO SMSI_RELAY_GL;
GRANT SCHEDULER_ADMIN TO SMSI_RELAY_GL;

GRANT RESOURCE TO SMSI_RELAY_GL;
Grant create session, alter session to SMSI_RELAY_GL;


GRANT SELECT, REFERENCES ON CAAS_LOCAL.PROGRAMMER TO SMSI_RELAY_GL;
GRANT SELECT, REFERENCES ON CAAS_LOCAL.PROVIDER_NETWORK TO SMSI_RELAY_GL;
GRANT SELECT, REFERENCES ON CAAS_LOCAL.NETWORK TO SMSI_RELAY_GL;

CREATE USER SMSI_RELAY_GL1 IDENTIFIED BY SMSI_RELAY_GL1 DEFAULT TABLESPACE canoe_data_compress
TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;

GRANT SELECT ANY DICTIONARY TO SMSI_RELAY_GL1;
GRANT ON COMMIT REFRESH TO SMSI_RELAY_GL1;
GRANT GLOBAL QUERY REWRITE TO SMSI_RELAY_GL1;
GRANT UNLIMITED TABLESPACE TO SMSI_RELAY_GL1;
GRANT CREATE TRIGGER TO SMSI_RELAY_GL1;
GRANT CREATE SESSION TO SMSI_RELAY_GL1;
GRANT CREATE ANY JOB TO SMSI_RELAY_GL1;
GRANT CREATE ANY MATERIALIZED VIEW TO SMSI_RELAY_GL1;
GRANT CREATE SYNONYM TO SMSI_RELAY_GL1;
GRANT CREATE MATERIALIZED VIEW TO SMSI_RELAY_GL1;
GRANT CREATE TABLE TO SMSI_RELAY_GL1;
GRANT CREATE VIEW TO SMSI_RELAY_GL1;
GRANT CREATE SEQUENCE TO SMSI_RELAY_GL1;
GRANT QUERY REWRITE TO SMSI_RELAY_GL1;
GRANT CREATE JOB TO SMSI_RELAY_GL1;
GRANT CREATE TYPE TO SMSI_RELAY_GL1;
GRANT CREATE PROCEDURE TO SMSI_RELAY_GL1;
GRANT SCHEDULER_ADMIN TO SMSI_RELAY_GL1;

GRANT RESOURCE TO SMSI_RELAY_GL1;
Grant create session, alter session to SMSI_RELAY_GL1;


GRANT SELECT, REFERENCES ON CAAS_LOCAL.PROGRAMMER TO SMSI_RELAY_GL1;
GRANT SELECT, REFERENCES ON CAAS_LOCAL.PROVIDER_NETWORK TO SMSI_RELAY_GL1;
GRANT SELECT, REFERENCES ON CAAS_LOCAL.NETWORK TO SMSI_RELAY_GL1;

CREATE USER SMSI_RELAY_GL2 IDENTIFIED BY SMSI_RELAY_GL2 DEFAULT TABLESPACE canoe_data_compress
TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;
 
GRANT SELECT ANY DICTIONARY TO SMSI_RELAY_GL2;
GRANT ON COMMIT REFRESH TO SMSI_RELAY_GL2;
GRANT GLOBAL QUERY REWRITE TO SMSI_RELAY_GL2;
GRANT UNLIMITED TABLESPACE TO SMSI_RELAY_GL2;
GRANT CREATE TRIGGER TO SMSI_RELAY_GL2;
GRANT CREATE SESSION TO SMSI_RELAY_GL2;
GRANT CREATE ANY JOB TO SMSI_RELAY_GL2;
GRANT CREATE ANY MATERIALIZED VIEW TO SMSI_RELAY_GL2;
GRANT CREATE SYNONYM TO SMSI_RELAY_GL2;
GRANT CREATE MATERIALIZED VIEW TO SMSI_RELAY_GL2;
GRANT CREATE TABLE TO SMSI_RELAY_GL2;
GRANT CREATE VIEW TO SMSI_RELAY_GL2;
GRANT CREATE SEQUENCE TO SMSI_RELAY_GL2;
GRANT QUERY REWRITE TO SMSI_RELAY_GL2;
GRANT CREATE JOB TO SMSI_RELAY_GL2;
GRANT CREATE TYPE TO SMSI_RELAY_GL2;
GRANT CREATE PROCEDURE TO SMSI_RELAY_GL2;
GRANT SCHEDULER_ADMIN TO SMSI_RELAY_GL2;
 
GRANT RESOURCE TO SMSI_RELAY_GL2;
Grant create session, alter session to SMSI_RELAY_GL2;
 
 
GRANT SELECT, REFERENCES ON CAAS_LOCAL.PROGRAMMER TO SMSI_RELAY_GL2;
GRANT SELECT, REFERENCES ON CAAS_LOCAL.PROVIDER_NETWORK TO SMSI_RELAY_GL2;
GRANT SELECT, REFERENCES ON CAAS_LOCAL.NETWORK TO SMSI_RELAY_GL2;
