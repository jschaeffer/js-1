CREATE USER ADI_MDI_01 IDENTIFIED BY ADI_MDI_01
      DEFAULT TABLESPACE "CANOE_DATA_COMPRESS"
      TEMPORARY TABLESPACE "TEMP";
GRANT connect, resource, create ANY SYNONYM, create view, create trigger, create any trigger, create materialized view, create any materialized view, unlimited tablespace to ADI_MDI_01;
