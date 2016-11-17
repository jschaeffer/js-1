CREATE USER CAAS_LOCAL IDENTIFIED BY KODIAK DEFAULT TABLESPACE CANOE_DATA TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;

ALTER USER CAAS_LOCAL QUOTA UNLIMITED ON CANOE_DATA; 
ALTER USER CAAS_LOCAL QUOTA UNLIMITED ON CANOE_INDEX;
ALTER USER CAAS_LOCAL QUOTA UNLIMITED ON CANOE_AUDIT;
GRANT SELECT ANY CUBE DIMENSION TO CAAS_LOCAL; 
GRANT SELECT ANY TRANSACTION TO CAAS_LOCAL;
GRANT UNDER ANY VIEW TO CAAS_LOCAL;
GRANT CREATE INDEXTYPE TO CAAS_LOCAL;
GRANT DROP ANY MATERIALIZED VIEW TO CAAS_LOCAL;
GRANT CREATE ANY TRIGGER TO CAAS_LOCAL;
GRANT CREATE ANY VIEW TO CAAS_LOCAL; 
GRANT DROP ANY SYNONYM TO CAAS_LOCAL;
GRANT UPDATE ANY TABLE TO CAAS_LOCAL;
GRANT LOCK ANY TABLE TO CAAS_LOCAL;
GRANT CREATE SESSION TO CAAS_LOCAL;
GRANT SELECT ANY CUBE TO CAAS_LOCAL; 
GRANT EXECUTE ASSEMBLY TO CAAS_LOCAL;
GRANT CREATE ANY SQL PROFILE TO CAAS_LOCAL;
GRANT DROP ANY RULE SET TO CAAS_LOCAL; 
GRANT CREATE ANY PROCEDURE TO CAAS_LOCAL;
GRANT CREATE ANY SYNONYM TO CAAS_LOCAL;
GRANT INSERT ANY TABLE TO CAAS_LOCAL;
GRANT CREATE ANY MEASURE FOLDER TO CAAS_LOCAL; 
GRANT EXECUTE ANY RULE SET TO CAAS_LOCAL;
GRANT MERGE ANY VIEW TO CAAS_LOCAL;
GRANT QUERY REWRITE TO CAAS_LOCAL; 
GRANT CREATE ANY INDEXTYPE TO CAAS_LOCAL;
GRANT CREATE PROCEDURE TO CAAS_LOCAL;
GRANT SELECT ANY TABLE TO CAAS_LOCAL;
GRANT SELECT ANY MINING MODEL TO CAAS_LOCAL; 
GRANT CREATE ANY RULE TO CAAS_LOCAL; 
GRANT ON COMMIT REFRESH TO CAAS_LOCAL; 
GRANT CREATE MATERIALIZED VIEW TO CAAS_LOCAL;
GRANT DROP ANY SEQUENCE TO CAAS_LOCAL; 
GRANT CREATE PUBLIC SYNONYM TO CAAS_LOCAL; 
GRANT CREATE TABLE TO CAAS_LOCAL;
GRANT BECOME USER TO CAAS_LOCAL; 
GRANT UNLIMITED TABLESPACE TO CAAS_LOCAL;
GRANT UPDATE ANY CUBE BUILD PROCESS TO CAAS_LOCAL; 
GRANT CREATE ANY CUBE BUILD PROCESS TO CAAS_LOCAL; 
GRANT UPDATE ANY CUBE TO CAAS_LOCAL; 
GRANT CREATE ANY CUBE TO CAAS_LOCAL; 
GRANT CREATE JOB TO CAAS_LOCAL;
GRANT ANALYZE ANY DICTIONARY TO CAAS_LOCAL;
GRANT SELECT ANY SEQUENCE TO CAAS_LOCAL; 
GRANT UPDATE ANY CUBE DIMENSION TO CAAS_LOCAL; 
GRANT DROP ANY RULE TO CAAS_LOCAL; 
GRANT CREATE ANY RULE SET TO CAAS_LOCAL; 
GRANT CREATE ANY DIMENSION TO CAAS_LOCAL;
GRANT CREATE ANY TYPE TO CAAS_LOCAL; 
GRANT CREATE TYPE TO CAAS_LOCAL; 
GRANT CREATE VIEW TO CAAS_LOCAL; 
GRANT CREATE ANY INDEX TO CAAS_LOCAL;
GRANT DELETE ANY MEASURE FOLDER TO CAAS_LOCAL; 
GRANT DELETE ANY CUBE DIMENSION TO CAAS_LOCAL; 
GRANT CREATE ANY CUBE DIMENSION TO CAAS_LOCAL; 
GRANT CREATE ANY EDITION TO CAAS_LOCAL;
GRANT EXECUTE ANY RULE TO CAAS_LOCAL;
GRANT SELECT ANY DICTIONARY TO CAAS_LOCAL; 
GRANT GLOBAL QUERY REWRITE TO CAAS_LOCAL;
GRANT UNDER ANY TYPE TO CAAS_LOCAL;
GRANT CREATE ANY SEQUENCE TO CAAS_LOCAL; 
GRANT CREATE SYNONYM TO CAAS_LOCAL;
GRANT DELETE ANY TABLE TO CAAS_LOCAL;
GRANT COMMENT ANY TABLE TO CAAS_LOCAL; 
GRANT CREATE ANY TABLE TO CAAS_LOCAL;
GRANT UNDER ANY TABLE TO CAAS_LOCAL; 
GRANT CREATE ANY MATERIALIZED VIEW TO CAAS_LOCAL;
GRANT ANALYZE ANY TO CAAS_LOCAL; 
GRANT CREATE TRIGGER TO CAAS_LOCAL;
GRANT FORCE TRANSACTION TO CAAS_LOCAL; 
GRANT CREATE SEQUENCE TO CAAS_LOCAL; 
GRANT CONNECT TO CAAS_LOCAL;
GRANT RESOURCE TO CAAS_LOCAL; 
ALTER USER CAAS_LOCAL DEFAULT ROLE CONNECT,RESOURCE;
GRANT FLASHBACK ARCHIVE ON audit_campaign TO CAAS_LOCAL;
GRANT FLASHBACK ARCHIVE ON audit_media_asset TO CAAS_LOCAL;