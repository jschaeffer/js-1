CREATE USER NCIS IDENTIFIED BY NCIS;
GRANT TABLE_OWNER TO NCIS;
GRANT SELECT on CAAS_CORE.FEED TO NCIS;
GRANT SELECT on CAAS_CORE.PROVIDER TO NCIS;
GRANT SELECT on CAAS_CORE.PROVIDER_ALIAS TO NCIS;
