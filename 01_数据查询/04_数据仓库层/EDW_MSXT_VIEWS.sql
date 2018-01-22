--民生信托部门分成后规模收入
create or replace view v_dept_scale_revenue_d as
with temp_main as
 (select a.l_object_id,a.l_proj_Id, a.l_divide_id as l_stage_id
    from dim_pe_divide_scheme a
   where a.c_scheme_type = 'QC'
     and a.c_object_type = 'BM'
     and a.l_effective_date <= 20161231
     and a.l_expiration_date > 20161231
  union
  select distinct a.l_object_id,a.l_proj_Id, b.l_stage_id
    from dim_pe_divide_scheme a, Tt_Pe_Ie_stage_d b, dim_pb_ie_type c
   where a.l_divide_id = b.l_proj_id
     and a.c_object_type = b.c_object_type
     and a.l_object_id = b.l_object_Id
     and b.l_ietype_id = c.l_ietype_id
     and c.c_ietype_code_l2 <> 'XTBC'
     and b.l_stage_id <> 0
     and b.l_day_id = 20161231
     and a.l_effective_date <= b.l_day_id
     and a.l_expiration_date > b.l_day_id
     and a.c_scheme_type = 'XM'
     and a.c_object_type = 'BM'),
temp_scale as
 (select t1.l_day_id,
         t1.l_proj_id,
         t1.l_stage_id,
         t1.l_object_id,
         sum(t1.f_scale_agg) as f_scale_agg
    from tt_pe_scale_stage_d t1
   where t1.c_object_type = 'BM'
     and t1.l_day_id = 20161231
   group by t1.l_day_id, t1.l_proj_id, t1.l_stage_id, t1.l_object_id),
temp_revenue as
 (select t2.l_day_id, t2.l_proj_id, t2.l_stage_id, t2.l_object_id, 
     sum(case when t21.c_ietype_code = 'XTGDBC' then t2.f_planned_eoy else 0 end) as f_xtgdbc,
     sum(case when t21.c_ietype_code = 'XTFDBC' then t2.f_planned_eoy else 0 end) as f_xtfdbc,
     sum(case when t21.c_ietype_code = 'XTDLZF' then t2.f_planned_eoy else 0 end) as f_xtdlzf,
     SUM(CASE WHEN t21.c_ietype_code_l2 = 'XTBC' THEN t2.f_planned_eoy when t21.c_ietype_code in ('XTFXBC', 'TZZYFX') then t2.f_planned_eoy * -1 else 0 end) AS f_xtbc_minus,
     SUM(CASE WHEN t21.c_ietype_code_l2 = 'XTCGF' THEN t2.f_planned_eoy  when t21.c_ietype_code in ('XTFXCGF') then t2.f_planned_eoy * -1 else 0 end) AS f_xtcgf_minus,
     SUM(CASE WHEN t21.c_ietype_code_l2 = 'XTBC' THEN t2.f_planned_eoy else 0 end) AS f_xtbc,
     SUM(CASE WHEN t21.c_ietype_code = 'XTFXBC' THEN t2.f_planned_eoy ELSE 0 END) AS f_xtbcfx,
     SUM(CASE WHEN t21.c_ietype_code_l2 = 'XTCGF' THEN t2.f_planned_eoy ELSE 0 END) AS f_xtcgf,
     SUM(CASE WHEN t21.c_ietype_code = 'XTFXCGF' THEN t2.f_planned_eoy ELSE 0 END) AS f_xtcgffx,
     SUM(CASE WHEN t21.c_ietype_code = 'TZZYFX' THEN t2.f_planned_eoy ELSE 0 END) AS f_zyfx,
     SUM(CASE WHEN t21.c_ietype_code = 'TZSR' THEN t2.f_planned_eoy ELSE 0 END) AS f_tzsr,
     sum(case when t21.c_ietype_code_l1 = 'XTSR' and t23.l_setup_date <= substr(t2.l_day_id,1,4) * 10000 + trunc(substr(t2.l_day_id,5,2)/3) * 300 + 31
              then t2.f_planned_eoy else 0 end) as f_kpi_xtsr,
     sum(case when t21.c_ietype_code_l2 = 'XTBC' and t23.l_setup_date <= substr(t2.l_day_id,1,4) * 10000 + trunc(substr(t2.l_day_id,5,2)/3) * 300 + 31
              then t2.f_planned_eoy else 0 end) as f_kpi_xtbc,
     sum(case when t21.c_ietype_code_l2 = 'XTCGF' and t23.l_setup_date <= substr(t2.l_day_id,1,4) * 10000 + trunc(substr(t2.l_day_id,5,2)/3) * 300 + 31
              then t2.f_planned_eoy else 0 end) as f_kpi_xtcgf,
     sum(case when t21.c_ietype_code_l1 = 'XTSR' and t23.l_setup_date >= substr(t2.l_day_id,1,4)||'0101' and t23.l_setup_date <= substr(t2.l_day_id,1,4) * 10000 + trunc(substr(t2.l_day_id,5,2)/3) * 300 + 31
              then t2.f_planned_eoy else 0 end) as f_kpi_xtsr_new
    from tt_pe_ie_stage_d t2,dim_pb_ie_type t21,dim_pb_ie_status t22,dim_sr_stage t23
   where t2.l_ietype_id = t21.l_ietype_id
     and t2.l_iestatus_id = t22.l_iestatus_id
     and t2.l_stage_id = t23.l_stage_id(+)
     and t22.l_recog_flag = 0
     and t2.c_object_type = 'BM'
     and t2.l_day_id = 20161231
   group by t2.l_day_id, t2.l_proj_id, t2.l_stage_id, t2.l_object_id),
