create or replace view v_msxt_dept_summary as
select a.l_month_id,
       a.l_object_id as l_dept_id,
       case when substr(b.l_setup_date,1,4) = substr(a.l_month_id,1,4) then 'NEW' else 'EXIST' end as c_status,
       sum(case
            when e.c_dept_type = '0' and c.c_ietype_code_l1 = 'XTSR' then a.f_planned_eoy
            when e.c_dept_type = '0' and c.c_ietype_code = 'TZZYFX' and a.l_stage_id <> 0 then a.f_planned_eoy*-1
            when e.c_dept_type = '1' and c.c_ietype_code_l1 = 'TZSR' then a.f_planned_eoy
            when e.c_dept_type = '2' and c.c_ietype_code_l2 = 'XTYXFY' then a.f_planned_eoy
       else 0
       end)as f_income
  from tt_pe_ie_stage_m a,
       dim_sr_stage     b,
       dim_pb_ie_type   c,
       dim_pb_ie_status d,
       dim_pb_department e,
       dim_pb_project_basic f
 where a.l_stage_id = b.l_stage_id(+)
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and a.l_object_id = e.l_dept_id
   and a.l_proj_id = f.l_proj_id
   and substr(b.l_setup_date,1,6) <= a.l_month_id
   and d.l_recog_flag = 0
   and a.c_object_type = 'BM'
   and substr(f.l_effective_date,1,6) <= a.l_month_id
   and substr(f.l_expiration_date,1,6) > a.l_month_id
   group by a.l_month_id,a.l_object_id,case when substr(b.l_setup_date,1,4) = substr(a.l_month_id,1,4) then 'NEW' else 'EXIST' end;
