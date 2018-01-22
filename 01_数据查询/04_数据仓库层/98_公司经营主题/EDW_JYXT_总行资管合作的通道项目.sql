--新增
select d.c_proj_code,
       d.c_proj_name,
       e.c_inst_name,
       f.c_dept_name,
       sum(case
             when b.c_scatype_code = '50' then
              a.f_incurred_eot
             when b.c_scatype_code = '02' and l_valuation_flag <> 1 then
              a.f_incurred_eot
             else
              0
           end) / 100000000 as f_scale
  from tt_sr_scale_type_m   a,
       dim_sr_scale_type    b,
       dim_pb_project_biz   c,
       dim_pb_project_basic d,
       dim_pb_institution   e,
       dim_pb_department    f
 where a.l_proj_id = c.l_proj_id
   and c.l_proj_id = d.l_proj_id
   and a.l_scatype_id = b.l_scatype_id
   and c.L_BANKREC_sub = e.l_inst_id(+)
   and (e.c_inst_name is not null)
   and d.l_dept_id = f.l_dept_id
   and (f.c_dept_name like '%信托业务%' OR f.c_dept_name like '%投资银行%')
   and c.L_GRPREC_FLAG = 1
   and c.c_proj_type_N = '单一'
   and c.c_func_type_N = '事务管理类'
   and a.l_month_id = 201612
   and d.l_setup_date between 20160101 and 20161231
   and exists (select *
          from tt_tc_scale_flow_d t1,
               dim_tc_contract    t2,
               dim_tc_fund_source t3
         where t1.l_cont_id = t2.l_cont_id
           and t2.l_fdsrc_id = t3.l_fdsrc_id
           and t3.c_fdsrc_code like '12%')
 group by d.c_proj_code, d.c_proj_name, e.c_inst_name,f.c_dept_name
 order by d.c_proj_code, d.c_proj_name, e.c_inst_name,f.c_dept_name;