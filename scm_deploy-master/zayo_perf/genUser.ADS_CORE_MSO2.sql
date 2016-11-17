create user ADS_CORE_MSO2 identified by ADS_CORE_MSO2                           
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
quota unlimited on canoe_data_compress2
/                                                                               
                                                                                
grant CREATE ANY MATERIALIZED VIEW to ADS_CORE_MSO2;                            
grant CREATE PROCEDURE to ADS_CORE_MSO2;                                        
grant CREATE SEQUENCE to ADS_CORE_MSO2;                                         
grant CREATE SESSION to ADS_CORE_MSO2;                                          
grant CREATE SYNONYM to ADS_CORE_MSO2;                                          
grant CREATE TABLE to ADS_CORE_MSO2;                                            
grant CREATE TRIGGER to ADS_CORE_MSO2;                                          
grant CREATE VIEW to ADS_CORE_MSO2;                                             
grant GLOBAL QUERY REWRITE to ADS_CORE_MSO2;                                    
grant ON COMMIT REFRESH to ADS_CORE_MSO2;                                       
grant SELECT ANY TABLE to ADS_CORE_MSO2;                                        
