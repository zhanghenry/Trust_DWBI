--部门工资及管理费用
select c.c_dept_code, c.c_dept_name, round(sum(a.f_amount_eot) / 10000, 2)
  from tt_fi_accounting_dept_m a, dim_fi_subject b, dim_pb_department c
 where a.l_subj_id = b.l_subj_id
   and b.c_subj_code like '6601%'
   and a.l_dept_id = c.l_dept_id
   and a.l_month_id = 201612
 group by c.c_dept_code, c.c_dept_name;
 
--部门费用结构 
select b.c_dept_code,
       b.c_dept_name,
       sum(a.f_amount) as 总费用,
       sum(decode(a.l_proj_flag, 1, a.f_amount, 0)) as 项目费用,
       sum(decode(a.l_proj_flag, 0, a.f_amount, 0)) as 固定费用
  from tt_fi_accounting_flow_d a, dim_pb_department b, dim_fi_subject c
 where a.c_object_type = 'BM'
   and a.l_object_id = b.l_dept_id
   and b.l_effective_flag = 1
   and a.l_subj_id = c.l_subj_id
   and (c.c_subj_code like '6601%' or c.c_subj_code = '642101')
   and a.l_busi_date between 20160101 and 20161231
 group by b.c_dept_code, b.c_dept_name
 order by b.c_dept_code, b.c_dept_name; 
 
--项目费用
select c.c_dept_code, c.c_dept_name, sum(a.f_amount)
  from tt_fi_accounting_flow_d a,
       dim_pb_project_basic    b,
       dim_pb_department       c,
       dim_fi_subject          d
 where a.c_object_type = 'XM'
   and a.l_object_id <> 0
   and a.l_object_id = b.l_proj_id
   and a.l_subj_id = d.l_subj_id
   and d.c_subj_code like '6601%'
   and b.l_dept_id = c.l_dept_id
   and b.l_effective_flag = 1
   and a.l_busi_date between 20160101 and 20161231
 group by c.c_dept_code, c.c_dept_name;