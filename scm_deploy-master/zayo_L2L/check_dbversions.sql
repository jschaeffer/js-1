select MAX(tag) AS a FROM "&DB_USER"."DATABASECHANGELOG";
exit sql.sqlcode;
