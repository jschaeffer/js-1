CREATE USER PCI_PERF IDENTIFIED BY PCI_PERF DEFAULT TABLESPACE canoe_data_compress
TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;

GRANT TABLE_OWNER TO PCI_PERF; 
GRANT RESOURCE TO PCI_PERF;
Grant create session, alter session to PCI_PERF;
 