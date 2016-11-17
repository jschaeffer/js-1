set serveroutput on
DECLARE

  cursor c1 (p_user varchar2) is
  select sid, serial# as ser
  from v$session
  where username = p_user;

  v_user_name VARCHAR2 (30) := upper ('&1');
  u_count     number        := 0;
  str         varchar2(4000);

BEGIN

  SELECT user_id
  INTO u_count
  FROM dba_users WHERE username = v_user_name;

  for r1 in c1(v_user_name) loop
    str := 'alter system kill session ' || chr(39) || r1.sid || ',' || r1.ser || chr(39) || ' immediate';
    dbms_output.put_line ('Killing session ' || r1.sid || ' on instance ' );
    --dbms_output.put_line ('Killing session ' || r1.sid || ' on instance ' || r1.inst_id);
    dbms_output.put_line (str);
    execute immediate str;
  end loop;

    dbms_lock.sleep(5);
  dbms_output.put_line ('Dropping User '||v_user_name);
  EXECUTE IMMEDIATE ('DROP USER '||v_user_name||' CASCADE');


EXCEPTION
when no_data_found then
  dbms_output.put_line (v_user_name || ' does not exist.');
WHEN OTHERS THEN
  DBMS_OUTPUT.put_line (SQLERRM);
  DBMS_OUTPUT.put_line ('   ');

eND;
/
