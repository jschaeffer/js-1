SQL> @unload_user.sql
create user ADS_CORE_MSO1 identified by ADS_CORE_MSO1                           
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant CREATE ANY MATERIALIZED VIEW to ADS_CORE_MSO1;                            
grant CREATE PROCEDURE to ADS_CORE_MSO1;                                        
grant CREATE SEQUENCE to ADS_CORE_MSO1;                                         
grant CREATE SESSION to ADS_CORE_MSO1;                                          
grant CREATE SYNONYM to ADS_CORE_MSO1;                                          
grant CREATE TABLE to ADS_CORE_MSO1;                                            
grant CREATE TRIGGER to ADS_CORE_MSO1;                                          
grant CREATE VIEW to ADS_CORE_MSO1;                                             
grant GLOBAL QUERY REWRITE to ADS_CORE_MSO1;                                    
grant ON COMMIT REFRESH to ADS_CORE_MSO1;                                       
grant SELECT ANY TABLE to ADS_CORE_MSO1;                                        
create user ADS_CORE_MSO2 identified by ADS_CORE_MSO2                           
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
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
create user ARISANT identified by ARISANT                                       
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
create user CAAS_CORE identified by CAAS_CORE                                   
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant ADMINISTER ANY SQL TUNING SET to CAAS_CORE;                               
grant ADMINISTER DATABASE TRIGGER to CAAS_CORE;                                 
grant ADMINISTER SQL MANAGEMENT OBJECT to CAAS_CORE;                            
grant ADMINISTER SQL TUNING SET to CAAS_CORE;                                   
grant ADVISOR to CAAS_CORE;                                                     
grant ALTER ANY ASSEMBLY to CAAS_CORE;                                          
grant ALTER ANY CLUSTER to CAAS_CORE;                                           
grant ALTER ANY CUBE DIMENSION to CAAS_CORE;                                    
grant ALTER ANY CUBE to CAAS_CORE;                                              
grant ALTER ANY DIMENSION to CAAS_CORE;                                         
grant ALTER ANY EDITION to CAAS_CORE;                                           
grant ALTER ANY INDEX to CAAS_CORE;                                             
grant ALTER ANY INDEXTYPE to CAAS_CORE;                                         
grant ALTER ANY LIBRARY to CAAS_CORE;                                           
grant ALTER ANY MATERIALIZED VIEW to CAAS_CORE;                                 
grant ALTER ANY MINING MODEL to CAAS_CORE;                                      
grant ALTER ANY OPERATOR to CAAS_CORE;                                          
grant ALTER ANY OUTLINE to CAAS_CORE;                                           
grant ALTER ANY PROCEDURE to CAAS_CORE;                                         
grant ALTER ANY ROLE to CAAS_CORE;                                              
grant ALTER ANY SEQUENCE to CAAS_CORE;                                          
grant ALTER ANY SQL PROFILE to CAAS_CORE;                                       
grant ALTER ANY TABLE to CAAS_CORE;                                             
grant ALTER ANY TRIGGER to CAAS_CORE;                                           
grant ALTER ANY TYPE to CAAS_CORE;                                              
grant ALTER DATABASE LINK to CAAS_CORE;                                         
grant ALTER DATABASE to CAAS_CORE;                                              
grant ALTER PROFILE to CAAS_CORE;                                               
grant ALTER PUBLIC DATABASE LINK to CAAS_CORE;                                  
grant ALTER RESOURCE COST to CAAS_CORE;                                         
grant ALTER ROLLBACK SEGMENT to CAAS_CORE;                                      
grant ALTER SESSION to CAAS_CORE;                                               
grant ALTER SYSTEM to CAAS_CORE;                                                
grant ALTER TABLESPACE to CAAS_CORE;                                            
grant ALTER USER to CAAS_CORE;                                                  
grant ANALYZE ANY DICTIONARY to CAAS_CORE;                                      
grant ANALYZE ANY to CAAS_CORE;                                                 
grant AUDIT ANY to CAAS_CORE;                                                   
grant AUDIT SYSTEM to CAAS_CORE;                                                
grant BACKUP ANY TABLE to CAAS_CORE;                                            
grant BECOME USER to CAAS_CORE;                                                 
grant CHANGE NOTIFICATION to CAAS_CORE;                                         
grant COMMENT ANY MINING MODEL to CAAS_CORE;                                    
grant COMMENT ANY TABLE to CAAS_CORE;                                           
grant CREATE ANY ASSEMBLY to CAAS_CORE;                                         
grant CREATE ANY CLUSTER to CAAS_CORE;                                          
grant CREATE ANY CONTEXT to CAAS_CORE;                                          
grant CREATE ANY CUBE BUILD PROCESS to CAAS_CORE;                               
grant CREATE ANY CUBE DIMENSION to CAAS_CORE;                                   
grant CREATE ANY CUBE to CAAS_CORE;                                             
grant CREATE ANY DIMENSION to CAAS_CORE;                                        
grant CREATE ANY DIRECTORY to CAAS_CORE;                                        
grant CREATE ANY EDITION to CAAS_CORE;                                          
grant CREATE ANY INDEX to CAAS_CORE;                                            
grant CREATE ANY INDEXTYPE to CAAS_CORE;                                        
grant CREATE ANY JOB to CAAS_CORE;                                              
grant CREATE ANY LIBRARY to CAAS_CORE;                                          
grant CREATE ANY MATERIALIZED VIEW to CAAS_CORE;                                
grant CREATE ANY MEASURE FOLDER to CAAS_CORE;                                   
grant CREATE ANY MINING MODEL to CAAS_CORE;                                     
grant CREATE ANY OPERATOR to CAAS_CORE;                                         
grant CREATE ANY OUTLINE to CAAS_CORE;                                          
grant CREATE ANY PROCEDURE to CAAS_CORE;                                        
grant CREATE ANY SEQUENCE to CAAS_CORE;                                         
grant CREATE ANY SQL PROFILE to CAAS_CORE;                                      
grant CREATE ANY SYNONYM to CAAS_CORE;                                          
grant CREATE ANY TABLE to CAAS_CORE;                                            
grant CREATE ANY TRIGGER to CAAS_CORE;                                          
grant CREATE ANY TYPE to CAAS_CORE;                                             
grant CREATE ANY VIEW to CAAS_CORE;                                             
grant CREATE ASSEMBLY to CAAS_CORE;                                             
grant CREATE CLUSTER to CAAS_CORE;                                              
grant CREATE CUBE BUILD PROCESS to CAAS_CORE;                                   
grant CREATE CUBE DIMENSION to CAAS_CORE;                                       
grant CREATE CUBE to CAAS_CORE;                                                 
grant CREATE DATABASE LINK to CAAS_CORE;                                        
grant CREATE DIMENSION to CAAS_CORE;                                            
grant CREATE EXTERNAL JOB to CAAS_CORE;                                         
grant CREATE INDEXTYPE to CAAS_CORE;                                            
grant CREATE JOB to CAAS_CORE;                                                  
grant CREATE LIBRARY to CAAS_CORE;                                              
grant CREATE MATERIALIZED VIEW to CAAS_CORE;                                    
grant CREATE MEASURE FOLDER to CAAS_CORE;                                       
grant CREATE MINING MODEL to CAAS_CORE;                                         
grant CREATE OPERATOR to CAAS_CORE;                                             
grant CREATE PROCEDURE to CAAS_CORE;                                            
grant CREATE PROFILE to CAAS_CORE;                                              
grant CREATE PUBLIC DATABASE LINK to CAAS_CORE;                                 
grant CREATE PUBLIC SYNONYM to CAAS_CORE;                                       
grant CREATE ROLE to CAAS_CORE;                                                 
grant CREATE ROLLBACK SEGMENT to CAAS_CORE;                                     
grant CREATE SEQUENCE to CAAS_CORE;                                             
grant CREATE SESSION to CAAS_CORE;                                              
grant CREATE SYNONYM to CAAS_CORE;                                              
grant CREATE TABLE to CAAS_CORE;                                                
grant CREATE TABLESPACE to CAAS_CORE;                                           
grant CREATE TRIGGER to CAAS_CORE;                                              
grant CREATE TYPE to CAAS_CORE;                                                 
grant CREATE USER to CAAS_CORE;                                                 
grant CREATE VIEW to CAAS_CORE;                                                 
grant DEBUG ANY PROCEDURE to CAAS_CORE;                                         
grant DEBUG CONNECT SESSION to CAAS_CORE;                                       
grant DELETE ANY CUBE DIMENSION to CAAS_CORE;                                   
grant DELETE ANY MEASURE FOLDER to CAAS_CORE;                                   
grant DELETE ANY TABLE to CAAS_CORE;                                            
grant DROP ANY ASSEMBLY to CAAS_CORE;                                           
grant DROP ANY CLUSTER to CAAS_CORE;                                            
grant DROP ANY CONTEXT to CAAS_CORE;                                            
grant DROP ANY CUBE BUILD PROCESS to CAAS_CORE;                                 
grant DROP ANY CUBE DIMENSION to CAAS_CORE;                                     
grant DROP ANY CUBE to CAAS_CORE;                                               
grant DROP ANY DIMENSION to CAAS_CORE;                                          
grant DROP ANY DIRECTORY to CAAS_CORE;                                          
grant DROP ANY EDITION to CAAS_CORE;                                            
grant DROP ANY INDEX to CAAS_CORE;                                              
grant DROP ANY INDEXTYPE to CAAS_CORE;                                          
grant DROP ANY LIBRARY to CAAS_CORE;                                            
grant DROP ANY MATERIALIZED VIEW to CAAS_CORE;                                  
grant DROP ANY MEASURE FOLDER to CAAS_CORE;                                     
grant DROP ANY MINING MODEL to CAAS_CORE;                                       
grant DROP ANY OPERATOR to CAAS_CORE;                                           
grant DROP ANY OUTLINE to CAAS_CORE;                                            
grant DROP ANY PROCEDURE to CAAS_CORE;                                          
grant DROP ANY ROLE to CAAS_CORE;                                               
grant DROP ANY SEQUENCE to CAAS_CORE;                                           
grant DROP ANY SQL PROFILE to CAAS_CORE;                                        
grant DROP ANY SYNONYM to CAAS_CORE;                                            
grant DROP ANY TABLE to CAAS_CORE;                                              
grant DROP ANY TRIGGER to CAAS_CORE;                                            
grant DROP ANY TYPE to CAAS_CORE;                                               
grant DROP ANY VIEW to CAAS_CORE;                                               
grant DROP PROFILE to CAAS_CORE;                                                
grant DROP PUBLIC DATABASE LINK to CAAS_CORE;                                   
grant DROP PUBLIC SYNONYM to CAAS_CORE;                                         
grant DROP ROLLBACK SEGMENT to CAAS_CORE;                                       
grant DROP TABLESPACE to CAAS_CORE;                                             
grant DROP USER to CAAS_CORE;                                                   
grant EXECUTE ANY ASSEMBLY to CAAS_CORE;                                        
grant EXECUTE ANY CLASS to CAAS_CORE;                                           
grant EXECUTE ANY INDEXTYPE to CAAS_CORE;                                       
grant EXECUTE ANY LIBRARY to CAAS_CORE;                                         
grant EXECUTE ANY OPERATOR to CAAS_CORE;                                        
grant EXECUTE ANY PROCEDURE to CAAS_CORE;                                       
grant EXECUTE ANY PROGRAM to CAAS_CORE;                                         
grant EXECUTE ANY TYPE to CAAS_CORE;                                            
grant EXECUTE ASSEMBLY to CAAS_CORE;                                            
grant EXEMPT ACCESS POLICY to CAAS_CORE;                                        
grant EXEMPT IDENTITY POLICY to CAAS_CORE;                                      
grant EXPORT FULL DATABASE to CAAS_CORE;                                        
grant FLASHBACK ANY TABLE to CAAS_CORE;                                         
grant FLASHBACK ARCHIVE ADMINISTER to CAAS_CORE;                                
grant FORCE ANY TRANSACTION to CAAS_CORE;                                       
grant FORCE TRANSACTION to CAAS_CORE;                                           
grant GLOBAL QUERY REWRITE to CAAS_CORE;                                        
grant GRANT ANY OBJECT PRIVILEGE to CAAS_CORE;                                  
grant GRANT ANY PRIVILEGE to CAAS_CORE;                                         
grant GRANT ANY ROLE to CAAS_CORE;                                              
grant IMPORT FULL DATABASE to CAAS_CORE;                                        
grant INSERT ANY CUBE DIMENSION to CAAS_CORE;                                   
grant INSERT ANY MEASURE FOLDER to CAAS_CORE;                                   
grant INSERT ANY TABLE to CAAS_CORE;                                            
grant LOCK ANY TABLE to CAAS_CORE;                                              
grant MANAGE SCHEDULER to CAAS_CORE;                                            
grant MANAGE TABLESPACE to CAAS_CORE;                                           
grant MERGE ANY VIEW to CAAS_CORE;                                              
grant ON COMMIT REFRESH to CAAS_CORE;                                           
grant QUERY REWRITE to CAAS_CORE;                                               
grant RESTRICTED SESSION to CAAS_CORE;                                          
grant RESUMABLE to CAAS_CORE;                                                   
grant SELECT ANY CUBE DIMENSION to CAAS_CORE;                                   
grant SELECT ANY CUBE to CAAS_CORE;                                             
grant SELECT ANY DICTIONARY to CAAS_CORE;                                       
grant SELECT ANY MINING MODEL to CAAS_CORE;                                     
grant SELECT ANY SEQUENCE to CAAS_CORE;                                         
grant SELECT ANY TABLE to CAAS_CORE;                                            
grant SELECT ANY TRANSACTION to CAAS_CORE;                                      
grant UNDER ANY TABLE to CAAS_CORE;                                             
grant UNDER ANY TYPE to CAAS_CORE;                                              
grant UNDER ANY VIEW to CAAS_CORE;                                              
grant UPDATE ANY CUBE BUILD PROCESS to CAAS_CORE;                               
grant UPDATE ANY CUBE DIMENSION to CAAS_CORE;                                   
grant UPDATE ANY CUBE to CAAS_CORE;                                             
grant UPDATE ANY TABLE to CAAS_CORE;                                            
create user CAAS_CORE_CDL identified by CAAS_CORE_CDL                           
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
create user DAI_BILLING identified by DAI_BILLING                               
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant CREATE PROCEDURE to DAI_BILLING;                                          
grant CREATE SEQUENCE to DAI_BILLING;                                           
grant CREATE SESSION to DAI_BILLING;                                            
grant CREATE SYNONYM to DAI_BILLING;                                            
grant CREATE TABLE to DAI_BILLING;                                              
grant CREATE TRIGGER to DAI_BILLING;                                            
grant CREATE VIEW to DAI_BILLING;                                               