temp_proj_rate as
 (select t3.l_object_id,t3.l_proj_id,t3.f_divide_rate
    from dim_pe_divide_scheme t3
   where t3.c_scheme_type = 'XM'
     and t3.c_object_type = 'BM'
     and t3.l_effective_date <= 20161231
     and t3.l_expiration_date > 20161231),
temp_stage_rate as
 (select t4.l_object_id,t4.l_proj_id,t4.l_divide_id as l_stage_id,t4.f_divide_rate
    from dim_pe_divide_scheme t4
   where t4.c_scheme_type = 'QC'
     and t4.c_object_type = 'BM'
     and t4.l_effective_date <= 20161231
     and t4.l_expiration_date > 20161231)
select e.l_dept_id,
       e.c_dept_code,
       e.c_dept_name,
       c.l_proj_id,
       c.c_proj_code,
       d.c_manage_type,
       d.c_manage_type_n,
       d.c_proj_type,
       d.c_proj_type_n,
       b.l_stage_id,
       b.c_stage_code,
       b.c_stage_name,
       b.l_setup_date,
       b.l_preexp_date,
       (case when b.l_setup_date < substr(20161231,1,4)||'0101' then '0' when b.l_setup_date = substr(20161231,1,4)||'0101' then '1' else null end) as c_status,
       (case when b.l_setup_date < substr(20161231,1,4)||'0101' then '存续' when b.l_setup_date = substr(20161231,1,4)||'0101' then '新增' else null end) as c_status_name,
       g.f_scale_agg as f_scale_eot,
       f.f_xtgdbc,
       f.f_xtfdbc,
       f.f_xtdlzf,
       f.f_xtbc,
       f.f_xtcgf,
       f.f_xtbc_minus,
       f.f_xtcgf_minus,
       f.f_xtbcfx,
       f.f_xtcgffx,
       f.f_zyfx,
       f.f_tzsr,
       f.f_kpi_xtsr,
       f.f_kpi_xtbc,
       f.f_kpi_xtcgf,
       f.f_kpi_xtsr_new,
       h.f_divide_rate as p_rate,
       i.f_divide_rate as s_rate
  from temp_main            a,
       dim_sr_stage         b,
       dim_pb_project_basic c,
       dim_pb_project_biz   d,
       dim_pb_department    e,
       temp_revenue         f,
       temp_scale           g,
       temp_proj_rate       h,
       temp_stage_rate      i
 where a.l_stage_id = b.l_stage_id(+)
   and a.l_proj_id = c.l_proj_id
   and c.l_proj_id = d.l_proj_id
   and a.l_object_id = e.l_dept_id
   and a.l_stage_id = f.l_stage_id(+)
   and a.l_object_id = f.l_object_id(+)
   and a.l_stage_id = g.l_stage_id(+)
   and a.l_object_id = g.l_object_id(+)
   and a.l_proj_id = h.l_proj_id(+)
   and a.l_object_id = h.l_object_id(+)
   and a.l_stage_id = i.l_stage_id(+)
   and a.l_object_id = i.l_object_id(+)
   and d.c_Busi_Scope in (1, 2);
   
