create user DAI_REPORTING_SAFI_BRD identified by DAI_REPORTING_SAFI_BRD
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
        to DAI_REPORTING_SAFI_BRD;

prompt "Base grants complete"

grant select on CAAS_CORE_BRD.CAMPAIGN to DAI_REPORTING_SAFI_BRD;
grant select on CAAS_CORE_BRD.CAMPAIGN_ITEM to DAI_REPORTING_SAFI_BRD;
grant select on CAAS_CORE_BRD.CAMPAIGN_ITEM_MEDIA_ASSET to DAI_REPORTING_SAFI_BRD;
grant select on CAAS_CORE_BRD.CAMPAIGN_ITEM_DISCOUNT to DAI_REPORTING_SAFI_BRD;
grant select on CAAS_CORE_BRD.MEDIA_ASSET to DAI_REPORTING_SAFI_BRD;
grant select on CAAS_CORE_BRD.MEDIA_ASSET_METADATA_VALUE to DAI_REPORTING_SAFI_BRD;
grant select on CAAS_CORE_BRD.NETWORK to DAI_REPORTING_SAFI_BRD;
grant select on CAAS_CORE_BRD.OPERATOR to DAI_REPORTING_SAFI_BRD;
grant select on CAAS_CORE_BRD.PROGRAMMER to DAI_REPORTING_SAFI_BRD;
grant select on CAAS_CORE_BRD.PROVIDER to DAI_REPORTING_SAFI_BRD;
grant select on CAAS_CORE_BRD.PROVIDER_NETWORK to DAI_REPORTING_SAFI_BRD;
grant select on CAAS_CORE_BRD.FEED to DAI_REPORTING_SAFI_BRD;
GRANT SELECT, REFERENCES ON CAAS_CORE_BRD.PROGRAMMER TO DAI_REPORTING_SAFI_BRD;

