CREATE USER CAAS_CORE_BRD IDENTIFIED BY BROADWAY DEFAULT TABLESPACE CANOE_DATA TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK quota unlimited on canoe_data quota unlimited on canoe_index quota unlimited on canoe_data_compress;

ALTER USER CAAS_CORE_BRD QUOTA UNLIMITED ON CANOE_DATA; 
ALTER USER CAAS_CORE_BRD QUOTA UNLIMITED ON CANOE_INDEX;
GRANT SELECT ANY CUBE DIMENSION TO CAAS_CORE_BRD; 
GRANT SELECT ANY TRANSACTION TO CAAS_CORE_BRD;
GRANT UNDER ANY VIEW TO CAAS_CORE_BRD;
GRANT CREATE INDEXTYPE TO CAAS_CORE_BRD;
GRANT DROP ANY MATERIALIZED VIEW TO CAAS_CORE_BRD;
GRANT CREATE ANY TRIGGER TO CAAS_CORE_BRD;
GRANT CREATE ANY VIEW TO CAAS_CORE_BRD; 
GRANT DROP ANY SYNONYM TO CAAS_CORE_BRD;
GRANT UPDATE ANY TABLE TO CAAS_CORE_BRD;
GRANT LOCK ANY TABLE TO CAAS_CORE_BRD;
GRANT CREATE SESSION TO CAAS_CORE_BRD;
GRANT SELECT ANY CUBE TO CAAS_CORE_BRD; 
GRANT EXECUTE ASSEMBLY TO CAAS_CORE_BRD;
GRANT CREATE ANY SQL PROFILE TO CAAS_CORE_BRD;
GRANT DROP ANY RULE SET TO CAAS_CORE_BRD; 
GRANT CREATE ANY PROCEDURE TO CAAS_CORE_BRD;
GRANT CREATE ANY SYNONYM TO CAAS_CORE_BRD;
GRANT INSERT ANY TABLE TO CAAS_CORE_BRD;
GRANT CREATE ANY MEASURE FOLDER TO CAAS_CORE_BRD; 
GRANT EXECUTE ANY RULE SET TO CAAS_CORE_BRD;
GRANT MERGE ANY VIEW TO CAAS_CORE_BRD;
GRANT QUERY REWRITE TO CAAS_CORE_BRD; 
GRANT CREATE ANY INDEXTYPE TO CAAS_CORE_BRD;
GRANT CREATE PROCEDURE TO CAAS_CORE_BRD;
GRANT SELECT ANY TABLE TO CAAS_CORE_BRD;
GRANT SELECT ANY MINING MODEL TO CAAS_CORE_BRD; 
GRANT CREATE ANY RULE TO CAAS_CORE_BRD; 
GRANT ON COMMIT REFRESH TO CAAS_CORE_BRD; 
GRANT CREATE MATERIALIZED VIEW TO CAAS_CORE_BRD;
GRANT DROP ANY SEQUENCE TO CAAS_CORE_BRD; 
GRANT CREATE PUBLIC SYNONYM TO CAAS_CORE_BRD; 
GRANT CREATE TABLE TO CAAS_CORE_BRD;
GRANT BECOME USER TO CAAS_CORE_BRD; 
GRANT UNLIMITED TABLESPACE TO CAAS_CORE_BRD;
GRANT UPDATE ANY CUBE BUILD PROCESS TO CAAS_CORE_BRD; 
GRANT CREATE ANY CUBE BUILD PROCESS TO CAAS_CORE_BRD; 
GRANT UPDATE ANY CUBE TO CAAS_CORE_BRD; 
GRANT CREATE ANY CUBE TO CAAS_CORE_BRD; 
GRANT CREATE JOB TO CAAS_CORE_BRD;
GRANT ANALYZE ANY DICTIONARY TO CAAS_CORE_BRD;
GRANT SELECT ANY SEQUENCE TO CAAS_CORE_BRD; 
GRANT UPDATE ANY CUBE DIMENSION TO CAAS_CORE_BRD; 
GRANT DROP ANY RULE TO CAAS_CORE_BRD; 
GRANT CREATE ANY RULE SET TO CAAS_CORE_BRD; 
GRANT CREATE ANY DIMENSION TO CAAS_CORE_BRD;
GRANT CREATE ANY TYPE TO CAAS_CORE_BRD; 
GRANT CREATE TYPE TO CAAS_CORE_BRD; 
GRANT CREATE VIEW TO CAAS_CORE_BRD; 
GRANT CREATE ANY INDEX TO CAAS_CORE_BRD;
GRANT DELETE ANY MEASURE FOLDER TO CAAS_CORE_BRD; 
GRANT DELETE ANY CUBE DIMENSION TO CAAS_CORE_BRD; 
GRANT CREATE ANY CUBE DIMENSION TO CAAS_CORE_BRD; 
GRANT CREATE ANY EDITION TO CAAS_CORE_BRD;
GRANT EXECUTE ANY RULE TO CAAS_CORE_BRD;
GRANT SELECT ANY DICTIONARY TO CAAS_CORE_BRD; 
GRANT GLOBAL QUERY REWRITE TO CAAS_CORE_BRD;
GRANT UNDER ANY TYPE TO CAAS_CORE_BRD;
GRANT CREATE ANY SEQUENCE TO CAAS_CORE_BRD; 
GRANT CREATE SYNONYM TO CAAS_CORE_BRD;
GRANT DELETE ANY TABLE TO CAAS_CORE_BRD;
GRANT COMMENT ANY TABLE TO CAAS_CORE_BRD; 
GRANT CREATE ANY TABLE TO CAAS_CORE_BRD;
GRANT UNDER ANY TABLE TO CAAS_CORE_BRD; 
GRANT CREATE ANY MATERIALIZED VIEW TO CAAS_CORE_BRD;
GRANT ANALYZE ANY TO CAAS_CORE_BRD; 
GRANT CREATE TRIGGER TO CAAS_CORE_BRD;
GRANT FORCE TRANSACTION TO CAAS_CORE_BRD; 
GRANT CREATE SEQUENCE TO CAAS_CORE_BRD; 
GRANT CONNECT TO CAAS_CORE_BRD;
GRANT RESOURCE TO CAAS_CORE_BRD; 
ALTER USER CAAS_CORE_BRD DEFAULT ROLE CONNECT,RESOURCE;
CREATE FLASHBACK ARCHIVE audit_campaign TABLESPACE canoe_audit QUOTA 2G RETENTION 24 MONTH;
CREATE FLASHBACK ARCHIVE audit_media_asset TABLESPACE canoe_audit QUOTA 2G RETENTION 24 MONTH;
GRANT FLASHBACK ARCHIVE ON audit_campaign TO CAAS40;
GRANT FLASHBACK ARCHIVE ON audit_media_asset TO CAAS40;
GRANT FLASHBACK ARCHIVE ON audit_campaign TO CAAS_LOCAL;
GRANT FLASHBACK ARCHIVE ON audit_media_asset TO CAAS_LOCAL;
GRANT FLASHBACK ARCHIVE ON audit_campaign TO CAAS_CORE_FW;
GRANT FLASHBACK ARCHIVE ON audit_media_asset TO CAAS_CORE_FW;
GRANT FLASHBACK ARCHIVE ON audit_campaign TO CAAS_CORE_BRD;
GRANT FLASHBACK ARCHIVE ON audit_media_asset TO CAAS_CORE_BRD;
~