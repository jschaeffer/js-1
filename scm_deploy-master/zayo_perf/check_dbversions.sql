select tag
from "&DB_USER"."DATABASECHANGELOG"
where to_number(substr(tag, instr(tag, '_', -1)+ 1 )) = (
select max(to_number(substr(tag, instr(tag, '_', -1)+ 1 )))
from "&DB_USER"."DATABASECHANGELOG")
/
exit sql.sqlcode;
