create user NCIS2 identified by NCIS2
default tablespace canoe_data
quota unlimited on canoe_data
quota unlimited on canoe_index
quota unlimited on canoe_data_compress
quota unlimited on canoe_data_compress2
quota unlimited on users
/
GRANT TABLE_OWNER TO NCIS2;
GRANT SELECT on CAAS_CORE.FEED TO NCIS2;
GRANT SELECT on CAAS_CORE.PROVIDER TO NCIS2;
GRANT SELECT on CAAS_CORE.PROVIDER_ALIAS TO NCIS2;
