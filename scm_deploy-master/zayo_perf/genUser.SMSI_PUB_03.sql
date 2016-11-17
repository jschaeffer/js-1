create user SMSI_PUB_03 identified by SMSI_PUB_03
default tablespace canoe_data
quota unlimited on canoe_data
quota unlimited on canoe_index
quota unlimited on canoe_data_compress
quota unlimited on canoe_data_compress2
/

grant TABLE_OWNER to SMSI_PUB_03;
grant CREATE SEQUENCE to SMSI_PUB_03;
