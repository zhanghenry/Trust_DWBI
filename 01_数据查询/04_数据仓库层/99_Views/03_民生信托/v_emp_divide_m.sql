create or replace view v_emp_divide_m as
with temp_main as
 (select distinct b.month_id as l_month_id, a.l_object_id,a.l_proj_Id, a.l_divide_id as l_stage_id
    from dim_pe_divide_scheme a, dim_month b
   where a.c_scheme_type = 'QC'
     and a.c_object_type = 'YG'
     and substr(a.l_begdiv_month,1,4) <= b.year_id
     and substr(a.l_enddiv_month,1,4) >= b.year_id
     and substr(a.l_effective_date,1,6) <= b.month_id
     and substr(a.l_expiration_date,1,6) > b.month_id
  union
  select distinct b.l_month_id, a.l_object_id,a.l_proj_Id, b.l_stage_id
    from dim_pe_divide_scheme a, tt_pe_ie_stage_m b, dim_pb_ie_type c
   where a.l_divide_id = b.l_proj_id
     and a.c_object_type = b.c_object_type
     and a.l_object_id = b.l_object_Id
     and b.l_ietype_id = c.l_ietype_id
     and (c.c_ietype_code_l2 = 'XTCGF' or c.c_ietype_code_l1 = 'TZSR')
     and substr(a.l_begdiv_month,1,4) <= substr(b.l_month_id,1,4)
     and substr(a.l_enddiv_month,1,4) >= substr(b.l_month_id,1,4)
     and substr(a.l_effective_date,1,6) <= b.l_month_id
     and substr(a.l_expiration_date,1,6) > b.l_month_id
     and a.c_scheme_type = 'XM'
     and a.c_object_type = 'YG'),
temp_scale as
 (select t1.l_month_id,
         t1.l_proj_id,
         t1.l_stage_id,
         t1.l_object_id,
         sum(t1.f_scale_agg) as f_balance_agg
    from tt_pe_scale_stage_m t1
   where t1.c_object_type = 'YG'
   group by t1.l_month_id, t1.l_proj_id, t1.l_stage_id, t1.l_object_id),
