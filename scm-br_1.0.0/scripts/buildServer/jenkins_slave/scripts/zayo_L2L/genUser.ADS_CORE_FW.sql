create user ADS_CORE_FW identified by FREEWHEEL                          
default tablespace canoe_data_compress                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant CREATE ANY MATERIALIZED VIEW to ADS_CORE_FW;                            
grant CREATE PROCEDURE to ADS_CORE_FW;                                        
grant CREATE SEQUENCE to ADS_CORE_FW;                                         
grant CREATE SESSION to ADS_CORE_FW;                                          
grant CREATE SYNONYM to ADS_CORE_FW;                                          
grant CREATE TABLE to ADS_CORE_FW;                                            
grant CREATE TRIGGER to ADS_CORE_FW;                                          
grant CREATE VIEW to ADS_CORE_FW;                                             
grant GLOBAL QUERY REWRITE to ADS_CORE_FW;                                    
grant ON COMMIT REFRESH to ADS_CORE_FW;                                       
grant SELECT ANY TABLE to ADS_CORE_FW;                                        

