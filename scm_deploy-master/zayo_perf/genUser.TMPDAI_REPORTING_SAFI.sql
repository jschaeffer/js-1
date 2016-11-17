create user TMPDAI_REPORTING_SAFI identified by TMPDAI_REPORTING_SAFI
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
        to TMPDAI_REPORTING_SAFI;

prompt "Base grants complete"

grant select on TMPCAAS_CORE.CAMPAIGN to TMPDAI_REPORTING_SAFI;
grant select on TMPCAAS_CORE.CAMPAIGN_ITEM to TMPDAI_REPORTING_SAFI;
grant select on TMPCAAS_CORE.CAMPAIGN_ITEM_MEDIA_ASSET to TMPDAI_REPORTING_SAFI;
grant select on TMPCAAS_CORE.CAMPAIGN_ITEM_DISCOUNT to TMPDAI_REPORTING_SAFI;
grant select on TMPCAAS_CORE.MEDIA_ASSET to TMPDAI_REPORTING_SAFI;
grant select on TMPCAAS_CORE.MEDIA_ASSET_METADATA_VALUE to TMPDAI_REPORTING_SAFI;
grant select on TMPCAAS_CORE.NETWORK to TMPDAI_REPORTING_SAFI;
grant select on TMPCAAS_CORE.OPERATOR to TMPDAI_REPORTING_SAFI;
grant select on TMPCAAS_CORE.PROGRAMMER to TMPDAI_REPORTING_SAFI;
grant select on TMPCAAS_CORE.PROVIDER to TMPDAI_REPORTING_SAFI;
grant select on TMPCAAS_CORE.PROVIDER_NETWORK to TMPDAI_REPORTING_SAFI;
grant select on TMPCAAS_CORE.FEED to TMPDAI_REPORTING_SAFI;
GRANT SELECT, REFERENCES ON TMPCAAS_CORE.PROGRAMMER TO TMPDAI_REPORTING_SAFI;

