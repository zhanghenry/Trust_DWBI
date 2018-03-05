with temp_ta_cxgm as
 (select b.c_proj_code as c_grain, sum(a.f_balance_agg) as f_value
    from dataedw.tt_tc_scale_cont_m   a,
         dataedw.dim_pb_product       e,
         dataedw.dim_tc_contract      d,
         dataedw.dim_pb_project_basic b,
         dataedw.dim_pb_project_biz   c
   where a.l_cont_id = d.l_cont_id
     and d.l_prod_id = e.l_prod_id
     and e.l_proj_id = b.l_proj_id
     and b.l_proj_id = c.l_proj_id
     and substr(d.l_effective_date, 1, 6) <= a.l_month_id
     and substr(d.l_expiration_date, 1, 6) > a.l_month_id
     and a.l_month_id = 201712
   group by b.c_proj_code),
temp_fa_cxgm as
 (select to4.c_proj_code as c_grain, sum(to3.f_balance_agg) as f_value
    from dataedw.dim_to_book             to1,
         dataedw.dim_to_subject          to2,
         dataedw.tt_to_accounting_subj_m to3,
         dataedw.dim_pb_project_basic          to4
   where to1.l_book_id = to3.l_book_id
     and to2.l_subj_id = to3.l_subj_id
     and to1.l_proj_id = to4.l_proj_id
     and to2.c_subj_code_l1 = '4001'
     and to2.c_subj_code_l2 <> '400100'
     and substr(to1.l_effective_date, 1, 6) <= to3.l_month_id
     and substr(to1.l_expiration_date, 1, 6) > to3.l_month_id
     and to3.l_month_id = 201712
   group by to4.c_proj_code)
select tp1.*,tp2.*
  from temp_ta_cxgm tp1
  full outer join temp_fa_cxgm tp2
    on tp1.c_grain = tp2.c_grain
 where nvl(tp1.f_value, 0) <> nvl(tp2.f_value, 0);
