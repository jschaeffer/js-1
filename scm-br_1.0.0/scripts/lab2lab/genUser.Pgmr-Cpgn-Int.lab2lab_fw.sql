CREATE USER PCI_FW IDENTIFIED BY PCI_FW DEFAULT TABLESPACE canoe_data_compress
TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;

GRANT TABLE_OWNER TO PCI_FW; 
GRANT RESOURCE TO PCI_FW;
Grant create session, alter session to PCI_FW;
 