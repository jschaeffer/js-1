create user CAAS_LOCAL identified by KODIAK                                  
default tablespace canoe_data_compress                                              
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant ADMINISTER ANY SQL TUNING SET to CAAS_LOCAL;                               
grant ADMINISTER DATABASE TRIGGER to CAAS_LOCAL;                                 
grant ADMINISTER SQL MANAGEMENT OBJECT to CAAS_LOCAL;                            
grant ADMINISTER SQL TUNING SET to CAAS_LOCAL;                                   
grant ADVISOR to CAAS_LOCAL;                                                     
grant ALTER ANY ASSEMBLY to CAAS_LOCAL;                                          
grant ALTER ANY CLUSTER to CAAS_LOCAL;                                           
grant ALTER ANY CUBE DIMENSION to CAAS_LOCAL;                                    
grant ALTER ANY CUBE to CAAS_LOCAL;                                              
grant ALTER ANY DIMENSION to CAAS_LOCAL;                                         
grant ALTER ANY EDITION to CAAS_LOCAL;                                           
grant ALTER ANY INDEX to CAAS_LOCAL;                                             
grant ALTER ANY INDEXTYPE to CAAS_LOCAL;                                         
grant ALTER ANY LIBRARY to CAAS_LOCAL;                                           
grant ALTER ANY MATERIALIZED VIEW to CAAS_LOCAL;                                 
grant ALTER ANY MINING MODEL to CAAS_LOCAL;                                      
grant ALTER ANY OPERATOR to CAAS_LOCAL;                                          
grant ALTER ANY OUTLINE to CAAS_LOCAL;                                           
grant ALTER ANY PROCEDURE to CAAS_LOCAL;                                         
grant ALTER ANY ROLE to CAAS_LOCAL;                                              
grant ALTER ANY SEQUENCE to CAAS_LOCAL;                                          
grant ALTER ANY SQL PROFILE to CAAS_LOCAL;                                       
grant ALTER ANY TABLE to CAAS_LOCAL;                                             
grant ALTER ANY TRIGGER to CAAS_LOCAL;                                           
grant ALTER ANY TYPE to CAAS_LOCAL;                                              
grant ALTER DATABASE LINK to CAAS_LOCAL;                                         
grant ALTER DATABASE to CAAS_LOCAL;                                              
grant ALTER PROFILE to CAAS_LOCAL;                                               
grant ALTER PUBLIC DATABASE LINK to CAAS_LOCAL;                                  
grant ALTER RESOURCE COST to CAAS_LOCAL;                                         
grant ALTER ROLLBACK SEGMENT to CAAS_LOCAL;                                      
grant ALTER SESSION to CAAS_LOCAL;                                               
grant ALTER SYSTEM to CAAS_LOCAL;                                                
grant ALTER TABLESPACE to CAAS_LOCAL;                                            
grant ALTER USER to CAAS_LOCAL;                                                  
grant ANALYZE ANY DICTIONARY to CAAS_LOCAL;                                      
grant ANALYZE ANY to CAAS_LOCAL;                                                 
grant AUDIT ANY to CAAS_LOCAL;                                                   
grant AUDIT SYSTEM to CAAS_LOCAL;                                                
grant BACKUP ANY TABLE to CAAS_LOCAL;                                            
grant BECOME USER to CAAS_LOCAL;                                                 
grant CHANGE NOTIFICATION to CAAS_LOCAL;                                         
grant COMMENT ANY MINING MODEL to CAAS_LOCAL;                                    
grant COMMENT ANY TABLE to CAAS_LOCAL;                                           
grant CREATE ANY ASSEMBLY to CAAS_LOCAL;                                         
grant CREATE ANY CLUSTER to CAAS_LOCAL;                                          
grant CREATE ANY CONTEXT to CAAS_LOCAL;                                          
grant CREATE ANY CUBE BUILD PROCESS to CAAS_LOCAL;                               
grant CREATE ANY CUBE DIMENSION to CAAS_LOCAL;                                   
grant CREATE ANY CUBE to CAAS_LOCAL;                                             
grant CREATE ANY DIMENSION to CAAS_LOCAL;                                        
grant CREATE ANY DIRECTORY to CAAS_LOCAL;                                        
grant CREATE ANY EDITION to CAAS_LOCAL;                                          
grant CREATE ANY INDEX to CAAS_LOCAL;                                            
grant CREATE ANY INDEXTYPE to CAAS_LOCAL;                                        
grant CREATE ANY JOB to CAAS_LOCAL;                                              
grant CREATE ANY LIBRARY to CAAS_LOCAL;                                          
grant CREATE ANY MATERIALIZED VIEW to CAAS_LOCAL;                                
grant CREATE ANY MEASURE FOLDER to CAAS_LOCAL;                                   
grant CREATE ANY MINING MODEL to CAAS_LOCAL;                                     
grant CREATE ANY OPERATOR to CAAS_LOCAL;                                         
grant CREATE ANY OUTLINE to CAAS_LOCAL;                                          
grant CREATE ANY PROCEDURE to CAAS_LOCAL;                                        
grant CREATE ANY SEQUENCE to CAAS_LOCAL;                                         
grant CREATE ANY SQL PROFILE to CAAS_LOCAL;                                      
grant CREATE ANY SYNONYM to CAAS_LOCAL;                                          
grant CREATE ANY TABLE to CAAS_LOCAL;                                            
grant CREATE ANY TRIGGER to CAAS_LOCAL;                                          
grant CREATE ANY TYPE to CAAS_LOCAL;                                             
grant CREATE ANY VIEW to CAAS_LOCAL;                                             
grant CREATE ASSEMBLY to CAAS_LOCAL;                                             
grant CREATE CLUSTER to CAAS_LOCAL;                                              
grant CREATE CUBE BUILD PROCESS to CAAS_LOCAL;                                   
grant CREATE CUBE DIMENSION to CAAS_LOCAL;                                       
grant CREATE CUBE to CAAS_LOCAL;                                                 
grant CREATE DATABASE LINK to CAAS_LOCAL;                                        
grant CREATE DIMENSION to CAAS_LOCAL;                                            
grant CREATE EXTERNAL JOB to CAAS_LOCAL;                                         
grant CREATE INDEXTYPE to CAAS_LOCAL;                                            
grant CREATE JOB to CAAS_LOCAL;                                                  
grant CREATE LIBRARY to CAAS_LOCAL;                                              
grant CREATE MATERIALIZED VIEW to CAAS_LOCAL;                                    
grant CREATE MEASURE FOLDER to CAAS_LOCAL;                                       
grant CREATE MINING MODEL to CAAS_LOCAL;                                         
grant CREATE OPERATOR to CAAS_LOCAL;                                             
grant CREATE PROCEDURE to CAAS_LOCAL;                                            
grant CREATE PROFILE to CAAS_LOCAL;                                              
grant CREATE PUBLIC DATABASE LINK to CAAS_LOCAL;                                 
grant CREATE PUBLIC SYNONYM to CAAS_LOCAL;                                       
grant CREATE ROLE to CAAS_LOCAL;                                                 
grant CREATE ROLLBACK SEGMENT to CAAS_LOCAL;                                     
grant CREATE SEQUENCE to CAAS_LOCAL;                                             
grant CREATE SESSION to CAAS_LOCAL;                                              
grant CREATE SYNONYM to CAAS_LOCAL;                                              
grant CREATE TABLE to CAAS_LOCAL;                                                
grant CREATE TABLESPACE to CAAS_LOCAL;                                           
grant CREATE TRIGGER to CAAS_LOCAL;                                              
grant CREATE TYPE to CAAS_LOCAL;                                                 
grant CREATE USER to CAAS_LOCAL;                                                 
grant CREATE VIEW to CAAS_LOCAL;                                                 
grant DEBUG ANY PROCEDURE to CAAS_LOCAL;                                         
grant DEBUG CONNECT SESSION to CAAS_LOCAL;                                       
grant DELETE ANY CUBE DIMENSION to CAAS_LOCAL;                                   
grant DELETE ANY MEASURE FOLDER to CAAS_LOCAL;                                   
grant DELETE ANY TABLE to CAAS_LOCAL;                                            
grant DROP ANY ASSEMBLY to CAAS_LOCAL;                                           
grant DROP ANY CLUSTER to CAAS_LOCAL;                                            
grant DROP ANY CONTEXT to CAAS_LOCAL;                                            
grant DROP ANY CUBE BUILD PROCESS to CAAS_LOCAL;                                 
grant DROP ANY CUBE DIMENSION to CAAS_LOCAL;                                     
grant DROP ANY CUBE to CAAS_LOCAL;                                               
grant DROP ANY DIMENSION to CAAS_LOCAL;                                          
grant DROP ANY DIRECTORY to CAAS_LOCAL;                                          
grant DROP ANY EDITION to CAAS_LOCAL;                                            
grant DROP ANY INDEX to CAAS_LOCAL;                                              
grant DROP ANY INDEXTYPE to CAAS_LOCAL;                                          
grant DROP ANY LIBRARY to CAAS_LOCAL;                                            
grant DROP ANY MATERIALIZED VIEW to CAAS_LOCAL;                                  
grant DROP ANY MEASURE FOLDER to CAAS_LOCAL;                                     
grant DROP ANY MINING MODEL to CAAS_LOCAL;                                       
grant DROP ANY OPERATOR to CAAS_LOCAL;                                           
grant DROP ANY OUTLINE to CAAS_LOCAL;                                            
grant DROP ANY PROCEDURE to CAAS_LOCAL;                                          
grant DROP ANY ROLE to CAAS_LOCAL;                                               
grant DROP ANY SEQUENCE to CAAS_LOCAL;                                           
grant DROP ANY SQL PROFILE to CAAS_LOCAL;                                        
grant DROP ANY SYNONYM to CAAS_LOCAL;                                            
grant DROP ANY TABLE to CAAS_LOCAL;                                              
grant DROP ANY TRIGGER to CAAS_LOCAL;                                            
grant DROP ANY TYPE to CAAS_LOCAL;                                               
grant DROP ANY VIEW to CAAS_LOCAL;                                               
grant DROP PROFILE to CAAS_LOCAL;                                                
grant DROP PUBLIC DATABASE LINK to CAAS_LOCAL;                                   
grant DROP PUBLIC SYNONYM to CAAS_LOCAL;                                         
grant DROP ROLLBACK SEGMENT to CAAS_LOCAL;                                       
grant DROP TABLESPACE to CAAS_LOCAL;                                             
grant DROP USER to CAAS_LOCAL;                                                   
grant EXECUTE ANY ASSEMBLY to CAAS_LOCAL;                                        
grant EXECUTE ANY CLASS to CAAS_LOCAL;                                           
grant EXECUTE ANY INDEXTYPE to CAAS_LOCAL;                                       
grant EXECUTE ANY LIBRARY to CAAS_LOCAL;                                         
grant EXECUTE ANY OPERATOR to CAAS_LOCAL;                                        
grant EXECUTE ANY PROCEDURE to CAAS_LOCAL;                                       
grant EXECUTE ANY PROGRAM to CAAS_LOCAL;                                         
grant EXECUTE ANY TYPE to CAAS_LOCAL;                                            
grant EXECUTE ASSEMBLY to CAAS_LOCAL;                                            
grant EXEMPT ACCESS POLICY to CAAS_LOCAL;                                        
grant EXEMPT IDENTITY POLICY to CAAS_LOCAL;                                      
grant EXPORT FULL DATABASE to CAAS_LOCAL;                                        
grant FLASHBACK ANY TABLE to CAAS_LOCAL;                                         
grant FLASHBACK ARCHIVE ADMINISTER to CAAS_LOCAL;                                
grant FORCE ANY TRANSACTION to CAAS_LOCAL;                                       
grant FORCE TRANSACTION to CAAS_LOCAL;                                           
grant GLOBAL QUERY REWRITE to CAAS_LOCAL;                                        
grant GRANT ANY OBJECT PRIVILEGE to CAAS_LOCAL;                                  
grant GRANT ANY PRIVILEGE to CAAS_LOCAL;                                         
grant GRANT ANY ROLE to CAAS_LOCAL;                                              
grant IMPORT FULL DATABASE to CAAS_LOCAL;                                        
grant INSERT ANY CUBE DIMENSION to CAAS_LOCAL;                                   
grant INSERT ANY MEASURE FOLDER to CAAS_LOCAL;                                   
grant INSERT ANY TABLE to CAAS_LOCAL;                                            
grant LOCK ANY TABLE to CAAS_LOCAL;                                              
grant MANAGE SCHEDULER to CAAS_LOCAL;                                            
grant MANAGE TABLESPACE to CAAS_LOCAL;                                           
grant MERGE ANY VIEW to CAAS_LOCAL;                                              
grant ON COMMIT REFRESH to CAAS_LOCAL;                                           
grant QUERY REWRITE to CAAS_LOCAL;                                               
grant RESTRICTED SESSION to CAAS_LOCAL;                                          
grant RESUMABLE to CAAS_LOCAL;                                                   
grant SELECT ANY CUBE DIMENSION to CAAS_LOCAL;                                   
grant SELECT ANY CUBE to CAAS_LOCAL;                                             
grant SELECT ANY DICTIONARY to CAAS_LOCAL;                                       
grant SELECT ANY MINING MODEL to CAAS_LOCAL;                                     
grant SELECT ANY SEQUENCE to CAAS_LOCAL;                                         
grant SELECT ANY TABLE to CAAS_LOCAL;                                            
grant SELECT ANY TRANSACTION to CAAS_LOCAL;                                      
grant UNDER ANY TABLE to CAAS_LOCAL;                                             
grant UNDER ANY TYPE to CAAS_LOCAL;                                              
grant UNDER ANY VIEW to CAAS_LOCAL;                                              
grant UPDATE ANY CUBE BUILD PROCESS to CAAS_LOCAL;                               
grant UPDATE ANY CUBE DIMENSION to CAAS_LOCAL;                                   
grant UPDATE ANY CUBE to CAAS_LOCAL;                                             
grant UPDATE ANY TABLE to CAAS_LOCAL;                                            
CREATE FLASHBACK ARCHIVE audit_campaign TABLESPACE canoe_audit QUOTA 2G RETENTION 24 MONTH;
CREATE FLASHBACK ARCHIVE audit_media_asset TABLESPACE canoe_audit QUOTA 2G RETENTION 24 MONTH;
GRANT FLASHBACK ARCHIVE ON audit_campaign TO CAAS40;
GRANT FLASHBACK ARCHIVE ON audit_media_asset TO CAAS40;
GRANT FLASHBACK ARCHIVE ON audit_campaign TO CAAS_LOCAL;
GRANT FLASHBACK ARCHIVE ON audit_media_asset TO CAAS_LOCAL;
GRANT FLASHBACK ARCHIVE ON audit_campaign TO CAAS_CORE_FW;
GRANT FLASHBACK ARCHIVE ON audit_media_asset TO CAAS_CORE_FW;
GRANT FLASHBACK ARCHIVE ON audit_campaign TO CAAS_CORE_BRD;
GRANT FLASHBACK ARCHIVE ON audit_media_asset TO CAAS_CORE_BRD;
