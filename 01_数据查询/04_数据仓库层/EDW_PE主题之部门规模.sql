--部门当前存续规模
select b.l_dept_id, b.c_dept_name, sum(a.f_balance_eot)
  from tt_sr_scale_proj_m a, dim_pb_department b, dim_pb_project_basic c
 where c.l_dept_id = b.l_dept_id
   and a.l_proj_id = c.l_proj_id
   and a.l_month_id = 201606
   and a.l_month_id >= substr(c.l_effective_date, 1, 6)
   and a.l_month_id < substr(c.l_expiration_date, 1, 6)
 group by b.l_dept_id, b.c_dept_name
 order by b.l_dept_id, b.c_dept_name;
 
--部门存续规模--针对月中部门变更情况
--月中部门变更情况
with temp_dept_change as
 (select a.l_proj_id,
         a.c_proj_code,
         a.c_proj_name,
         a.l_dept_id,
         b.c_dept_name,
         decode(a.l_effective_flag, 1, e.f_balance_eot, -1 * e.f_balance_eot) as f_balance_eot
    from dim_pb_project_basic a,
         dim_pb_department b,
         (select c_proj_code, l_dept_id, l_expiration_date
            from dim_pb_project_basic
           where substr(l_expiration_date, 1, 6) = 201608) c,
         (select c_proj_code, l_dept_id, l_effective_date
            from dim_pb_project_basic
           where substr(l_effective_date, 1, 6) = 201608) d,
         tt_sr_scale_proj_m e
   where a.l_dept_id = b.l_dept_id
     and a.c_proj_code = c.c_proj_code
     and a.c_proj_code = d.c_proj_code
     and c.l_dept_id <> d.l_dept_id
     and a.l_proj_id = e.l_proj_id
     and e.l_month_id = 201608
     and a.l_expiration_date >= 20160801),
--上月末部门规模
temp_dept_actual as
 (select a.l_dept_id,
         count(distinct case
                 when substr(nvl(a.l_expiry_date, 20991231), 1, 6) > t.l_month_id then
                  t.l_proj_id
                 else
                  null
               end) as l_count,
         sum(t.f_balance_eot) as f_exist
    from tt_sr_scale_proj_m t, dim_pb_project_basic a, dim_pb_currency b
   where t.l_proj_id = a.l_proj_id
     and a.l_cy_id = b.l_cy_id
     and t.l_month_id =
         to_char(add_months(To_Date('31-08-2016', 'dd-mm-yyyy'), -1),
                 'yyyymm')
     and substr(a.l_effective_date, 1, 6) <= t.l_month_id
     and substr(a.l_expiration_date, 1, 6) > t.l_month_id
     and b.c_cy_code = 'CNY'
   group by a.l_dept_id)
select temp_dept_actual.l_dept_id,
       temp_dept_actual.l_count,
       temp_dept_actual.f_exist + nvl(temp_dept_change.f_balance_eot, 0) as f_exist
  from temp_dept_actual, temp_dept_change
 where temp_dept_actual.l_dept_id = temp_dept_change.l_dept_id(+);
 
--部门月初规模
--需要将月中调整的项目反馈进去   
select a.l_proj_id,
       a.c_proj_code,
       a.c_proj_name,
       b.c_dept_name,
       decode(a.l_effective_flag, 1, e.f_balance_eot, -1 * e.f_balance_eot) as f_balance_eot
  from dim_pb_project_basic a,
       dim_pb_department b,
       (select c_proj_code, l_dept_id, l_expiration_date
          from dim_pb_project_basic
         where substr(l_expiration_date, 1, 6) = 201608) c,
       (select c_proj_code, l_dept_id, l_effective_date
          from dim_pb_project_basic
         where substr(l_effective_date, 1, 6) = 201608) d,
       tt_sr_scale_proj_m e
 where a.l_dept_id = b.l_dept_id
   and a.c_proj_code = c.c_proj_code
   and a.c_proj_code = d.c_proj_code
   and c.l_dept_id <> d.l_dept_id
   and a.l_proj_id = e.l_proj_id
   and e.l_month_id = 201608
   and a.l_expiration_date >= 20160801;
