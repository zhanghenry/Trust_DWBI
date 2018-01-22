with temp_actual as
 (select a.l_month_id, a.l_stage_id, sum(a.f_actual_tot) as f_actual_tot
    from tt_sr_tstrev_stage_m a
   where a.l_month_id between 201701 and 201711 and a.l_stage_id = 450
   group by a.l_month_id, a.l_stage_id),
temp_ratio as
 (select a.l_month_id,
         e.c_proj_code,
         e.c_proj_name,
         f.c_busi_scope_n,
         a.l_stage_id,
         d.c_stage_code,
         g.c_fdsrc_name as c_fdsrc_type_n_l1,
         b.c_fdsrc_name,
         sum(a.f_balance_bot) as f_balance_bot,
         sum(a.f_bot_ratio) as f_bot_ratio,
         sum(a.f_balance_agg) as f_balance_agg
    from tt_tc_fdsrc_cont_m   a,
         dim_tc_fund_source   b,
         dim_tc_fund_source_n c,
         dim_sr_stage         d,
         dim_pb_project_basic e,
         dim_pb_project_biz   f,
         dim_tc_fund_source   g
   where a.l_fdsrc_type_id = b.l_fdsrc_id(+)
     and a.l_fdsrc_id = c.l_fdsrc_id
     and c.l_stage_id = d.l_stage_id
     and c.l_proj_id = e.l_proj_id
     and e.l_proj_id = f.l_proj_id
     and b.l_fdsrc_type = g.l_fdsrc_id
     and substr(c.l_effective_date, 1, 6) <= a.l_month_id
     and substr(c.l_expiration_date, 1, 6) > a.l_month_id
     and A.L_MONTH_ID between 201701 and 201711
     and d.c_stage_code = 'F88000'
   group by a.l_month_id,
         e.c_proj_code,
         e.c_proj_name,
         f.c_busi_scope_n,
         a.l_stage_id,
         d.c_stage_code,
         g.c_fdsrc_name,
         b.c_fdsrc_name)
select tp1.*, tp2.f_actual_tot * tp1.f_bot_ratio
  from temp_ratio tp1, temp_actual tp2
 where tp1.l_month_id = tp2.l_month_id
   and tp1.l_stage_id = tp2.l_stage_id
   order by tp1.l_month_id,tp1.c_stage_code;