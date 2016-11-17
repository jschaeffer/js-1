create user ADS_CORE_TWC_L identified by KODIAK                           
default tablespace canoe_data_compress                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant CREATE ANY MATERIALIZED VIEW to ADS_CORE_TWC_L;                            
grant CREATE PROCEDURE to ADS_CORE_TWC_L;                                        
grant CREATE SEQUENCE to ADS_CORE_TWC_L;                                         
grant CREATE SESSION to ADS_CORE_TWC_L;                                          
grant CREATE SYNONYM to ADS_CORE_TWC_L;                                          
grant CREATE TABLE to ADS_CORE_TWC_L;                                            
grant CREATE TRIGGER to ADS_CORE_TWC_L;                                          
grant CREATE VIEW to ADS_CORE_TWC_L;                                             
grant GLOBAL QUERY REWRITE to ADS_CORE_TWC_L;                                    
grant ON COMMIT REFRESH to ADS_CORE_TWC_L;                                       
grant SELECT ANY TABLE to ADS_CORE_TWC_L;                                        