create user DAI_REPORTING_ODS identified by DAI_REPORTING_ODS                   
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant ALTER ANY CUBE DIMENSION to DAI_REPORTING_ODS;                            
grant ALTER ANY CUBE to DAI_REPORTING_ODS;                                      
grant ALTER ANY DIMENSION to DAI_REPORTING_ODS;                                 
grant ALTER ANY MATERIALIZED VIEW to DAI_REPORTING_ODS;                         
grant ANALYZE ANY DICTIONARY to DAI_REPORTING_ODS;                              
grant ANALYZE ANY to DAI_REPORTING_ODS;                                         
grant BECOME USER to DAI_REPORTING_ODS;                                         
grant COMMENT ANY TABLE to DAI_REPORTING_ODS;                                   
grant CREATE ANY CONTEXT to DAI_REPORTING_ODS;                                  
grant CREATE ANY CUBE BUILD PROCESS to DAI_REPORTING_ODS;                       
grant CREATE ANY CUBE DIMENSION to DAI_REPORTING_ODS;                           
grant CREATE ANY CUBE to DAI_REPORTING_ODS;                                     
grant CREATE ANY DIMENSION to DAI_REPORTING_ODS;                                
grant CREATE ANY INDEX to DAI_REPORTING_ODS;                                    
grant CREATE ANY INDEXTYPE to DAI_REPORTING_ODS;                                
grant CREATE ANY JOB to DAI_REPORTING_ODS;                                      
grant CREATE ANY MATERIALIZED VIEW to DAI_REPORTING_ODS;                        
grant CREATE ANY MEASURE FOLDER to DAI_REPORTING_ODS;                           
grant CREATE ANY MINING MODEL to DAI_REPORTING_ODS;                             
grant CREATE ANY OPERATOR to DAI_REPORTING_ODS;                                 
grant CREATE ANY PROCEDURE to DAI_REPORTING_ODS;                                
grant CREATE ANY RULE SET to DAI_REPORTING_ODS;                                 
grant CREATE ANY RULE to DAI_REPORTING_ODS;                                     
grant CREATE ANY SEQUENCE to DAI_REPORTING_ODS;                                 
grant CREATE ANY SQL PROFILE to DAI_REPORTING_ODS;                              
grant CREATE ANY SYNONYM to DAI_REPORTING_ODS;                                  
grant CREATE ANY TABLE to DAI_REPORTING_ODS;                                    
grant CREATE ANY TRIGGER to DAI_REPORTING_ODS;                                  
grant CREATE ANY TYPE to DAI_REPORTING_ODS;                                     
grant CREATE ANY VIEW to DAI_REPORTING_ODS;                                     
grant CREATE ASSEMBLY to DAI_REPORTING_ODS;                                     
grant CREATE CUBE BUILD PROCESS to DAI_REPORTING_ODS;                           
grant CREATE CUBE DIMENSION to DAI_REPORTING_ODS;                               
grant CREATE CUBE to DAI_REPORTING_ODS;                                         
grant CREATE INDEXTYPE to DAI_REPORTING_ODS;                                    
grant CREATE JOB to DAI_REPORTING_ODS;                                          
grant CREATE MATERIALIZED VIEW to DAI_REPORTING_ODS;                            
grant CREATE MEASURE FOLDER to DAI_REPORTING_ODS;                               
grant CREATE PROCEDURE to DAI_REPORTING_ODS;                                    
grant CREATE PUBLIC SYNONYM to DAI_REPORTING_ODS;                               
grant CREATE RULE SET to DAI_REPORTING_ODS;                                     
grant CREATE RULE to DAI_REPORTING_ODS;                                         
grant CREATE SEQUENCE to DAI_REPORTING_ODS;                                     
grant CREATE SESSION to DAI_REPORTING_ODS;                                      
grant CREATE SYNONYM to DAI_REPORTING_ODS;                                      
grant CREATE TABLE to DAI_REPORTING_ODS;                                        
grant CREATE TRIGGER to DAI_REPORTING_ODS;                                      
grant CREATE TYPE to DAI_REPORTING_ODS;                                         
grant CREATE VIEW to DAI_REPORTING_ODS;                                         
grant DEBUG ANY PROCEDURE to DAI_REPORTING_ODS;                                 
grant DEBUG CONNECT SESSION to DAI_REPORTING_ODS;                               
grant DELETE ANY TABLE to DAI_REPORTING_ODS;                                    
grant DROP ANY MATERIALIZED VIEW to DAI_REPORTING_ODS;                          
grant DROP ANY TABLE to DAI_REPORTING_ODS;                                      
grant ENQUEUE ANY QUEUE to DAI_REPORTING_ODS;                                   
grant EXECUTE ANY ASSEMBLY to DAI_REPORTING_ODS;                                
grant EXECUTE ANY CLASS to DAI_REPORTING_ODS;                                   
grant EXECUTE ANY EVALUATION CONTEXT to DAI_REPORTING_ODS;                      
grant EXECUTE ANY INDEXTYPE to DAI_REPORTING_ODS;                               
grant EXECUTE ANY LIBRARY to DAI_REPORTING_ODS;                                 
grant EXECUTE ANY OPERATOR to DAI_REPORTING_ODS;                                
grant EXECUTE ANY PROCEDURE to DAI_REPORTING_ODS;                               
grant EXECUTE ANY PROGRAM to DAI_REPORTING_ODS;                                 
grant EXECUTE ANY RULE SET to DAI_REPORTING_ODS;                                
grant EXECUTE ANY RULE to DAI_REPORTING_ODS;                                    
grant EXECUTE ANY TYPE to DAI_REPORTING_ODS;                                    
grant GLOBAL QUERY REWRITE to DAI_REPORTING_ODS;                                
grant INSERT ANY CUBE DIMENSION to DAI_REPORTING_ODS;                           
grant INSERT ANY MEASURE FOLDER to DAI_REPORTING_ODS;                           
grant INSERT ANY TABLE to DAI_REPORTING_ODS;                                    
grant LOCK ANY TABLE to DAI_REPORTING_ODS;                                      
grant MERGE ANY VIEW to DAI_REPORTING_ODS;                                      
grant ON COMMIT REFRESH to DAI_REPORTING_ODS;                                   
grant QUERY REWRITE to DAI_REPORTING_ODS;                                       
grant SELECT ANY CUBE DIMENSION to DAI_REPORTING_ODS;                           
grant SELECT ANY CUBE to DAI_REPORTING_ODS;                                     
grant SELECT ANY DICTIONARY to DAI_REPORTING_ODS;                               
grant SELECT ANY MINING MODEL to DAI_REPORTING_ODS;                             
grant SELECT ANY SEQUENCE to DAI_REPORTING_ODS;                                 
grant SELECT ANY TABLE to DAI_REPORTING_ODS;                                    
grant SELECT ANY TRANSACTION to DAI_REPORTING_ODS;                              
grant UNDER ANY TABLE to DAI_REPORTING_ODS;                                     
grant UNDER ANY TYPE to DAI_REPORTING_ODS;                                      
grant UNDER ANY VIEW to DAI_REPORTING_ODS;                                      
grant UNLIMITED TABLESPACE to DAI_REPORTING_ODS;                                
grant UPDATE ANY CUBE BUILD PROCESS to DAI_REPORTING_ODS;                       
grant UPDATE ANY CUBE DIMENSION to DAI_REPORTING_ODS;                           
grant UPDATE ANY CUBE to DAI_REPORTING_ODS;                                     
grant UPDATE ANY TABLE to DAI_REPORTING_ODS;                                    
grant CONNECT to DAI_REPORTING_ODS;                                             
grant RESOURCE to DAI_REPORTING_ODS;                                            
create user DAI_REPORTING_SAFI identified by DAI_REPORTING_SAFI                 
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant COMMENT ANY TABLE to DAI_REPORTING_SAFI;                                  
grant CREATE ANY MATERIALIZED VIEW to DAI_REPORTING_SAFI;                       
grant CREATE ANY TABLE to DAI_REPORTING_SAFI;                                   
grant CREATE PROCEDURE to DAI_REPORTING_SAFI;                                   
grant CREATE SEQUENCE to DAI_REPORTING_SAFI;                                    
grant CREATE SESSION to DAI_REPORTING_SAFI;                                     
grant CREATE SYNONYM to DAI_REPORTING_SAFI;                                     
grant CREATE TABLE to DAI_REPORTING_SAFI;                                       
grant CREATE TRIGGER to DAI_REPORTING_SAFI;                                     
grant CREATE TYPE to DAI_REPORTING_SAFI;                                        
grant CREATE VIEW to DAI_REPORTING_SAFI;                                        
grant GLOBAL QUERY REWRITE to DAI_REPORTING_SAFI;                               
grant ON COMMIT REFRESH to DAI_REPORTING_SAFI;                                  
grant SELECT ANY TABLE to DAI_REPORTING_SAFI;                                   
grant UNLIMITED TABLESPACE to DAI_REPORTING_SAFI;                               
grant RESOURCE to DAI_REPORTING_SAFI;                                           
grant SCHEDULER_ADMIN to DAI_REPORTING_SAFI;                                    
create user DAI_REPORTING_SAFI_CDL identified by DAI_REPORTING_SAFI_CDL         
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
create user DAI_SMSI identified by DAI_SMSI                                     
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant ANALYZE ANY DICTIONARY to DAI_SMSI;                                       
grant ANALYZE ANY to DAI_SMSI;                                                  
grant BECOME USER to DAI_SMSI;                                                  
grant COMMENT ANY TABLE to DAI_SMSI;                                            
grant CREATE ANY CUBE BUILD PROCESS to DAI_SMSI;                                
grant CREATE ANY CUBE DIMENSION to DAI_SMSI;                                    
grant CREATE ANY CUBE to DAI_SMSI;                                              
grant CREATE ANY DIMENSION to DAI_SMSI;                                         
grant CREATE ANY EDITION to DAI_SMSI;                                           
grant CREATE ANY INDEX to DAI_SMSI;                                             
grant CREATE ANY INDEXTYPE to DAI_SMSI;                                         
grant CREATE ANY MATERIALIZED VIEW to DAI_SMSI;                                 
grant CREATE ANY MEASURE FOLDER to DAI_SMSI;                                    
grant CREATE ANY PROCEDURE to DAI_SMSI;                                         
grant CREATE ANY RULE SET to DAI_SMSI;                                          
grant CREATE ANY RULE to DAI_SMSI;                                              
grant CREATE ANY SEQUENCE to DAI_SMSI;                                          
grant CREATE ANY SQL PROFILE to DAI_SMSI;                                       
grant CREATE ANY SYNONYM to DAI_SMSI;                                           
grant CREATE ANY TABLE to DAI_SMSI;                                             
grant CREATE ANY TRIGGER to DAI_SMSI;                                           
grant CREATE ANY TYPE to DAI_SMSI;                                              
grant CREATE ANY VIEW to DAI_SMSI;                                              
grant CREATE INDEXTYPE to DAI_SMSI;                                             
grant CREATE JOB to DAI_SMSI;                                                   
grant CREATE MATERIALIZED VIEW to DAI_SMSI;                                     
grant CREATE PROCEDURE to DAI_SMSI;                                             
grant CREATE PUBLIC SYNONYM to DAI_SMSI;                                        
grant CREATE SEQUENCE to DAI_SMSI;                                              
grant CREATE SESSION to DAI_SMSI;                                               
grant CREATE SYNONYM to DAI_SMSI;                                               
grant CREATE TABLE to DAI_SMSI;                                                 
grant CREATE TRIGGER to DAI_SMSI;                                               
grant CREATE TYPE to DAI_SMSI;                                                  
grant CREATE VIEW to DAI_SMSI;                                                  
grant DELETE ANY CUBE DIMENSION to DAI_SMSI;                                    
grant DELETE ANY MEASURE FOLDER to DAI_SMSI;                                    
grant DELETE ANY TABLE to DAI_SMSI;                                             
grant DROP ANY MATERIALIZED VIEW to DAI_SMSI;                                   
grant DROP ANY RULE SET to DAI_SMSI;                                            
grant DROP ANY RULE to DAI_SMSI;                                                
grant DROP ANY SEQUENCE to DAI_SMSI;                                            
grant DROP ANY SYNONYM to DAI_SMSI;                                             
grant DROP ANY TABLE to DAI_SMSI;                                               
grant EXECUTE ANY RULE SET to DAI_SMSI;                                         
grant EXECUTE ANY RULE to DAI_SMSI;                                             
grant EXECUTE ASSEMBLY to DAI_SMSI;                                             
grant FORCE TRANSACTION to DAI_SMSI;                                            
grant GLOBAL QUERY REWRITE to DAI_SMSI;                                         
grant INSERT ANY TABLE to DAI_SMSI;                                             
grant LOCK ANY TABLE to DAI_SMSI;                                               
grant MERGE ANY VIEW to DAI_SMSI;                                               
grant ON COMMIT REFRESH to DAI_SMSI;                                            
grant QUERY REWRITE to DAI_SMSI;                                                
grant SELECT ANY CUBE DIMENSION to DAI_SMSI;                                    
grant SELECT ANY CUBE to DAI_SMSI;                                              
grant SELECT ANY DICTIONARY to DAI_SMSI;                                        
grant SELECT ANY MINING MODEL to DAI_SMSI;                                      
grant SELECT ANY SEQUENCE to DAI_SMSI;                                          
grant SELECT ANY TABLE to DAI_SMSI;                                             
grant SELECT ANY TRANSACTION to DAI_SMSI;                                       
grant UNDER ANY TABLE to DAI_SMSI;                                              
grant UNDER ANY TYPE to DAI_SMSI;                                               
grant UNDER ANY VIEW to DAI_SMSI;                                               
grant UNLIMITED TABLESPACE to DAI_SMSI;                                         
grant UPDATE ANY CUBE BUILD PROCESS to DAI_SMSI;                                
grant UPDATE ANY CUBE DIMENSION to DAI_SMSI;                                    
grant UPDATE ANY CUBE to DAI_SMSI;                                              
grant UPDATE ANY TABLE to DAI_SMSI;                                             
grant CONNECT to DAI_SMSI;                                                      
grant RESOURCE to DAI_SMSI;                                                     

