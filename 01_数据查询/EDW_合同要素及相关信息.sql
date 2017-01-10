--合同资金来源
select b.c_cont_code,
       s.c_proj_code,
       s.c_proj_name,
       e.c_cust_name,
       c.c_fdsrc_name,
       d.c_inst_name,
       sum(t.f_scale)
  from tt_tc_scale_flow_d   t,
       dim_tc_contract      b,
       dim_pb_project_basic s,
       dim_tc_fund_source   c,
       dim_pb_institution   d,
       dim_ca_customer      e
 where t.l_cont_id = b.l_cont_id
   and b.l_proj_id = s.l_proj_id
   and b.l_settler_id = e.l_cust_id(+)
   and nvl(b.l_fdsrc_Id, 0) = c.l_fdsrc_id(+)
   and nvl(b.l_fdsrc_inst_id, 0) = d.l_inst_id(+)
   and s.c_proj_name like '%稳健2128号%'
   and t.l_change_date <= 20161231
   and b.l_expiration_date > 20161231
 group by b.c_cont_code,
          s.c_proj_code,
          s.c_proj_name,
          e.c_cust_name,
          c.c_fdsrc_name,
          d.c_inst_name
 order by s.c_proj_code,
          s.c_proj_name,
          e.c_cust_name,
          c.c_fdsrc_name,
          d.c_inst_name;