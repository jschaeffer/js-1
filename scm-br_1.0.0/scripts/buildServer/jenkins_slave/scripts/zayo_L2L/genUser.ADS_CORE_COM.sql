create user ADS_CORE_COM identified by ADS_CORE_COM                         
default tablespace CANOE_DATA_COMPRESS
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant CREATE ANY MATERIALIZED VIEW to ADS_CORE_COM;                            
grant CREATE PROCEDURE to ADS_CORE_COM;                                        
grant CREATE SEQUENCE to ADS_CORE_COM;                                         
grant CREATE SESSION to ADS_CORE_COM;                                          
grant CREATE SYNONYM to ADS_CORE_COM;                                          
grant CREATE TABLE to ADS_CORE_COM;                                            
grant CREATE TRIGGER to ADS_CORE_COM;                                          
grant CREATE VIEW to ADS_CORE_COM;                                             
grant GLOBAL QUERY REWRITE to ADS_CORE_COM;                                    
grant ON COMMIT REFRESH to ADS_CORE_COM;                                       
grant SELECT ANY TABLE to ADS_CORE_COM;                                        

