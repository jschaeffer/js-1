create user ADS_CORE_RTK identified by ADS_CORE_RTK
default tablespace canoe_data_compress                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant CREATE ANY MATERIALIZED VIEW to ADS_CORE_RTK;                            
grant CREATE PROCEDURE to ADS_CORE_RTK;                                        
grant CREATE SEQUENCE to ADS_CORE_RTK;                                         
grant CREATE SESSION to ADS_CORE_RTK;                                          
grant CREATE SYNONYM to ADS_CORE_RTK;                                          
grant CREATE TABLE to ADS_CORE_RTK;                                            
grant CREATE TRIGGER to ADS_CORE_RTK;                                          
grant CREATE VIEW to ADS_CORE_RTK;                                             
grant GLOBAL QUERY REWRITE to ADS_CORE_RTK;                                    
grant ON COMMIT REFRESH to ADS_CORE_RTK;                                       
grant SELECT ANY TABLE to ADS_CORE_RTK;                                        

