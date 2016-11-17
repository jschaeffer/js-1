create user DAI_REPORTING_SAFI_TWL identified by KODIAK
    default tablespace CANOE_DATA
    quota unlimited on CANOE_DATA
    quota unlimited on CANOE_INDEX
    quota unlimited on CANOE_DATA_COMPRESS;

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
        to DAI_REPORTING_SAFI_TWL;

prompt "Base grants complete"

grant select on CAAS_LOCAL.CAMPAIGN to DAI_REPORTING_SAFI_TWL;
grant select on CAAS_LOCAL.CAMPAIGN_ITEM to DAI_REPORTING_SAFI_TWL;
grant select on CAAS_LOCAL.CAMPAIGN_ITEM_MEDIA_ASSET to DAI_REPORTING_SAFI_TWL;
grant select on CAAS_LOCAL.CAMPAIGN_ITEM_DISCOUNT to DAI_REPORTING_SAFI_TWL;
grant select on CAAS_LOCAL.MEDIA_ASSET to DAI_REPORTING_SAFI_TWL;
grant select on CAAS_LOCAL.MEDIA_ASSET_METADATA_VALUE to DAI_REPORTING_SAFI_TWL;
grant select on CAAS_LOCAL.NETWORK to DAI_REPORTING_SAFI_TWL;
grant select on CAAS_LOCAL.OPERATOR to DAI_REPORTING_SAFI_TWL;
grant select on CAAS_LOCAL.PROGRAMMER to DAI_REPORTING_SAFI_TWL;
grant select on CAAS_LOCAL.PROVIDER to DAI_REPORTING_SAFI_TWL;
grant select on CAAS_LOCAL.PROVIDER_NETWORK to DAI_REPORTING_SAFI_TWL;
grant select on CAAS_LOCAL.FEED to DAI_REPORTING_SAFI_TWL;
GRANT SELECT, REFERENCES ON CAAS_LOCAL.PROGRAMMER TO DAI_REPORTING_SAFI_TWL;

