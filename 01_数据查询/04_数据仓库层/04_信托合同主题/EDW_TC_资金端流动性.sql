with temp_htxx as
 (select c.c_proj_code,
         c.c_name_full as c_proj_name,
         a.c_cont_code,
         a.l_begin_date,
         a.l_preexp_date,
         a.l_expiry_date,
         f.c_cust_name,
         f.c_cust_type,
         f.c_cust_tytpe_n,
         d.c_acco_no,
         e.f_balance_agg
    from dataedw.dim_tc_contract         a,
         dataedw.dim_pb_product          b,
         dataedw.dim_pb_project_basic    c,
         dataedw.dim_tc_contract_account d,
         dataedw.tt_tc_scale_cont_d      e,
         dataedw.dim_ca_customer         f
   where a.l_prod_id = b.l_prod_id
     and b.l_proj_id = c.l_proj_id
     and a.l_cont_id = d.l_cont_id(+)
     and a.l_cont_id = e.l_cont_id
     and a.l_settlor_id = f.l_cust_id
     and e.l_day_id = 20180123
     --and a.c_cont_code = '170671'
     and a.l_effective_date <= 20180123
     and a.l_expiration_date > 20180123
     and e.f_balance_agg <> 0),
temp_tgh as
 (select t1.l_proj_id, t1.c_proj_code, t1.c_name_full as c_proj_name, t2.c_acco_no
    from dataedw.dim_pb_project_basic t1, dataedw.dim_tc_account t2
   where t1.l_proj_id = t2.l_proj_id
     and t2.l_custody_flag = 1 
     --and t2.c_acco_no = '791904313810315'
     and t1.l_effective_date <= 20180123
     and t1.l_expiration_date > 20180123)
select tp1.*,
       null as f_gy,
       null as f_zgcp,
       case when tp2.c_proj_name like '%天汇%' then tp1.f_balance_agg else 0 end as f_th,
       case when tp2.c_proj_name like '%天诚聚富%' then tp1.f_balance_agg else 0 end as f_tzjf,
       case when tp1.c_cust_type <> '1' then tp1.f_balance_agg else 0 end as f_jg,
       case when tp1.c_cust_type = '1' then tp1.f_balance_agg else 0 end as f_gr
  from temp_htxx tp1, temp_tgh tp2
 where tp1.c_acco_no = tp2.c_acco_no(+)
 --and tp1.c_proj_name like '%天启845号%'
 ;