temp_revenue as
 (select t2.l_month_id, t2.l_proj_id, t2.l_stage_id, t2.l_object_id,
     sum(case when t21.c_ietype_code = 'XTGDBC' then t2.f_planned_eoy else 0 end) as f_xtgdbc_no_share,
     sum(case when t21.c_ietype_code = 'XTFDBC' then t2.f_planned_eoy else 0 end) as f_xtfdbc_no_share,
     sum(case when t21.c_ietype_code_l2 = 'XTBC' then t2.f_planned_eoy else 0 end) as f_xtbc_no_share,
     sum(case when t21.c_ietype_code = 'XTFXBC' then t2.f_planned_eoy else 0 end) as f_xtbcfx,
     sum(case when t21.c_ietype_code = 'TZZYFX' then t2.f_planned_eoy else 0 end) as f_zyfx,
     sum(case when t21.c_ietype_code_l2 = 'XTBC' then t2.f_planned_eoy when t21.c_ietype_code in ('XTFXBC', 'TZZYFX') then t2.f_planned_eoy * -1 else 0 end) as f_xtbc,
     sum(case when t21.c_ietype_code_l2 = 'XTBC' and t22.l_iestatus_id = 1 then t2.f_planned_eoy when t21.c_ietype_code in ('XTFXBC', 'TZZYFX') and t22.l_iestatus_id = 1 then t2.f_planned_eoy * -1 else 0 end) as f_xtbc_new,

     sum(case when t21.c_ietype_code_l2 = 'XTCGF' then t2.f_planned_eoy else 0 end) as f_xtcgf_no_share,
     sum(case when t21.c_ietype_code = 'XTFXCGF' then t2.f_planned_eoy else 0 end) as f_xtcgffx,
     sum(case when t21.c_ietype_code_l2 = 'XTCGF' then t2.f_planned_eoy  when t21.c_ietype_code in ('XTFXCGF') then t2.f_planned_eoy * -1 else 0 end) as f_xtcgf,
     sum(case when t21.c_ietype_code_l2 = 'XTCGF' and t22.l_iestatus_id = 1 then t2.f_planned_eoy when t21.c_ietype_code in ('XTFXCGF') and t22.l_iestatus_id = 1 then t2.f_planned_eoy * -1 else 0 end) as f_xtcgf_new,

     sum(case when t21.c_ietype_code = 'XTDLZF' then t2.f_planned_eoy else 0 end) as f_xtdlzf,
     sum(case when t21.c_ietype_code_l1 = 'TZSR' then t2.f_planned_eoy else 0 end) as f_tzsr,

     sum(case when t21.c_ietype_code_l2 = 'XTBC' and t23.l_setup_date < to_number(t25.next_month_id||'01')
              then t2.f_planned_eoy
              else 0 end) as f_kpi_xtbc_no_share,
     sum(case when t21.c_ietype_code_l2 = 'XTCGF' and t23.l_setup_date < to_number(t25.next_month_id||'01')
              then t2.f_planned_eoy
              else 0 end) as f_kpi_xtcgf_no_share,
     sum(case when t21.c_ietype_code_l2 = 'XTBC' and t23.l_setup_date < to_number(t25.next_month_id||'01')
              then t2.f_planned_eoy
              when t21.c_ietype_code in ('XTFXBC','TZZYFX') and t23.l_setup_date < to_number(t25.next_month_id||'01')
              then t2.f_planned_eoy * -1
              else 0 end) as f_kpi_xtbc,
     sum(case when t21.c_ietype_code_l2 = 'XTCGF' and t23.l_setup_date < to_number(t25.next_month_id||'01')
              then t2.f_planned_eoy
              when t21.c_ietype_code = 'XTFXCGF' and t23.l_setup_date < to_number(t25.next_month_id||'01')
              then t2.f_planned_eoy * -1
              else 0 end) as f_kpi_xtcgf,
     sum(case when t21.c_ietype_code_l1 in( 'XTSR','TZSR') and nvl(t23.l_setup_date,t24.l_setup_date) < to_number(t25.next_month_id||'01')
              then t2.f_planned_eoy
              when t21.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') and nvl(t23.l_setup_date,t24.l_setup_date) < to_number(t25.next_month_id||'01')
              then t2.f_planned_eoy * -1
              else 0 end) as f_kpi_xtsr,
     sum(case when t21.c_ietype_code_l1 in( 'XTSR','TZSR') and nvl(t23.l_setup_date,t24.l_setup_date) < to_number(t25.next_month_id||'01') and t23.l_setup_date >= substr(t2.l_month_id,1,4)||'0101'
              then t2.f_planned_eoy
              when t21.c_ietype_code in ('XTFXBC','XTFXCGF','XTFXCGF') and nvl(t23.l_setup_date,t24.l_setup_date) < to_number(t25.next_month_id||'01') and t23.l_setup_date >= substr(t2.l_month_id,1,4)||'0101'
              then t2.f_planned_eoy * -1
              else 0 end) as f_kpi_xtsr_new
    from tt_pe_ie_stage_m t2,dim_pb_ie_type t21,dim_pb_ie_status t22,dim_sr_stage t23,dim_pb_project_basic t24,dim_month t25
   where t2.l_ietype_id = t21.l_ietype_id
     and t2.l_iestatus_id = t22.l_iestatus_id
     and t2.l_stage_id = t23.l_stage_id(+)
     and t2.l_proj_id = t24.l_proj_id
     and t2.l_month_id = t25.month_id
     and t22.l_recog_flag = 0
     and t2.c_object_type = 'YG'
   group by t2.l_month_id, t2.l_proj_id, t2.l_stage_id, t2.l_object_id),
temp_proj_rate as
 (select a.month_id as l_month_id, t3.l_object_id,t3.l_proj_id,sum(t3.f_divide_rate) as f_divide_rate
    from dim_pe_divide_scheme t3, dim_month a
   where t3.c_scheme_type = 'XM'
     and t3.c_object_type = 'YG'
     and substr(t3.l_effective_date,1,6) <= a.month_id
     and substr(t3.l_expiration_date,1,6) > a.month_id
      and t3.l_begdiv_month <= a.month_id
    and t3.l_enddiv_month >= a.month_id
     group by a.month_id, t3.l_object_id, t3.l_proj_id),
