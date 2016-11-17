CREATE USER NCIS_FW IDENTIFIED BY FREEWHEEL;
GRANT connect, resource, create ANY SYNONYM, create view, create trigger, create any trigger, create materialized view, create any materialized view, unlimited tablespace to NCIS_FW;
GRANT SELECT on CAAS_CORE_FW.FEED TO NCIS_FW;
GRANT SELECT on CAAS_CORE_FW.PROVIDER TO NCIS_FW;
GRANT SELECT on CAAS_CORE_FW.PROVIDER_ALIAS TO NCIS_FW;