create user MICROSTRAT identified by MICROSTRAT                                 
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant ALTER SESSION to MICROSTRAT;                                              
grant CREATE SESSION to MICROSTRAT;                                             
grant CREATE TABLE to MICROSTRAT;                                               


create user OSS_BAR identified by OSS_BAR                                       
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant ANALYZE ANY DICTIONARY to OSS_BAR;                                        
grant ANALYZE ANY to OSS_BAR;                                                   
grant BECOME USER to OSS_BAR;                                                   
grant CREATE ANY INDEX to OSS_BAR;                                              
grant CREATE ANY INDEXTYPE to OSS_BAR;                                          
grant CREATE ANY MATERIALIZED VIEW to OSS_BAR;                                  
grant CREATE ANY SEQUENCE to OSS_BAR;                                           
grant CREATE ANY SQL PROFILE to OSS_BAR;                                        
grant CREATE ANY TABLE to OSS_BAR;                                              
grant CREATE ANY TRIGGER to OSS_BAR;                                            
grant CREATE ANY TYPE to OSS_BAR;                                               
grant CREATE ANY VIEW to OSS_BAR;                                               
grant CREATE INDEXTYPE to OSS_BAR;                                              
grant CREATE JOB to OSS_BAR;                                                    
grant CREATE MATERIALIZED VIEW to OSS_BAR;                                      
grant CREATE PROCEDURE to OSS_BAR;                                              
grant CREATE PUBLIC SYNONYM to OSS_BAR;                                         
grant CREATE SEQUENCE to OSS_BAR;                                               
grant CREATE SESSION to OSS_BAR;                                                
grant CREATE SYNONYM to OSS_BAR;                                                
grant CREATE TABLE to OSS_BAR;                                                  
grant CREATE TRIGGER to OSS_BAR;                                                
grant CREATE TYPE to OSS_BAR;                                                   
grant CREATE VIEW to OSS_BAR;                                                   
grant DELETE ANY TABLE to OSS_BAR;                                              
grant DROP ANY MATERIALIZED VIEW to OSS_BAR;                                    
grant GLOBAL QUERY REWRITE to OSS_BAR;                                          
grant INSERT ANY TABLE to OSS_BAR;                                              
grant LOCK ANY TABLE to OSS_BAR;                                                
grant MERGE ANY VIEW to OSS_BAR;                                                
grant ON COMMIT REFRESH to OSS_BAR;                                             
grant QUERY REWRITE to OSS_BAR;                                                 
grant SELECT ANY DICTIONARY to OSS_BAR;                                         
grant SELECT ANY TABLE to OSS_BAR;                                              
grant UNDER ANY TABLE to OSS_BAR;                                               
grant UNDER ANY TYPE to OSS_BAR;                                                
grant UNDER ANY VIEW to OSS_BAR;                                                
grant UNLIMITED TABLESPACE to OSS_BAR;                                          
grant UPDATE ANY TABLE to OSS_BAR;                                              
grant CONNECT to OSS_BAR;                                                       
grant RESOURCE to OSS_BAR;                                                      


