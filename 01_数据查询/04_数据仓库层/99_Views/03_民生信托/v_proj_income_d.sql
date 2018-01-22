create or replace view v_proj_income_d as
select t.l_day_id,
       t.l_proj_id,
       t.l_stage_id,
       t.f_new_income,
       t.f_cgf_new,
       t.f_htsr_new,
       t.f_exist_income,
       t.f_exist_cgf,
       t.f_gdbc,
       t.f_fdbc,
       t.f_cgf,
       t.f_cgf_fx,
       t.f_bc_fx,
       t.f_yxf,
       t.f_zyfx,
       t.f_xtsr,
       t.f_htsr,
       t.f_kpi_xtsr,
       t.f_kpi_xtbc,
       t.f_kpi_xtcgf,
       t.f_kpi_xtsr_new,
       t.c_stage_status,
       0 as f_tzsy
from v_stage_income_d t
--where  t.l_day_id = 20160930
union all
select a.l_day_id as l_day_id,
       a.l_proj_id as l_proj_id,
       0 as l_stage_id,
       0 as f_new_income,
       0 as f_cgf_new,
       0 as f_htsr_new,
       0 as f_exist_income,
       0 as f_exist_cgf,
       0 as f_gdbc,
       0 as f_fdbc,
       0 as f_cgf,
       0 as f_cgf_fx,
       0 as f_bc_fx,
       0 as f_yxf,
       0 as f_zyfx,
       0 as f_xtsr,
       0 as f_htsr,
       0 as f_kpi_xtsr,
       0 as f_kpi_xtbc,
       0 as f_kpi_xtcgf,
       0 as f_kpi_xtsr_new,
       null as c_stage_status,
       sum(a.f_planned_eoy) as f_tzsy
  from tt_sr_ie_stage_d a, dim_pb_project_basic b, dim_pb_project_biz c,dim_pb_ie_type d,dim_pb_ie_status e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_ietype_id = d.l_ietype_id
   and a.l_iestatus_id = e.l_iestatus_id
   and e.l_recog_flag = 0
   and d.c_ietype_code_l1 = 'TZSR'
   and c.c_busi_scope = '0'
   --and a.l_day_id = 20170828
   group by a.l_day_id,a.l_proj_id having sum(a.f_planned_eoy) <> 0;