temp_stage_rate as
 (select a.month_id as l_month_id, t4.l_object_id, t4.l_proj_id, t4.l_divide_id as l_stage_id, sum(t4.f_divide_rate) as f_divide_rate
    from dim_pe_divide_scheme t4, dim_month a
   where t4.c_scheme_type = 'QC'
     and t4.c_object_type = 'YG'
     and substr(t4.l_effective_date,1,6) <= a.month_id
     and substr(t4.l_expiration_date,1,6) > a.month_id
      and t4.l_begdiv_month <= a.month_id
    and t4.l_enddiv_month >= a.month_id
     group by a.month_id, t4.l_object_id, t4.l_proj_id, t4.l_divide_id)
select a.l_month_id,
       e.l_emp_id,
       e.c_emp_code,
       e.c_emp_name,
       c.l_proj_id,
       c.c_proj_code,
       j.l_tstmgr_name,
       j.l_opmgr_name,
       j.l_tstacct_name,
       j.l_loanclerk_name,
       j.l_invclerk_name,
       d.c_manage_type,
       d.c_manage_type_n,
       d.c_proj_type,
       d.c_proj_type_n,
       b.l_stage_id,
       b.c_stage_code,
       b.c_stage_name,
       b.l_setup_date,
       b.l_preexp_date,
       (case when b.l_setup_date < substr(a.l_month_id,1,4)||'0101' then '0' else '1' end) as c_status,
       (case when b.l_setup_date < substr(a.l_month_id,1,4)||'0101' then '´æÐø' else 'ÐÂÔö' end) as c_status_name,
       g.f_balance_agg,
       f.f_xtgdbc_no_share,
       f.f_xtfdbc_no_share,
       f.f_xtbc_no_share,
       f.f_xtbcfx,
       f.f_zyfx,
       f.f_xtbc,
       f.f_xtbc_new,
       f.f_xtcgf_no_share,
       f.f_xtcgffx,
       f.f_xtcgf,
       f.f_xtcgf_new,
       f.f_xtdlzf,
       f.f_tzsr,
       f.f_kpi_xtbc_no_share,
       f.f_kpi_xtcgf_no_share,
       f.f_kpi_xtbc,
       f.f_kpi_xtcgf,
       f.f_kpi_xtsr,
       f.f_kpi_xtsr_new,
       h.f_divide_rate as p_rate,
       i.f_divide_rate as s_rate
  from temp_main            a,
       dim_sr_stage         b,
       dim_pb_project_basic c,
       dim_pb_project_biz   d,
       DIM_PB_EMPLOYEE      e,
       temp_revenue         f,
       temp_scale           g,
       temp_proj_rate       h,
       temp_stage_rate      i,
       v_project_rules      j
 where a.l_stage_id = b.l_stage_id(+)
   and a.l_proj_id = c.l_proj_id
   and c.l_proj_id = d.l_proj_id
   and a.l_object_id = e.l_emp_id
   and a.l_proj_id = j.l_proj_id
   and a.l_proj_id = f.l_proj_id(+)
   and a.l_stage_id = f.l_stage_id(+)
   and a.l_object_id = f.l_object_id(+)
   and a.l_month_id = f.l_month_id(+)
   and a.l_proj_id = g.l_proj_id(+)
   and a.l_stage_id = g.l_stage_id(+)
   and a.l_object_id = g.l_object_id(+)
   and a.l_month_id = g.l_month_id(+)
   and a.l_proj_id = h.l_proj_id(+)
   and a.l_object_id = h.l_object_id(+)
   and a.l_month_id = h.l_month_id(+)
   and a.l_proj_id = i.l_proj_id(+)
   and a.l_stage_id = i.l_stage_id(+)
   and a.l_object_id = i.l_object_id(+)
   and a.l_month_id = i.l_month_id(+)
   and substr(nvl(b.l_setup_date,c.l_setup_date),1,6) <= a.l_month_id
   and d.c_Busi_Scope in (0,1, 2);
