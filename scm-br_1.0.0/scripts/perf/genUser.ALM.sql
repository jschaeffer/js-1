CREATE USER ALM IDENTIFIED BY ALM;
GRANT connect, resource, create ANY SYNONYM, create view, create trigger, create any trigger, create materialized view, create any materialized view, unlimited tablespace to ALM;
