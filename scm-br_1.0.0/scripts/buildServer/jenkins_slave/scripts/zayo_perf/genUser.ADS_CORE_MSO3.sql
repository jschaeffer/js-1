create user ADS_CORE_MSO3 identified by ADS_CORE_MSO3                           
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
quota unlimited on canoe_data_compress2
/                                                                               

grant TABLE_OWNER to ADS_CORE_MSO3;                                                                                
grant CREATE SEQUENCE to ADS_CORE_MSO3;
