create or replace view v_project_rules as
with temp_emp as
 (select t.l_emp_id, t.c_emp_name from dim_pb_employee t)
select d1.l_proj_id,
       d2.c_emp_name as l_tstmgr_name,
       d3.c_emp_name as l_opmgr_name,
       d4.c_emp_name as l_invmgr_name,
       d5.c_emp_name as l_tstacct_name,
       d6.c_emp_name as l_loanclerk_name,
       d7.c_emp_name as l_invclerk_name
  from dim_pb_project_basic d1,
       temp_emp            d2,
       temp_emp            d3,
       temp_emp            d4,
       temp_emp            d5,
       temp_emp            d6,
       temp_emp            d7
 where d1.l_tstmgr_id = d2.l_emp_id(+)
   and d1.l_opmgr_id = d3.l_emp_id(+)
   and d1.l_invmgr_id = d4.l_emp_id(+)
   and d1.l_tstacct_id = d5.l_emp_id(+)
   and d1.l_loanclerk_id = d6.l_emp_id(+)
   and d1.l_invclerk_id = d7.l_emp_id(+);
