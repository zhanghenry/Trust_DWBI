--运营简表
select null as 帐套编号,
       a.c_cont_code as 合同编码,
       a.c_cont_no as 合同编号,
       c.c_proj_name as 项目名称,
       d.c_dept_name as 部门名称,
       f.c_manage_type_n as 主/被动,
       e.f_balance_agg   as 受托余额,
       e.f_decrease_agg  as 累计还本,
       decode(b.c_struct_type,'0',e.f_balance_agg,null ) as 优先,
       decode(b.c_struct_type,'2',e.f_balance_agg,null ) as 劣后,
       a.l_sign_date as 合同起点时间,
       a.l_expiry_date as 合同终止时间,
       null as 实际信托报酬率,
       null as 合同总收入,
       null as 本年应计提收入,
       null as 尚未计提收入,
       null as 信托报酬收入,
       null as 合同财务顾问收入
  from dim_tc_contract      a,
       dim_pb_product       b,
       dim_pb_project_basic c,
       dim_pb_department    d,
       tt_tc_scale_cont_m   e,
       dim_pb_project_biz   f
 where a.l_prod_id = b.l_prod_id
   and b.l_proj_id = c.l_proj_id
   and c.l_dept_id = d.l_dept_id
   and a.l_cont_id = e.l_cont_id
   and b.l_proj_id = f.l_proj_id
   and substr(a.l_effective_date, 1, 6) <= e.l_month_id
   and substr(a.l_expiry_date, 1, 6) > e.l_month_id
   and e.l_month_id = 201609;