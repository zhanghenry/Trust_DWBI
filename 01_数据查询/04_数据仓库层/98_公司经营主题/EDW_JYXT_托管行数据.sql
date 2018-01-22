with temp_scale_eot as
 (
  select c.c_proj_code, sum(a.f_scale) as f_scale_eot
    from tt_tc_scale_flow_d a, dim_tc_contract b, dim_pb_project_basic c
   where a.l_cont_id = b.l_cont_id
     and b.l_proj_id = c.l_proj_id
     and a.l_change_date <= 20170831
   group by c.c_proj_code),
temp_scale_bot as
 (
  select c.c_proj_code, sum(a.f_scale) as f_scale_bot
    from tt_tc_scale_flow_d a, dim_tc_contract b, dim_pb_project_basic c
   where a.l_cont_id = b.l_cont_id
     and b.l_proj_id = c.l_proj_id
     and a.l_change_date <= 20161231
   group by c.c_proj_code),
temp_bgf as
 (select c.c_proj_code, e.c_inst_name, sum(a.f_revenue) as f_bgf
    from tt_ic_revenue_flow_d a,
         dim_sr_revenue_type  b,
         dim_pb_project_basic c,
         dim_tc_account       d,
         dim_pb_institution   e
   where a.l_proj_id = c.l_proj_id
     and c.l_proj_id = d.l_proj_id
     and d.l_custody_flag = 1
     and d.l_ho_inst_id = e.l_inst_id(+)
     and a.l_revtype_id = b.l_revtype_id
     and b.c_revtype_code = 'ZJBGF'
     and a.l_revdate_id between 20170101 and 20170831
   group by c.c_proj_code, e.c_inst_name),
temp_proj_info as
 (select a.c_proj_code,B.C_FUNC_TYPE_N,B.L_VALUATION_FLAG
    from dim_pb_project_basic a,dim_pb_project_biz b
   where a.l_effective_flag = 1 and a.l_proj_id = b.l_proj_id
     and nvl(a.l_expiry_date, 20991231) > 20161231
     )
select t1.c_proj_code,
t1.C_FUNC_TYPE_N,decode(t1.L_VALUATION_FLAG,1,'估值类','非估值类'),
       t2.f_scale_eot/10000,
       (nvl(t3.f_scale_bot, 0) + nvl(t2.f_scale_eot, 0)) / 20000 as f_scale_pj,
       case when  t4.c_inst_name = '交通银行' then '保管行为交行' when t4.c_inst_name is not null and t4.c_inst_name <> '交通银行' then '有保管行' else '无保管行' end ,
       t4.c_inst_name,
       nvl(t4.f_bgf, 0)/10000
  from temp_proj_info t1, temp_scale_eot t2, temp_scale_bot t3, temp_bgf t4
 where t1.c_proj_code = t2.c_Proj_code(+)
   and t1.c_Proj_code = t3.c_proj_code(+)
   and t1.c_proj_code = t4.c_proj_code(+)
