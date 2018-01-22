--期次分成前规模
with temp_fcqgm as
 (select b.c_stage_code as c_grain, sum(a.f_balance_agg) as f_value
    from dataedw.tt_sr_scale_stage_d a, dataedw.dim_sr_stage b
   where a.l_stage_id = b.l_stage_id
     and a.l_day_id = 20171231
     and b.l_setup_date <= a.l_day_id
     and b.l_effective_date <= a.l_day_id
     and b.l_expiration_date > a.l_day_id
   group by b.c_stage_code
  having sum(a.f_balance_agg) <> 0
   order by b.c_stage_code),
--期次按部门分成后期次规模
temp_bm_fchgm as
 (select b.c_stage_code as c_grain, sum(a.f_scale_agg) as f_value
    from dataedw.tt_pe_scale_stage_d a,
         dataedw.dim_sr_stage        b,
         dataedw.dim_pb_department   d
   where a.l_stage_id = b.l_stage_id
     and a.c_object_type = 'BM'
     and a.l_object_id = d.l_dept_id
     and a.l_day_id = 20171231
     and b.l_setup_date <= a.l_day_id
     and d.l_effective_date <= a.l_day_id
     and d.l_expiration_date > a.l_day_id
   group by b.c_stage_code
  having sum(a.f_scale_agg) <> 0
   order by b.c_stage_code),
--期次按员工分成后期次规模
temp_yg_fchgm as
 (select b.c_stage_code as c_grain, sum(a.f_scale_agg) as f_value
    from dataedw.tt_pe_scale_stage_d a,
         dataedw.dim_sr_stage        b,
         dataedw.dim_pb_employee     d
   where a.l_stage_id = b.l_stage_id
     and a.c_object_type = 'YG'
     and a.l_object_id = d.l_emp_id
     and a.l_day_id = 20171231
     and b.l_setup_date <= a.l_day_id
     /*and d.l_effective_date <= a.l_day_id
     and d.l_expiration_date > a.l_day_id*/
   group by b.c_stage_code
  having sum(a.f_scale_agg) <> 0
   order by b.c_stage_code)
select tp1.c_grain,
       tp1.f_value as 期次分成前规模,
       tp2.f_value as 部门分成后规模,
       tp3.f_value as 员工分成后规模
  from temp_fcqgm tp1, temp_bm_fchgm tp2, temp_yg_fchgm tp3
 where tp1.c_grain = tp2.c_grain(+)
   and tp1.c_grain = tp3.c_grain(+)
   and (tp1.f_value <> nvl(tp2.f_value, 0)
    or tp1.f_value <> nvl(tp3.f_value, 0));
