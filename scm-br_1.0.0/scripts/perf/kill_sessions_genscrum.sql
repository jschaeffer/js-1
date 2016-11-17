WITH vs AS
  (SELECT rownum rnum,
    sid,
    serial#,
    status,
    username,
    last_call_et,
    command,
    machine,
    osuser,
    module,
    action,
    resource_consumer_group,
    client_info,
    client_identifier,
    type,
    terminal
  FROM v$session
  )
SELECT 'ALTER SYSTEM KILL SESSION '''||vs.sid||', '||serial#||''' IMMEDIATE;'
FROM vs
WHERE vs.USERNAME      = '&DB_USER'
AND NVL(vs.osuser,'x') <> 'SYSTEM'
AND vs.type            <> 'BACKGROUND'
--AND vs.username        IN ('MV_ADMIN','SA_ADMIN', 'IAP_ODS', 'DT_ADMIN', 'SYSDATA')
ORDER BY 1 ;
