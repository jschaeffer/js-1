create user ADS_CORE_COX identified by ADS_CORE_COX                           
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant CREATE ANY MATERIALIZED VIEW to ADS_CORE_COX;                            
grant CREATE PROCEDURE to ADS_CORE_COX;                                        
grant CREATE SEQUENCE to ADS_CORE_COX;                                         
grant CREATE SESSION to ADS_CORE_COX;                                          
grant CREATE SYNONYM to ADS_CORE_COX;                                          
grant CREATE TABLE to ADS_CORE_COX;                                            
grant CREATE TRIGGER to ADS_CORE_COX;                                          
grant CREATE VIEW to ADS_CORE_COX;                                             
grant GLOBAL QUERY REWRITE to ADS_CORE_COX;                                    
grant ON COMMIT REFRESH to ADS_CORE_COX;                                       
grant SELECT ANY TABLE to ADS_CORE_COX;                                        