create user PERF_MSTR_REP identified by PERF_MSTR_REP                           
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant CREATE PROCEDURE to PERF_MSTR_REP;                                        
grant CREATE SEQUENCE to PERF_MSTR_REP;                                         
grant CREATE SESSION to PERF_MSTR_REP;                                          
grant CREATE SYNONYM to PERF_MSTR_REP;                                          
grant CREATE TABLE to PERF_MSTR_REP;                                            
grant CREATE TRIGGER to PERF_MSTR_REP;                                          
grant CREATE VIEW to PERF_MSTR_REP;                                             


create user SMSI_PUB identified by SMSI_PUB                                     
default tablespace canoe_data                                                   
quota unlimited on canoe_data                                                   
quota unlimited on canoe_index                                                  
quota unlimited on canoe_data_compress                                          
/                                                                               
                                                                                
grant ADMINISTER ANY SQL TUNING SET to SMSI_PUB;                                
grant ADMINISTER DATABASE TRIGGER to SMSI_PUB;                                  
grant ADMINISTER RESOURCE MANAGER to SMSI_PUB;                                  
grant ADMINISTER SQL MANAGEMENT OBJECT to SMSI_PUB;                             
grant ADMINISTER SQL TUNING SET to SMSI_PUB;                                    
grant ADVISOR to SMSI_PUB;                                                      
grant ALTER ANY ASSEMBLY to SMSI_PUB;                                           
grant ALTER ANY CLUSTER to SMSI_PUB;                                            
grant ALTER ANY CUBE DIMENSION to SMSI_PUB;                                     
grant ALTER ANY CUBE to SMSI_PUB;                                               
grant ALTER ANY DIMENSION to SMSI_PUB;                                          
grant ALTER ANY EDITION to SMSI_PUB;                                            
grant ALTER ANY EVALUATION CONTEXT to SMSI_PUB;                                 
grant ALTER ANY INDEX to SMSI_PUB;                                              
grant ALTER ANY INDEXTYPE to SMSI_PUB;                                          
grant ALTER ANY LIBRARY to SMSI_PUB;                                            
grant ALTER ANY MATERIALIZED VIEW to SMSI_PUB;                                  
grant ALTER ANY MINING MODEL to SMSI_PUB;                                       
grant ALTER ANY OPERATOR to SMSI_PUB;                                           
grant ALTER ANY OUTLINE to SMSI_PUB;                                            
grant ALTER ANY PROCEDURE to SMSI_PUB;                                          
grant ALTER ANY ROLE to SMSI_PUB;                                               
grant ALTER ANY RULE SET to SMSI_PUB;                                           
grant ALTER ANY RULE to SMSI_PUB;                                               
grant ALTER ANY SEQUENCE to SMSI_PUB;                                           
grant ALTER ANY SQL PROFILE to SMSI_PUB;                                        
grant ALTER ANY TABLE to SMSI_PUB;                                              
grant ALTER ANY TRIGGER to SMSI_PUB;                                            
grant ALTER ANY TYPE to SMSI_PUB;                                               
grant ALTER DATABASE LINK to SMSI_PUB;                                          
grant ALTER DATABASE to SMSI_PUB;                                               
grant ALTER PROFILE to SMSI_PUB;                                                
grant ALTER PUBLIC DATABASE LINK to SMSI_PUB;                                   
grant ALTER RESOURCE COST to SMSI_PUB;                                          
grant ALTER ROLLBACK SEGMENT to SMSI_PUB;                                       
grant ALTER SESSION to SMSI_PUB;                                                
grant ALTER SYSTEM to SMSI_PUB;                                                 
grant ALTER TABLESPACE to SMSI_PUB;                                             
grant ALTER USER to SMSI_PUB;                                                   
grant ANALYZE ANY DICTIONARY to SMSI_PUB;                                       
grant ANALYZE ANY to SMSI_PUB;                                                  
grant AUDIT ANY to SMSI_PUB;                                                    
grant AUDIT SYSTEM to SMSI_PUB;                                                 
grant BACKUP ANY TABLE to SMSI_PUB;                                             
grant BECOME USER to SMSI_PUB;                                                  
grant CHANGE NOTIFICATION to SMSI_PUB;                                          
grant COMMENT ANY MINING MODEL to SMSI_PUB;                                     
grant COMMENT ANY TABLE to SMSI_PUB;                                            
grant CREATE ANY ASSEMBLY to SMSI_PUB;                                          
grant CREATE ANY CLUSTER to SMSI_PUB;                                           
grant CREATE ANY CONTEXT to SMSI_PUB;                                           
grant CREATE ANY CUBE BUILD PROCESS to SMSI_PUB;                                
grant CREATE ANY CUBE DIMENSION to SMSI_PUB;                                    
grant CREATE ANY CUBE to SMSI_PUB;                                              
grant CREATE ANY DIMENSION to SMSI_PUB;                                         
grant CREATE ANY DIRECTORY to SMSI_PUB;                                         
grant CREATE ANY EDITION to SMSI_PUB;                                           
grant CREATE ANY EVALUATION CONTEXT to SMSI_PUB;                                
grant CREATE ANY INDEX to SMSI_PUB;                                             
grant CREATE ANY INDEXTYPE to SMSI_PUB;                                         
grant CREATE ANY JOB to SMSI_PUB;                                               
grant CREATE ANY LIBRARY to SMSI_PUB;                                           
grant CREATE ANY MATERIALIZED VIEW to SMSI_PUB;                                 
grant CREATE ANY MEASURE FOLDER to SMSI_PUB;                                    
grant CREATE ANY MINING MODEL to SMSI_PUB;                                      
grant CREATE ANY OPERATOR to SMSI_PUB;                                          
grant CREATE ANY OUTLINE to SMSI_PUB;                                           
grant CREATE ANY PROCEDURE to SMSI_PUB;                                         
grant CREATE ANY RULE SET to SMSI_PUB;                                          
grant CREATE ANY RULE to SMSI_PUB;                                              
grant CREATE ANY SEQUENCE to SMSI_PUB;                                          
grant CREATE ANY SQL PROFILE to SMSI_PUB;                                       
grant CREATE ANY SYNONYM to SMSI_PUB;                                           
grant CREATE ANY TABLE to SMSI_PUB;                                             
grant CREATE ANY TRIGGER to SMSI_PUB;                                           
grant CREATE ANY TYPE to SMSI_PUB;                                              
grant CREATE ANY VIEW to SMSI_PUB;                                              
grant CREATE ASSEMBLY to SMSI_PUB;                                              
grant CREATE CLUSTER to SMSI_PUB;                                               
grant CREATE CUBE BUILD PROCESS to SMSI_PUB;                                    
grant CREATE CUBE DIMENSION to SMSI_PUB;                                        
grant CREATE CUBE to SMSI_PUB;                                                  
grant CREATE DATABASE LINK to SMSI_PUB;                                         
grant CREATE DIMENSION to SMSI_PUB;                                             
grant CREATE EVALUATION CONTEXT to SMSI_PUB;                                    
grant CREATE EXTERNAL JOB to SMSI_PUB;                                          
grant CREATE INDEXTYPE to SMSI_PUB;                                             
grant CREATE JOB to SMSI_PUB;                                                   
grant CREATE LIBRARY to SMSI_PUB;                                               
grant CREATE MATERIALIZED VIEW to SMSI_PUB;                                     
grant CREATE MEASURE FOLDER to SMSI_PUB;                                        
grant CREATE MINING MODEL to SMSI_PUB;                                          
grant CREATE OPERATOR to SMSI_PUB;                                              
grant CREATE PROCEDURE to SMSI_PUB;                                             
grant CREATE PROFILE to SMSI_PUB;                                               
grant CREATE PUBLIC DATABASE LINK to SMSI_PUB;                                  
grant CREATE PUBLIC SYNONYM to SMSI_PUB;                                        
grant CREATE ROLE to SMSI_PUB;                                                  
grant CREATE ROLLBACK SEGMENT to SMSI_PUB;                                      
grant CREATE RULE SET to SMSI_PUB;                                              
grant CREATE RULE to SMSI_PUB;                                                  
grant CREATE SEQUENCE to SMSI_PUB;                                              
grant CREATE SESSION to SMSI_PUB;                                               
grant CREATE SYNONYM to SMSI_PUB;                                               
grant CREATE TABLE to SMSI_PUB;                                                 
grant CREATE TABLESPACE to SMSI_PUB;                                            
grant CREATE TRIGGER to SMSI_PUB;                                               
grant CREATE TYPE to SMSI_PUB;                                                  
grant CREATE USER to SMSI_PUB;                                                  
grant CREATE VIEW to SMSI_PUB;                                                  
grant DEBUG ANY PROCEDURE to SMSI_PUB;                                          
grant DEBUG CONNECT SESSION to SMSI_PUB;                                        
grant DELETE ANY CUBE DIMENSION to SMSI_PUB;                                    
grant DELETE ANY MEASURE FOLDER to SMSI_PUB;                                    
grant DELETE ANY TABLE to SMSI_PUB;                                             
grant DEQUEUE ANY QUEUE to SMSI_PUB;                                            
grant DROP ANY ASSEMBLY to SMSI_PUB;                                            
grant DROP ANY CLUSTER to SMSI_PUB;                                             
grant DROP ANY CONTEXT to SMSI_PUB;                                             
grant DROP ANY CUBE BUILD PROCESS to SMSI_PUB;                                  
grant DROP ANY CUBE DIMENSION to SMSI_PUB;                                      
grant DROP ANY CUBE to SMSI_PUB;                                                
grant DROP ANY DIMENSION to SMSI_PUB;                                           
grant DROP ANY DIRECTORY to SMSI_PUB;                                           
grant DROP ANY EDITION to SMSI_PUB;                                             
grant DROP ANY EVALUATION CONTEXT to SMSI_PUB;                                  
grant DROP ANY INDEX to SMSI_PUB;                                               
grant DROP ANY INDEXTYPE to SMSI_PUB;                                           
grant DROP ANY LIBRARY to SMSI_PUB;                                             
grant DROP ANY MATERIALIZED VIEW to SMSI_PUB;                                   
grant DROP ANY MEASURE FOLDER to SMSI_PUB;                                      
grant DROP ANY MINING MODEL to SMSI_PUB;                                        
grant DROP ANY OPERATOR to SMSI_PUB;                                            
grant DROP ANY OUTLINE to SMSI_PUB;                                             
grant DROP ANY PROCEDURE to SMSI_PUB;                                           
grant DROP ANY ROLE to SMSI_PUB;                                                
grant DROP ANY RULE SET to SMSI_PUB;                                            
grant DROP ANY RULE to SMSI_PUB;                                                
grant DROP ANY SEQUENCE to SMSI_PUB;                                            
grant DROP ANY SQL PROFILE to SMSI_PUB;                                         
grant DROP ANY SYNONYM to SMSI_PUB;                                             
grant DROP ANY TABLE to SMSI_PUB;                                               
grant DROP ANY TRIGGER to SMSI_PUB;                                             
grant DROP ANY TYPE to SMSI_PUB;                                                
grant DROP ANY VIEW to SMSI_PUB;                                                
grant DROP PROFILE to SMSI_PUB;                                                 
grant DROP PUBLIC DATABASE LINK to SMSI_PUB;                                    
grant DROP PUBLIC SYNONYM to SMSI_PUB;                                          
grant DROP ROLLBACK SEGMENT to SMSI_PUB;                                        
grant DROP TABLESPACE to SMSI_PUB;                                              
grant DROP USER to SMSI_PUB;                                                    
grant ENQUEUE ANY QUEUE to SMSI_PUB;                                            
grant EXECUTE ANY ASSEMBLY to SMSI_PUB;                                         
grant EXECUTE ANY CLASS to SMSI_PUB;                                            
grant EXECUTE ANY EVALUATION CONTEXT to SMSI_PUB;                               
grant EXECUTE ANY INDEXTYPE to SMSI_PUB;                                        
grant EXECUTE ANY LIBRARY to SMSI_PUB;                                          
grant EXECUTE ANY OPERATOR to SMSI_PUB;                                         
grant EXECUTE ANY PROCEDURE to SMSI_PUB;                                        
grant EXECUTE ANY PROGRAM to SMSI_PUB;                                          
grant EXECUTE ANY RULE SET to SMSI_PUB;                                         
grant EXECUTE ANY RULE to SMSI_PUB;                                             
grant EXECUTE ANY TYPE to SMSI_PUB;                                             
grant EXECUTE ASSEMBLY to SMSI_PUB;                                             
grant EXEMPT ACCESS POLICY to SMSI_PUB;                                         
grant EXEMPT IDENTITY POLICY to SMSI_PUB;                                       
grant EXPORT FULL DATABASE to SMSI_PUB;                                         
grant FLASHBACK ANY TABLE to SMSI_PUB;                                          
grant FLASHBACK ARCHIVE ADMINISTER to SMSI_PUB;                                 
grant FORCE ANY TRANSACTION to SMSI_PUB;                                        
grant FORCE TRANSACTION to SMSI_PUB;                                            
grant GLOBAL QUERY REWRITE to SMSI_PUB;                                         
grant GRANT ANY OBJECT PRIVILEGE to SMSI_PUB;                                   
grant GRANT ANY PRIVILEGE to SMSI_PUB;                                          
grant GRANT ANY ROLE to SMSI_PUB;                                               
grant IMPORT FULL DATABASE to SMSI_PUB;                                         
grant INSERT ANY CUBE DIMENSION to SMSI_PUB;                                    
grant INSERT ANY MEASURE FOLDER to SMSI_PUB;                                    
grant INSERT ANY TABLE to SMSI_PUB;                                             
grant LOCK ANY TABLE to SMSI_PUB;                                               
grant MANAGE ANY FILE GROUP to SMSI_PUB;                                        
grant MANAGE ANY QUEUE to SMSI_PUB;                                             
grant MANAGE FILE GROUP to SMSI_PUB;                                            
grant MANAGE SCHEDULER to SMSI_PUB;                                             
grant MANAGE TABLESPACE to SMSI_PUB;                                            
grant MERGE ANY VIEW to SMSI_PUB;                                               
grant ON COMMIT REFRESH to SMSI_PUB;                                            
grant QUERY REWRITE to SMSI_PUB;                                                
grant READ ANY FILE GROUP to SMSI_PUB;                                          
grant RESTRICTED SESSION to SMSI_PUB;                                           
grant RESUMABLE to SMSI_PUB;                                                    
grant SELECT ANY CUBE DIMENSION to SMSI_PUB;                                    
grant SELECT ANY CUBE to SMSI_PUB;                                              
grant SELECT ANY DICTIONARY to SMSI_PUB;                                        
grant SELECT ANY MINING MODEL to SMSI_PUB;                                      
grant SELECT ANY SEQUENCE to SMSI_PUB;                                          
grant SELECT ANY TABLE to SMSI_PUB;                                             
grant SELECT ANY TRANSACTION to SMSI_PUB;                                       
grant UNDER ANY TABLE to SMSI_PUB;                                              
grant UNDER ANY TYPE to SMSI_PUB;                                               
grant UNDER ANY VIEW to SMSI_PUB;                                               
grant UNLIMITED TABLESPACE to SMSI_PUB;                                         
grant UPDATE ANY CUBE BUILD PROCESS to SMSI_PUB;                                
grant UPDATE ANY CUBE DIMENSION to SMSI_PUB;                                    
grant UPDATE ANY CUBE to SMSI_PUB;                                              
grant UPDATE ANY TABLE to SMSI_PUB;                                             
grant CONNECT to SMSI_PUB;                                                      
grant RESOURCE to SMSI_PUB;                                                     

