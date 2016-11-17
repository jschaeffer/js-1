create user ADS_CORE_BRD identified by BROADWAY 
default tablespace canoe_data_compress                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant CREATE ANY MATERIALIZED VIEW to ADS_CORE_BRD;                            
grant CREATE PROCEDURE to ADS_CORE_BRD;                                        
grant CREATE SEQUENCE to ADS_CORE_BRD;                                         
grant CREATE SESSION to ADS_CORE_BRD;                                          
grant CREATE SYNONYM to ADS_CORE_BRD;                                          
grant CREATE TABLE to ADS_CORE_BRD;                                            
grant CREATE TRIGGER to ADS_CORE_BRD;                                          
grant CREATE VIEW to ADS_CORE_BRD;                                             
grant GLOBAL QUERY REWRITE to ADS_CORE_BRD;                                    
grant ON COMMIT REFRESH to ADS_CORE_BRD;                                       
grant SELECT ANY TABLE to ADS_CORE_BRD;                                        

