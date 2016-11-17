create user DAI_REPORTING_SAFI identified by DAI_REPORTING_SAFI
    default tablespace CANOE_DATA
    quota unlimited on CANOE_DATA
    quota unlimited on CANOE_INDEX
    quota unlimited on CANOE_DATA_COMPRESS;


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

grant select on CAAS40.CAMPAIGN to DAI_REPORTING_SAFI;
grant select on CAAS40.CAMPAIGN_ITEM to DAI_REPORTING_SAFI;
grant select on CAAS40.CAMPAIGN_ITEM_MEDIA_ASSET to DAI_REPORTING_SAFI;
grant select on CAAS40.CAMPAIGN_ITEM_DISCOUNT to DAI_REPORTING_SAFI;
grant select on CAAS40.MEDIA_ASSET to DAI_REPORTING_SAFI;
grant select on CAAS40.MEDIA_ASSET_METADATA_VALUE to DAI_REPORTING_SAFI;
grant select on CAAS40.NETWORK to DAI_REPORTING_SAFI;
grant select on CAAS40.OPERATOR to DAI_REPORTING_SAFI;
grant select on CAAS40.PROGRAMMER to DAI_REPORTING_SAFI;
grant select on CAAS40.PROVIDER to DAI_REPORTING_SAFI;
grant select on CAAS40.PROVIDER_NETWORK to DAI_REPORTING_SAFI;
grant select on CAAS40.FEED to DAI_REPORTING_SAFI;
GRANT SELECT, REFERENCES ON CAAS40.PROGRAMMER TO DAI_REPORTING_SAFI;

