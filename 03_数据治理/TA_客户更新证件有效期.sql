-- Created on 2017/3/6 by ADMINISTRATOR 
declare
  -- Local variables here
  i integer;
  type ref_cursor is ref cursor;
  type type_char is table of varchar2(12);
  type type_date is table of date;
  v_ref_cursor     ref_cursor;
  v_array_custno   type_char;
  v_array_date     type_date;
  v_array_datadate type_date;
begin
  -- Test statements here
  open v_ref_cursor for 'select a.c_custno,a.d_idnovaliddate,a.d_datadate from ti_ta_customerinfo a  ';
  loop
    fetch v_ref_cursor bulk collect
      into v_array_custno, v_array_date, v_array_datadate limit 20000;
    if v_array_custno.count() > 0 then
      forall row in 1 .. v_array_custno.count() execute immediate
                         'update tcustomerinfo set d_idnovaliddate =:1,d_datadate=:2 where c_custno = :3'
                         using v_array_date(row), v_array_datadate(row),
                         v_array_custno(row)
        ;
      commit;
    end if;
    exit when v_ref_cursor%notfound;
  end loop;
  close v_ref_cursor;
end;