CREATE USER NCIS_GGL IDENTIFIED BY GOOGLE;
GRANT connect, resource, create ANY SYNONYM, create view, create trigger, create any trigger, create materialized view, create any materialized view, unlimited tablespace to NCIS_GGL;
GRANT SELECT on CAAS_LOCAL.FEED TO NCIS_GGL;
GRANT SELECT on CAAS_LOCAL.PROVIDER TO NCIS_GGL;
GRANT SELECT on CAAS_LOCAL.PROVIDER_ALIAS TO NCIS_GGL;
