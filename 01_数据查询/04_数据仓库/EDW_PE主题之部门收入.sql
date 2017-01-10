--部门项目明细收入
select T.L_OBJECT_ID, S.C_PROJ_CODE, s.c_proj_name, sum(t.f_actual_eot)
  from tt_pe_revenue_stage_m t, dim_pb_project_basic s
 where t.l_proj_id = s.l_proj_id
   and s.l_effective_flag = 1
   and t.l_object_id = 10
   and t.l_month_id = 201606
 group by T.L_OBJECT_ID, S.C_PROJ_CODE, s.c_proj_name
having sum(t.f_actual_eot) <> 0;

--部门收入
select b.l_dept_id,
       b.c_dept_name,
       sum(decode(a.l_revstatus_id, 2, a.f_actual_eot, 0)) / 10000 as f_exist,
       sum(decode(a.l_revstatus_id, 1, a.f_actual_eot, 0)) / 10000 as f_new
  from tt_pe_dept_revenue_m a, dim_pb_department b
 where a.l_dept_id = b.l_dept_id
   and a.l_month_id = 201607
 group by b.l_dept_id, b.c_dept_name
 order by b.l_dept_id, b.c_dept_name;