--民生信托员工分成后规模收入
create or replace view v_emp_scale_revenue_d as
with temp_main as
 (select a.l_object_id,a.l_proj_Id, a.l_divide_id as l_stage_id
    from dim_pe_divide_scheme a
   where a.c_scheme_type = 'QC'
     and a.c_object_type = 'YG'
     and a.l_effective_date <= 20161231
     and a.l_expiration_date > 20161231
  union
  select distinct a.l_object_id,a.l_proj_Id, b.l_stage_id
    from dim_pe_divide_scheme a, Tt_Pe_Ie_stage_d b, dim_pb_ie_type c
   where a.l_divide_id = b.l_proj_id
     and a.c_object_type = b.c_object_type
     and a.l_object_id = b.l_object_Id
     and b.l_ietype_id = c.l_ietype_id
     and c.c_ietype_code_l2 <> 'XTBC'
     and b.l_stage_id <> 0
     and b.l_day_id = 20161231
     and a.l_effective_date <= b.l_day_id
     and a.l_expiration_date > b.l_day_id
     and a.c_scheme_type = 'XM'
     and a.c_object_type = 'YG'),
temp_scale as
 (select t1.l_day_id,
         t1.l_proj_id,
         t1.l_stage_id,
         t1.l_object_id,
         sum(t1.f_scale_agg) as f_scale_agg
    from tt_pe_scale_stage_d t1
   where t1.c_object_type = 'YG'
     and t1.l_day_id = 20161231
   group by t1.l_day_id, t1.l_proj_id, t1.l_stage_id, t1.l_object_id),
temp_revenue as
 (select t2.l_day_id, t2.l_proj_id, t2.l_stage_id, t2.l_object_id, 
     sum(case when t21.c_ietype_code = 'XTGDBC' then t2.f_planned_eoy else 0 end) as f_xtgdbc,
     sum(case when t21.c_ietype_code = 'XTFDBC' then t2.f_planned_eoy else 0 end) as f_xtfdbc,
     sum(case when t21.c_ietype_code = 'XTDLZF' then t2.f_planned_eoy else 0 end) as f_xtdlzf,
     SUM(CASE WHEN t21.c_ietype_code_l2 = 'XTBC' THEN t2.f_planned_eoy when t21.c_ietype_code in ('XTFXBC', 'TZZYFX') then t2.f_planned_eoy * -1 else 0 end) AS f_xtbc_minus,
     SUM(CASE WHEN t21.c_ietype_code_l2 = 'XTCGF' THEN t2.f_planned_eoy  when t21.c_ietype_code in ('XTFXCGF') then t2.f_planned_eoy * -1 else 0 end) AS f_xtcgf_minus,
     SUM(CASE WHEN t21.c_ietype_code_l2 = 'XTBC' THEN t2.f_planned_eoy else 0 end) AS f_xtbc,
     SUM(CASE WHEN t21.c_ietype_code = 'XTFXBC' THEN t2.f_planned_eoy ELSE 0 END) AS f_xtbcfx,
     SUM(CASE WHEN t21.c_ietype_code_l2 = 'XTCGF' THEN t2.f_planned_eoy ELSE 0 END) AS f_xtcgf,
     SUM(CASE WHEN t21.c_ietype_code = 'XTFXCGF' THEN t2.f_planned_eoy ELSE 0 END) AS f_xtcgffx,
     SUM(CASE WHEN t21.c_ietype_code = 'TZZYFX' THEN t2.f_planned_eoy ELSE 0 END) AS f_zyfx,
     SUM(CASE WHEN t21.c_ietype_code = 'TZSR' THEN t2.f_planned_eoy ELSE 0 END) AS f_tzsr,
     sum(case when t21.c_ietype_code_l1 = 'XTSR' and t23.l_setup_date <= substr(t2.l_day_id,1,4) * 10000 + trunc(substr(t2.l_day_id,5,2)/3) * 300 + 31
              then t2.f_planned_eoy else 0 end) as f_kpi_xtsr,
     sum(case when t21.c_ietype_code_l2 = 'XTBC' and t23.l_setup_date <= substr(t2.l_day_id,1,4) * 10000 + trunc(substr(t2.l_day_id,5,2)/3) * 300 + 31
              then t2.f_planned_eoy else 0 end) as f_kpi_xtbc,
     sum(case when t21.c_ietype_code_l2 = 'XTCGF' and t23.l_setup_date <= substr(t2.l_day_id,1,4) * 10000 + trunc(substr(t2.l_day_id,5,2)/3) * 300 + 31
              then t2.f_planned_eoy else 0 end) as f_kpi_xtcgf,
     sum(case when t21.c_ietype_code_l1 = 'XTSR' and t23.l_setup_date >= substr(t2.l_day_id,1,4)||'0101' and t23.l_setup_date <= substr(t2.l_day_id,1,4) * 10000 + trunc(substr(t2.l_day_id,5,2)/3) * 300 + 31
              then t2.f_planned_eoy else 0 end) as f_kpi_xtsr_new
    from tt_pe_ie_stage_d t2,dim_pb_ie_type t21,dim_pb_ie_status t22,dim_sr_stage t23
   where t2.l_ietype_id = t21.l_ietype_id
     and t2.l_iestatus_id = t22.l_iestatus_id
     and t2.l_stage_id = t23.l_stage_id(+)
     and t22.l_recog_flag = 0
     and t2.c_object_type = 'YG'
     and t2.l_day_id = 20161231
   group by t2.l_day_id, t2.l_proj_id, t2.l_stage_id, t2.l_object_id),
