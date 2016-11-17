create user ADS_CORE_TWC identified by ADS_CORE_TWC                          
default tablespace CANOE_DATA_COMPRESS
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant CREATE ANY MATERIALIZED VIEW to ADS_CORE_TWC;                            
grant CREATE PROCEDURE to ADS_CORE_TWC;                                        
grant CREATE SEQUENCE to ADS_CORE_TWC;                                         
grant CREATE SESSION to ADS_CORE_TWC;                                          
grant CREATE SYNONYM to ADS_CORE_TWC;                                          
grant CREATE TABLE to ADS_CORE_TWC;                                            
grant CREATE TRIGGER to ADS_CORE_TWC;                                          
grant CREATE VIEW to ADS_CORE_TWC;                                             
grant GLOBAL QUERY REWRITE to ADS_CORE_TWC;                                    
grant ON COMMIT REFRESH to ADS_CORE_TWC;                                       
grant SELECT ANY TABLE to ADS_CORE_TWC;                                        

