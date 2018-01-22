--期次分成前收入
with temp_fcqsr as (
select b.c_stage_code as c_grain,
       sum(case
             when c.c_ietype_code_l2 in ('XTBC', 'XTCGF') then
              a.f_planned_eoy
             when c.c_ietype_code in ('XTFXBC', 'XTFXCGF', 'TZZYFX') then
              a.f_planned_eoy * -1
             else
              0
           end) as f_value
  from dataedw.tt_sr_ie_stage_d  a,
       dataedw.dim_sr_stage      b,
       dataedw.dim_pb_ie_type    c,
       dataedw.dim_pb_ie_status  e
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = e.l_iestatus_id
   and b.l_setup_date <= a.l_day_id
   and e.l_recog_flag = 0
   and a.l_day_id = 20171231
   and b.l_effective_date <= a.l_day_id
   and b.l_expiration_date > a.l_day_id
 group by b.c_stage_code having sum(case
             when c.c_ietype_code_l2 in ('XTBC', 'XTCGF') then
              a.f_planned_eoy
             when c.c_ietype_code in ('XTFXBC', 'XTFXCGF', 'TZZYFX') then
              a.f_planned_eoy * -1
             else
              0
           end) <> 0 order by b.c_stage_code),
--期次按部门分成后收入
temp_bm_fchsr as (
select b.c_stage_code as c_grain,
       sum(case
             when c.c_ietype_code_l2 in ('XTBC', 'XTCGF') then
              a.f_planned_eoy
             when c.c_ietype_code in ('XTFXBC', 'XTFXCGF', 'TZZYFX') then
              a.f_planned_eoy * -1
             else
              0
           end) as f_value
  from dataedw.tt_pe_ie_stage_d  a,
       dataedw.dim_sr_stage      b,
       dataedw.dim_pb_ie_type    c,
       dataedw.dim_pb_department d,
       dataedw.dim_pb_ie_status  e
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.c_object_type = 'BM'
   and a.l_object_id = d.l_dept_id
   and a.l_iestatus_id = e.l_iestatus_id
   and b.l_setup_date <= a.l_day_id
   and e.l_recog_flag = 0
   and a.l_day_id = 20171231
   and d.l_effective_date <= a.l_day_id
   and d.l_expiration_date > a.l_day_id
 group by b.c_stage_code having sum(case
             when c.c_ietype_code_l2 in ('XTBC', 'XTCGF') then
              a.f_planned_eoy
             when c.c_ietype_code in ('XTFXBC', 'XTFXCGF', 'TZZYFX') then
              a.f_planned_eoy * -1
             else
              0
           end) <> 0 order by b.c_stage_code),
--期次按员工分成后收入
temp_yg_fchsr as (
select b.c_stage_code as c_grain,
       sum(case
             when c.c_ietype_code_l2 in ('XTBC', 'XTCGF') then
              a.f_planned_eoy
             when c.c_ietype_code in ('XTFXBC', 'XTFXCGF', 'TZZYFX') then
              a.f_planned_eoy * -1
             else
              0
           end) as f_value
  from dataedw.tt_pe_ie_stage_d  a,
       dataedw.dim_sr_stage      b,
       dataedw.dim_pb_ie_type    c,
       dataedw.dim_pb_employee d,
       dataedw.dim_pb_ie_status  e
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.c_object_type = 'YG'
   and a.l_object_id = d.l_emp_id
   and a.l_iestatus_id = e.l_iestatus_id
   and b.l_setup_date <= a.l_day_id
   and e.l_recog_flag = 0
   and a.l_day_id = 20171231
/*   and d.l_effective_date <= a.l_day_id
   and d.l_expiration_date > a.l_day_id*/
 group by b.c_stage_code having sum(case
             when c.c_ietype_code_l2 in ('XTBC', 'XTCGF') then
              a.f_planned_eoy
             when c.c_ietype_code in ('XTFXBC', 'XTFXCGF', 'TZZYFX') then
              a.f_planned_eoy * -1
             else
              0
           end) <> 0 order by b.c_stage_code)
select tp1.c_grain,
       tp1.f_value as 期次分成前收入,
       tp2.f_value as 部门分成后收入,
       tp3.f_value as 员工分成后收入
  from temp_fcqsr tp1, temp_bm_fchsr tp2, temp_yg_fchsr tp3
 where tp1.c_grain = tp2.c_grain(+)
   and tp1.c_grain = tp3.c_grain(+)
   and (tp1.f_value <> nvl(tp2.f_value, 0)
    or tp1.f_value <> nvl(tp3.f_value, 0));


