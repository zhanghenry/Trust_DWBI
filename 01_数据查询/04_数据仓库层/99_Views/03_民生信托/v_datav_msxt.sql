create or replace view v_datav_msxt as
with temp_scale as
 (select t.l_proj_id, sum(t.f_balance_agg) as f_scale
    from tt_sr_scale_stage_d t
   where t.l_day_id = 20171227
   group by t.l_proj_id),
temp_ie as
 (select t2.l_proj_id,
         sum(case
               when t21.c_ietype_code_l1 in ('XTSR', 'TZSR') then
                t2.f_planned_eoy
               when t21.c_ietype_code in ('XTFXBC', 'XTFXCGF', 'TZZYFX') then
                t2.f_planned_eoy * -1
               else
                0
             end) as f_ie
    from tt_sr_ie_stage_d     t2,
         dim_pb_ie_type       t21,
         dim_pb_ie_status     t22,
         dim_sr_stage         t23,
         dim_pb_project_basic t24
   where t2.l_ietype_id = t21.l_ietype_id
     and t2.l_iestatus_id = t22.l_iestatus_id
     and t2.l_stage_id = t23.l_stage_id(+)
     and t2.l_proj_id = t24.l_proj_id
     and t22.l_recog_flag = 0
     and nvl(t23.l_setup_date, t24.l_setup_date) <= t2.l_day_id
     and t2.l_day_id = 20171227
   group by t2.l_proj_id)
select a.l_proj_id,
       a.l_setup_date,
       a.l_preexp_date,
       a.l_expiry_date,
       c.c_dept_name,
       c.c_dept_code_l1,
       c.c_dept_name_l1,
       b.c_busi_scope_n,
       b.c_proj_type_n,
       b.c_manage_type_n,
       b.c_coop_type_n,
       b.c_func_type_n,
       b.c_special_type_n,
       d.c_prov_name,
       e.f_scale,
       f.f_ie
  from dim_pb_project_basic a,
       dim_pb_project_biz   b,
       dim_pb_department    c,
       dim_pb_area          d,
       temp_scale           e,
       temp_ie              f
 where a.l_proj_id = b.l_proj_id
   and a.l_dept_id = c.l_dept_id
   and a.l_effective_flag = 1
   and b.l_fduse_area = d.l_area_id(+)
   and a.l_proj_id = e.l_proj_id(+)
   and a.l_proj_id = f.l_proj_id(+)
   and b.c_busi_scope in ('1', '2');
