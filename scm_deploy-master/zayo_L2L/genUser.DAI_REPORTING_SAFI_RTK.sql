create user DAI_REPORTING_SAFI_RTK identified by DAI_REPORTING_SAFI_RTK
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
        to DAI_REPORTING_SAFI_RTK;

prompt "Base grants complete"

grant select on CAAS_CORE_RTK.CAMPAIGN to DAI_REPORTING_SAFI_RTK;
grant select on CAAS_CORE_RTK.CAMPAIGN_ITEM to DAI_REPORTING_SAFI_RTK;
grant select on CAAS_CORE_RTK.CAMPAIGN_ITEM_MEDIA_ASSET to DAI_REPORTING_SAFI_RTK;
grant select on CAAS_CORE_RTK.CAMPAIGN_ITEM_DISCOUNT to DAI_REPORTING_SAFI_RTK;
grant select on CAAS_CORE_RTK.MEDIA_ASSET to DAI_REPORTING_SAFI_RTK;
grant select on CAAS_CORE_RTK.MEDIA_ASSET_METADATA_VALUE to DAI_REPORTING_SAFI_RTK;
grant select on CAAS_CORE_RTK.NETWORK to DAI_REPORTING_SAFI_RTK;
grant select on CAAS_CORE_RTK.OPERATOR to DAI_REPORTING_SAFI_RTK;
grant select on CAAS_CORE_RTK.PROGRAMMER to DAI_REPORTING_SAFI_RTK;
grant select on CAAS_CORE_RTK.PROVIDER to DAI_REPORTING_SAFI_RTK;
grant select on CAAS_CORE_RTK.PROVIDER_NETWORK to DAI_REPORTING_SAFI_RTK;
grant select on CAAS_CORE_RTK.FEED to DAI_REPORTING_SAFI_RTK;
GRANT SELECT, REFERENCES ON CAAS_CORE_RTK.PROGRAMMER TO DAI_REPORTING_SAFI_RTK;