temp_proj_rate as
 (select t3.l_object_id,t3.l_proj_id,t3.f_divide_rate
    from dim_pe_divide_scheme t3
   where t3.c_scheme_type = 'XM'
     and t3.c_object_type = 'YG'
     and t3.l_effective_date <= 20161231
     and t3.l_expiration_date > 20161231),
temp_stage_rate as
 (select t4.l_object_id,t4.l_proj_id,t4.l_divide_id as l_stage_id,t4.f_divide_rate
    from dim_pe_divide_scheme t4
   where t4.c_scheme_type = 'QC'
     and t4.c_object_type = 'YG'
     and t4.l_effective_date <= 20161231
     and t4.l_expiration_date > 20161231)
select e.l_emp_id,
       e.c_emp_code,
       e.c_emp_name,
       c.l_proj_id,
       c.c_proj_code,
       d.c_manage_type,
       d.c_manage_type_n,
       d.c_proj_type,
       d.c_proj_type_n,
       b.l_stage_id,
       b.c_stage_code,
       b.c_stage_name,
       b.l_setup_date,
       b.l_preexp_date,
       (case when b.l_setup_date < substr(20161231,1,4)||'0101' then '0' when b.l_setup_date = substr(20161231,1,4)||'0101' then '1' else null end) as c_status,
       (case when b.l_setup_date < substr(20161231,1,4)||'0101' then '存续' when b.l_setup_date = substr(20161231,1,4)||'0101' then '新增' else null end) as c_status_name,
       g.f_scale_agg as f_scale_eot,
       f.f_xtgdbc,
       f.f_xtfdbc,
       f.f_xtdlzf,
       f.f_xtbc,
       f.f_xtcgf,
       f.f_xtbc_minus,
       f.f_xtcgf_minus,
       f.f_xtbcfx,
       f.f_xtcgffx,
       f.f_zyfx,
       f.f_tzsr,
       f.f_kpi_xtsr,
       f.f_kpi_xtbc,
       f.f_kpi_xtcgf,
       f.f_kpi_xtsr_new,
       h.f_divide_rate as p_rate,
       i.f_divide_rate as s_rate
  from temp_main            a,
       dim_sr_stage         b,
       dim_pb_project_basic c,
       dim_pb_project_biz   d,
       DIM_PB_EMPLOYEE    e,
       temp_revenue         f,
       temp_scale           g,
       temp_proj_rate       h,
       temp_stage_rate      i
 where a.l_stage_id = b.l_stage_id(+)
   and a.l_proj_id = c.l_proj_id
   and c.l_proj_id = d.l_proj_id
   and a.l_object_id = e.l_emp_id
   and a.l_stage_id = f.l_stage_id(+)
   and a.l_object_id = f.l_object_id(+)
   and a.l_stage_id = g.l_stage_id(+)
   and a.l_object_id = g.l_object_id(+)
   and a.l_proj_id = h.l_proj_id(+)
   and a.l_object_id = h.l_object_id(+)
   and a.l_stage_id = i.l_stage_id(+)
   and a.l_object_id = i.l_object_id(+)
   and d.c_Busi_Scope in (1, 2);
