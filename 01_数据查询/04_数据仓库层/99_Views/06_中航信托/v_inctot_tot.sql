create or replace view v_inctot_tot as
select l_month_id,
       decode(to_char(c_type), 'F_0', 1,
                      'F_1',2,
                      'F_2',3,
                      'F_3',4,
                      'F_4',5,
                      'F_5',6,
                      'F_6',7,
                      'F_7',8, 9) as l_order,
       decode(to_char(c_type), 'F_0', '新增规模(亿)',
                      'F_1','主动管理类',
                      'F_2','其中：TOT',
                      'F_3','    资管业务',
                      'F_4','    投资业务',
                      'F_5','    融资业务',
                      'F_6','被动管理类',
                      'F_7','其中：TOT', '    资管业务') as c_type, f_scale
  from (
select t.l_month_id, sum(t.f_balance_agg)/100000000 as f_0,
       sum(case when b.c_manage_type = '1' then t.f_balance_agg else 0 end)/100000000 as f_1,
       sum(case when b.c_manage_type = '1' and b.l_tot_flag = 1 then t.f_balance_agg else 0 end)/100000000 as f_2,
       sum(case when b.c_manage_type = '1' and b.l_tot_flag = 0 and e.c_dept_code = '841' then t.f_balance_agg else 0 end)/100000000 as f_3,
       sum(case when b.c_manage_type = '1' and b.l_tot_flag = 0 and e.c_dept_code <> '841' and b.c_func_type = '2' then t.f_balance_agg else 0 end)/100000000 as f_4,
       sum(case when b.c_manage_type = '1' and b.l_tot_flag = 0 and e.c_dept_code <> '841' and b.c_func_type = '1' then t.f_balance_agg else 0 end)/100000000 as f_5,
       sum(case when b.c_manage_type = '2' then t.f_balance_agg else 0 end)/100000000 as f_6,
       sum(case when b.c_manage_type = '2' and b.l_tot_flag = 1 then t.f_balance_agg else 0 end)/100000000 as f_7,
       sum(case when b.c_manage_type = '2' and b.l_tot_flag = 0 and e.c_dept_code = '841' then t.f_balance_agg else 0 end)/100000000 as f_8
  from tt_tc_scale_cont_m t,
       dim_tc_contract a,
       dim_pb_product b,
       dim_pb_project_basic c,
       dim_pb_project_biz d,
       dim_pb_department e
 where t.l_cont_id = a.l_cont_id and a.l_prod_id = b.l_prod_id
   and b.l_proj_id = c.l_proj_id and c.l_proj_id = d.l_proj_id
   and c.l_dept_id = e.l_dept_id
--   and t.l_month_id = 201703
   and d.l_pool_flag = 0
   and substr(b.l_setup_date,1,6) = t.l_month_id
   and substr(b.l_effective_date,1,6) <= t.l_month_id
   and substr(b.l_expiration_date,1,6) > t.l_month_id
 group by t.l_month_id) x unpivot (f_scale for c_type in (f_0,f_1,f_2,f_3,f_4,f_5,f_6,f_7,f_8) )
 order by l_month_id, l_order, c_type;
