create user DAI_REPORTING_SAFI_FW identified by FREEWHEEL
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
        to DAI_REPORTING_SAFI_FW;

prompt "Base grants complete"

grant select on CAAS_CORE_FW.CAMPAIGN to DAI_REPORTING_SAFI_FW;
grant select on CAAS_CORE_FW.CAMPAIGN_ITEM to DAI_REPORTING_SAFI_FW;
grant select on CAAS_CORE_FW.CAMPAIGN_ITEM_MEDIA_ASSET to DAI_REPORTING_SAFI_FW;
grant select on CAAS_CORE_FW.CAMPAIGN_ITEM_DISCOUNT to DAI_REPORTING_SAFI_FW;
grant select on CAAS_CORE_FW.MEDIA_ASSET to DAI_REPORTING_SAFI_FW;
grant select on CAAS_CORE_FW.MEDIA_ASSET_METADATA_VALUE to DAI_REPORTING_SAFI_FW;
grant select on CAAS_CORE_FW.NETWORK to DAI_REPORTING_SAFI_FW;
grant select on CAAS_CORE_FW.OPERATOR to DAI_REPORTING_SAFI_FW;
grant select on CAAS_CORE_FW.PROGRAMMER to DAI_REPORTING_SAFI_FW;
grant select on CAAS_CORE_FW.PROVIDER to DAI_REPORTING_SAFI_FW;
grant select on CAAS_CORE_FW.PROVIDER_NETWORK to DAI_REPORTING_SAFI_FW;
grant select on CAAS_CORE_FW.FEED to DAI_REPORTING_SAFI_FW;
GRANT SELECT, REFERENCES ON CAAS_CORE_FW.PROGRAMMER TO DAI_REPORTING_SAFI_FW;

