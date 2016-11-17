select TAG from (select TAG from "&DB_USER"."DATABASECHANGELOG" order by DATABASECHANGELOG.DATEEXECUTED desc) where rownum<=1;
exit sql.sqlcode;
