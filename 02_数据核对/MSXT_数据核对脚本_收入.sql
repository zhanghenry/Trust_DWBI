--
select * from dataods.thr_dividescheme t where t.c_projectcode = 'H267';

--总收入 
select b.c_stage_code,sum(case when c.c_ietype_code_l1 = 'XTSR' then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_planned_eoy * -1 end )  as 总信托收入
  from dataedw.tt_sr_ie_stage_d  a,
       dataedw.dim_sr_stage      b,
       dataedw.dim_pb_ie_type    c,
       dataedw.dim_pb_project_biz d,
       dataedw.dim_pb_ie_status  e
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.l_proj_id = d.l_proj_id
   and a.l_iestatus_id = e.l_iestatus_id
   and e.l_recog_flag = 0
   and b.l_setup_date <= a.l_day_id
   and b.l_effective_date <= a.l_day_id
   and b.l_expiration_date > a.l_day_id
   and a.l_day_id = 20170821
 group by b.c_stage_code having sum(case when c.c_ietype_code_l1 = 'XTSR' then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_planned_eoy * -1 end ) <> 0;

select b.c_stage_code,sum(case when c.c_ietype_code_l2 in ('XTBC','XTCGF') then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_planned_eoy * -1 else 0 end) as 分成后信托收入
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
   and d.c_dept_cate = '1'
   and a.l_day_id = 20170821 group by b.c_stage_code having sum(case when c.c_ietype_code_l2 in ('XTBC','XTCGF') then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_planned_eoy * -1 else 0 end) <> 0;


--分成后收入日表与月表比较
select b.c_stage_code,sum(case when c.c_ietype_code_l2 in ('XTBC','XTCGF') then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_planned_eoy * -1 else 0 end) as 分成后信托收入
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
   and d.c_dept_cate = '1'
   and a.l_day_id = 20170821 group by b.c_stage_code having sum(case when c.c_ietype_code_l2 in ('XTBC','XTCGF') then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_planned_eoy * -1 else 0 end) <> 0;
--月表
select b.c_stage_code,sum(case when c.c_ietype_code_l2 in ('XTBC','XTCGF') then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_planned_eoy * -1 else 0 end) as 分成后信托收入
  from dataedw.tt_pe_ie_stage_m  a,
       dataedw.dim_sr_stage      b,
       dataedw.dim_pb_ie_type    c,
       dataedw.dim_pb_department d,
       dataedw.dim_pb_ie_status  e
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.c_object_type = 'BM'
   and a.l_object_id = d.l_dept_id
   and a.l_iestatus_id = e.l_iestatus_id
   and substr(b.l_setup_date,1,6) <= a.l_month_id
   and e.l_recog_flag = 0
   and d.c_dept_cate = '1'
   and a.l_month_id = 201708 group by b.c_stage_code having sum(case when c.c_ietype_code_l2 in ('XTBC','XTCGF') then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_planned_eoy * -1 else 0 end) <> 0;

--业务部门分成前规模
select b.c_stage_code,sum(a.f_balance_agg) as 分成后时点规模
  from dataedw.tt_sr_scale_stage_d  a,
       dataedw.dim_sr_stage      b
 where a.l_stage_id = b.l_stage_id
   and b.l_setup_date <= a.l_day_id
   and a.l_day_id = 20170821
   and b.l_effective_date <= a.l_day_id
   and b.l_expiration_date > a.l_day_id
   group by b.c_stage_code having sum(a.f_balance_agg) <> 0;

--业务总部分成后规模
select b.c_stage_code,sum(a.f_scale_agg) as 分成后时点规模
  from dataedw.tt_pe_scale_stage_d  a,
       dataedw.dim_sr_stage      b,
       dataedw.dim_pb_department d
 where a.l_stage_id = b.l_stage_id
   and a.c_object_type = 'BM'
   and a.l_object_id = d.l_dept_id
   and a.l_day_id = 20170821
   and d.c_dept_cate = '1'
   and b.l_setup_date <= a.l_day_id
   and d.l_effective_date <= a.l_day_id
   and d.l_expiration_date > a.l_day_id
   group by b.c_stage_code having sum(a.f_scale_agg) <> 0;
