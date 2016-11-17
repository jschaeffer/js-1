create user DAI_REPORTING_SAFI identified by DAI_REPORTING_SAFI
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
        to DAI_REPORTING_SAFI;

prompt "Base grants complete"

grant select on CAAS_CORE.CAMPAIGN to DAI_REPORTING_SAFI;
grant select on CAAS_CORE.CAMPAIGN_ITEM to DAI_REPORTING_SAFI;
grant select on CAAS_CORE.CAMPAIGN_ITEM_MEDIA_ASSET to DAI_REPORTING_SAFI;
grant select on CAAS_CORE.CAMPAIGN_ITEM_DISCOUNT to DAI_REPORTING_SAFI;
grant select on CAAS_CORE.MEDIA_ASSET to DAI_REPORTING_SAFI;
grant select on CAAS_CORE.MEDIA_ASSET_METADATA_VALUE to DAI_REPORTING_SAFI;
grant select on CAAS_CORE.NETWORK to DAI_REPORTING_SAFI;
grant select on CAAS_CORE.OPERATOR to DAI_REPORTING_SAFI;
grant select on CAAS_CORE.PROGRAMMER to DAI_REPORTING_SAFI;
grant select on CAAS_CORE.PROVIDER to DAI_REPORTING_SAFI;
grant select on CAAS_CORE.PROVIDER_NETWORK to DAI_REPORTING_SAFI;
grant select on CAAS_CORE.FEED to DAI_REPORTING_SAFI;
GRANT SELECT, REFERENCES ON CAAS_CORE.PROGRAMMER TO DAI_REPORTING_SAFI;

