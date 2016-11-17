create user REMA_REPORTING_SAFI identified by REMA_REPORTING_SAFI
    default tablespace CANOE_DATA
    quota unlimited on CANOE_DATA
    quota unlimited on CANOE_INDEX
    quota unlimited on CANOE_DATA_COMPRESS
    quota unlimited on CANOE_DATA_COMPRESS2;

!sleep 5

grant create table,
        create procedure,
        create trigger,
        create synonym,
        create sequence,
        create view,
        create type,
        create session,
        create any materialized view,
        create any table,
        comment any table,
        global query rewrite,
        select any table,
        scheduler_admin,
        resource,
        on commit refresh
        to REMA_REPORTING_SAFI;

prompt "Base grants complete"

grant select on CAAS_CORE.CAMPAIGN to REMA_REPORTING_SAFI;
grant select on CAAS_CORE.CAMPAIGN_ITEM to REMA_REPORTING_SAFI;
grant select on CAAS_CORE.CAMPAIGN_ITEM_MEDIA_ASSET to REMA_REPORTING_SAFI;
grant select on CAAS_CORE.CAMPAIGN_ITEM_DISCOUNT to REMA_REPORTING_SAFI;
grant select on CAAS_CORE.MEDIA_ASSET to REMA_REPORTING_SAFI;
grant select on CAAS_CORE.MEDIA_ASSET_METADATA_VALUE to REMA_REPORTING_SAFI;
grant select on CAAS_CORE.NETWORK to REMA_REPORTING_SAFI;
grant select on CAAS_CORE.OPERATOR to REMA_REPORTING_SAFI;
grant select on CAAS_CORE.PROGRAMMER to REMA_REPORTING_SAFI;
grant select on CAAS_CORE.PROVIDER to REMA_REPORTING_SAFI;
grant select on CAAS_CORE.PROVIDER_NETWORK to REMA_REPORTING_SAFI;
grant select on CAAS_CORE.FEED to REMA_REPORTING_SAFI;
GRANT SELECT, REFERENCES ON CAAS_CORE.PROGRAMMER TO REMA_REPORTING_SAFI;

