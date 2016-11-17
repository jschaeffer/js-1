create user TMPADS_CORE_MSO2 identified by TMPADS_CORE_MSO2                           
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
quota unlimited on canoe_data_compress2
/                                                                               
                                                                                
grant CREATE ANY MATERIALIZED VIEW to TMPADS_CORE_MSO2;                            
grant CREATE PROCEDURE to TMPADS_CORE_MSO2;                                        
grant CREATE SEQUENCE to TMPADS_CORE_MSO2;                                         
grant CREATE SESSION to TMPADS_CORE_MSO2;                                          
grant CREATE SYNONYM to TMPADS_CORE_MSO2;                                          
grant CREATE TABLE to TMPADS_CORE_MSO2;                                            
grant CREATE TRIGGER to TMPADS_CORE_MSO2;                                          
grant CREATE VIEW to TMPADS_CORE_MSO2;                                             
grant GLOBAL QUERY REWRITE to TMPADS_CORE_MSO2;                                    
grant ON COMMIT REFRESH to TMPADS_CORE_MSO2;                                       
grant SELECT ANY TABLE to TMPADS_CORE_MSO2;                                        
