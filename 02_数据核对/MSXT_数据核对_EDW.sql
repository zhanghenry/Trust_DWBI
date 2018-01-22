--收入-项目-日
select e.c_proj_code as c_grain,sum(a.f_planned_eoy) as f_value
  from dataedw.tt_sr_ie_stage_d     a,
       dataedw.dim_pb_ie_type       c,
       dataedw.dim_pb_ie_status     d,
       dataedw.dim_pb_project_basic e,
       dataedw.dim_pb_project_biz   f
 where a.l_day_id = 20170824
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and d.l_recog_flag = 0
   and a.l_proj_id = e.l_proj_id
   and e.l_proj_id = f.l_proj_id
   and (c.c_ietype_code_l1 in ('XTSR', 'TZSR') or c.c_ietype_code_l2 = 'XTYXFY')
   and e.l_effective_date <= a.l_day_id
   and e.l_expiration_date > a.l_day_id
   and e.l_setup_date <= a.l_day_id
   group by e.c_proj_code;

--收入-项目-月
select e.c_proj_code as c_grain, sum(a.f_planned_eoy) as f_value
  from dataedw.tt_sr_ie_stage_m     a,
       dataedw.dim_sr_stage         b,
       dataedw.dim_pb_ie_type       c,
       dataedw.dim_pb_ie_status     d,
       dataedw.dim_pb_project_basic e
 where a.l_month_id = 201706
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and d.l_recog_flag = 0
   and a.l_proj_id = e.l_proj_id
   and a.l_stage_id = b.l_stage_id(+)
   and (c.c_ietype_code_l1 in ('XTSR', 'TZSR') or
       c.c_ietype_code_l2 = 'XTYXFY')
   and ((substr(b.l_effective_date, 1, 6) <= a.l_month_id and
       substr(b.l_expiration_date, 1, 6) > a.l_month_id and
       substr(b.l_setup_date, 1, 6) <= a.l_month_id) or
       b.l_stage_id is null)
 group by e.c_proj_code;

--收入-信托收入-期次-日
select  b.c_stage_code as c_grain,
sum(case when c.c_ietype_code_l1 = 'XTSR' then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_planned_eoy * -1 else 0 end) as f_value
  from dataedw.tt_sr_ie_stage_d a,
       dataedw.dim_sr_stage b,
       dataedw.dim_pb_ie_type   c,
       dataedw.dim_pb_ie_status d
 where a.l_day_id = 20170731
   and a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and d.l_recog_flag = 0
   and b.l_setup_date <= a.l_day_id
   and b.l_effective_date <= a.l_day_id
   and b.l_expiration_date > a.l_day_id
   group by b.c_stage_code;

--收入-信托收入-期次-月
select  b.c_stage_code as c_grain,
sum(case when c.c_ietype_code_l1 = 'XTSR' then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_planned_eoy * -1 else 0 end) as f_value
  from dataedw.tt_sr_ie_stage_m a,
       dataedw.dim_sr_stage b,
       dataedw.dim_pb_ie_type   c,
       dataedw.dim_pb_ie_status d
 where a.l_month_id = 201707
   and a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and d.l_recog_flag = 0
   and substr(b.l_setup_date,1,6) <= a.l_month_id
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
   group by b.c_stage_code;
   
--收入-自营收入-日
select e.c_proj_code as c_grain, sum(a.f_planned_eoy) as f_value
  from dataedw.tt_sr_ie_stage_d     a,
       dataedw.dim_pb_ie_type       c,
       dataedw.dim_pb_ie_status     d,
       dataedw.dim_pb_project_basic e,
       dataedw.dim_pb_project_biz   f
 where a.l_day_id = 20170731
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and d.l_recog_flag = 0
   and a.l_proj_id = e.l_proj_id
   and e.l_proj_id = f.l_proj_id
   and c.c_ietype_code_l1 = 'TZSR'
   and e.l_setup_date <= a.l_day_id
   and e.l_effective_date <= a.l_day_id
   and e.l_expiration_date > a.l_day_id
 group by e.c_proj_code;   
   
--收入-自营收入-月
select e.c_proj_code as c_grain, sum(a.f_planned_eoy) as f_value
  from dataedw.tt_sr_ie_stage_m     a,
       dataedw.dim_pb_ie_type       c,
       dataedw.dim_pb_ie_status     d,
       dataedw.dim_pb_project_basic e,
       dataedw.dim_pb_project_biz   f
 where a.l_month_id = 201707
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and d.l_recog_flag = 0
   and a.l_proj_id = e.l_proj_id
   and e.l_proj_id = f.l_proj_id
   and c.c_ietype_code_l1 = 'TZSR'
   and substr(e.l_setup_date,1,6) <= a.l_month_id
   and substr(e.l_effective_date, 1, 6) <= a.l_month_id
   and substr(e.l_expiration_date, 1, 6) > a.l_month_id
 group by e.c_proj_code;
 
--收入-信托新增-日
select  b.c_stage_code as c_grain,
sum(case when c.c_ietype_code_l1 = 'XTSR' then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_planned_eoy * -1 else 0 end ) as f_value
  from dataedw.tt_sr_ie_stage_d a,
       dataedw.dim_sr_stage b,
       dataedw.dim_pb_ie_type   c,
       dataedw.dim_pb_ie_status d,
       dataedw.dim_pb_project_basic e,
       dataedw.dim_pb_project_biz f
 where a.l_day_id = 20170731
   and a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and d.l_recog_flag = 0
   and a.l_proj_id = e.l_proj_id
   and e.l_proj_id = f.l_proj_id
   and b.l_setup_date <= a.l_day_id 
   and substr(b.l_setup_date,1,4) = substr(a.l_day_id,1,4)
   and b.l_effective_date <= a.l_day_id
   and b.l_expiration_date > a.l_day_id
   group by b.c_stage_code; 
 
--收入-信托新增-月
select  b.c_stage_code as c_grain,
sum(case when c.c_ietype_code_l1 = 'XTSR' then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_planned_eoy * -1 else 0 end ) as f_value
  from dataedw.tt_sr_ie_stage_m a,
       dataedw.dim_sr_stage b,
       dataedw.dim_pb_ie_type   c,
       dataedw.dim_pb_ie_status d,
       dataedw.dim_pb_project_basic e,
       dataedw.dim_pb_project_biz f
 where a.l_month_id = 201707
   and a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and d.l_recog_flag = 0
   and a.l_proj_id = e.l_proj_id
   and e.l_proj_id = f.l_proj_id
   and substr(b.l_setup_date,1,6) <= a.l_month_id
   and substr(b.l_setup_date,1,4) = substr(a.l_month_id,1,4)
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
   group by b.c_stage_code;

--分成后收入-日-部门-期次
select b.c_stage_code as c_grain,sum(case when c.c_ietype_code_l2 in ('XTBC','XTCGF') then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_planned_eoy * -1 else 0 end) as f_value
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
   and a.l_day_id = 20170731 group by b.c_stage_code;

--分成后收入-日-员工-期次
select b.c_stage_code as c_grain,sum(case when c.c_ietype_code_l2 in ('XTBC','XTCGF') then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_planned_eoy * -1 else 0 end) as f_value
  from dataedw.tt_pe_ie_stage_d  a,
       dataedw.dim_sr_stage      b,
       dataedw.dim_pb_ie_type    c,
       dataedw.dim_pb_employee   d,
       dataedw.dim_pb_ie_status  e
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.c_object_type = 'YG'
   and a.l_object_id = d.l_emp_id
   and a.l_iestatus_id = e.l_iestatus_id
   and b.l_setup_date <= a.l_day_id
   and e.l_recog_flag = 0
   and a.l_day_id = 20170731 group by b.c_stage_code;

--规模-时点-日
select d.c_stage_code as c_grain, sum(a.f_balance_agg) as f_value
  from dataedw.tt_sr_scale_stage_d  a,
       dataedw.dim_pb_project_basic b,
       dataedw.dim_pb_project_biz   c,
       dataedw.dim_sr_stage         d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_stage_id = d.l_stage_id
   and a.l_day_id = 20170731
   and b.l_effective_date <= a.l_day_id
   and b.l_expiration_date > a.l_day_id
 group by d.c_stage_code;

--规模-时点-月
select d.c_stage_code as c_grain, sum(a.f_balance_agg) as f_value
  from dataedw.tt_sr_scale_stage_m  a,
       dataedw.dim_pb_project_basic b,
       dataedw.dim_pb_project_biz   c,
       dataedw.dim_sr_stage         d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_stage_id = d.l_stage_id
   and a.l_month_id = 201707
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by d.c_stage_code;
 
--规模-信托-日
select d.c_stage_code as c_grain, sum(a.f_balance_agg) as f_value
  from dataedw.tt_sr_scale_stage_d  a,
       dataedw.dim_pb_project_basic b,
       dataedw.dim_pb_project_biz   c,
       dataedw.dim_sr_stage         d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_stage_id = d.l_stage_id
   and c.c_busi_scope = '1'
   and a.l_day_id = 20170731
   and b.l_effective_date <= a.l_day_id
   and b.l_expiration_date > a.l_day_id
 group by d.c_stage_code; 
 
--规模-信托-月
select d.c_stage_code as c_grain, sum(a.f_balance_agg) as f_value
  from dataedw.tt_sr_scale_stage_m  a,
       dataedw.dim_pb_project_basic b,
       dataedw.dim_pb_project_biz   c,
       dataedw.dim_sr_stage         d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_stage_id = d.l_stage_id
   and c.c_busi_scope = '1'
   and a.l_month_id = 201707
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by d.c_stage_code;
 
--规模-基金-日
select d.c_stage_code as c_grain, sum(a.f_balance_agg) as f_value
  from dataedw.tt_sr_scale_stage_d  a,
       dataedw.dim_pb_project_basic b,
       dataedw.dim_pb_project_biz   c,
       dataedw.dim_sr_stage         d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_stage_id = d.l_stage_id
   and c.c_busi_scope = '2'
   and a.l_day_id = 20170731
   and b.l_effective_date <= a.l_day_id
   and b.l_expiration_date > a.l_day_id
 group by d.c_stage_code; 
 
--规模-基金-月
select d.c_stage_code as c_grain, sum(a.f_balance_agg) as f_value
  from dataedw.tt_sr_scale_stage_m  a,
       dataedw.dim_pb_project_basic b,
       dataedw.dim_pb_project_biz   c,
       dataedw.dim_sr_stage         d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_stage_id = d.l_stage_id
   and c.c_busi_scope = '2'
   and a.l_month_id = 201707
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by d.c_stage_code;

--规模-主动-日
select d.c_stage_code as c_grain, sum(a.f_balance_agg) as f_value
  from dataedw.tt_sr_scale_stage_d  a,
       dataedw.dim_pb_project_basic b,
       dataedw.dim_pb_project_biz   c,
       dataedw.dim_sr_stage         d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_stage_id = d.l_stage_id
   and c.c_manage_type = '1'
   and a.l_day_id = 20170731
   and b.l_effective_date <= a.l_day_id
   and b.l_expiration_date > a.l_day_id
 group by d.c_stage_code;
   
--规模-主动-月
select d.c_stage_code as c_grain, sum(a.f_balance_agg) as f_value
  from dataedw.tt_sr_scale_stage_m  a,
       dataedw.dim_pb_project_basic b,
       dataedw.dim_pb_project_biz   c,
       dataedw.dim_sr_stage         d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_stage_id = d.l_stage_id
   and c.c_manage_type = '1'
   and a.l_month_id = 201707
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by d.c_stage_code;

--规模-被动-日
select d.c_stage_code as c_grain, sum(a.f_balance_agg) as f_value
  from dataedw.tt_sr_scale_stage_d  a,
       dataedw.dim_pb_project_basic b,
       dataedw.dim_pb_project_biz   c,
       dataedw.dim_sr_stage         d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_stage_id = d.l_stage_id
   and c.c_manage_type <> '1'
   and a.l_day_id = 20170731
   and b.l_effective_date <= a.l_day_id
   and b.l_expiration_date > a.l_day_id
 group by d.c_stage_code;
 
--规模-被动-月
select d.c_stage_code as c_grain, sum(a.f_balance_agg) as f_value
  from dataedw.tt_sr_scale_stage_m  a,
       dataedw.dim_pb_project_basic b,
       dataedw.dim_pb_project_biz   c,
       dataedw.dim_sr_stage         d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_stage_id = d.l_stage_id
   and c.c_manage_type <> '1'
   and a.l_month_id = 201707
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by d.c_stage_code;

--分成后规模-时点-部门-期次
select b.c_stage_code as c_grain,sum(a.f_scale_agg) as f_value
  from dataedw.tt_pe_scale_stage_d  a,
       dataedw.dim_sr_stage      b,
       dataedw.dim_pb_department d
 where a.l_stage_id = b.l_stage_id
   and a.c_object_type = 'BM'
   and a.l_object_id = d.l_dept_id
   and a.l_day_id = 20170823
   and b.l_setup_date <= a.l_day_id
   and d.l_effective_date <= a.l_day_id
   and d.l_expiration_date > a.l_day_id
   group by b.c_stage_code;
   
--分成后规模-时点-部门-员工
select b.c_stage_code as c_grain,sum(a.f_scale_agg) as f_value
  from dataedw.tt_pe_scale_stage_d  a,
       dataedw.dim_sr_stage      b,
       dataedw.dim_pb_employee d
 where a.l_stage_id = b.l_stage_id
   and a.c_object_type = 'YG'
   and a.l_object_id = d.l_emp_id
   and a.l_day_id = 20170731
   and b.l_setup_date <= a.l_day_id
   and d.l_effective_date <= a.l_day_id
   and d.l_expiration_date > a.l_day_id
   group by b.c_stage_code;
 
--弹性费用-部门-日
select c.c_dept_code as c_grain, sum(a.f_amount_eot) as f_value
  from dataedw.tt_fi_accounting_dept_d a,
       dataedw.dim_fi_subject          b,
       dataedw.dim_pb_department       c
 where a.l_subj_id = b.l_subj_id
   and a.l_dept_id = c.l_dept_id
   and (b.c_subj_code_l2 = '660102' or
       b.c_subj_code_l3 in ('66010301', '66010302'))
   and c.l_effective_date <= a.l_day_id
   and c.l_expiration_date > a.l_day_id
   and a.l_day_id = 20170731
 group by c.c_dept_code; 
 
--弹性费用-部门-月
select c.c_dept_code as c_grain, sum(a.f_amount_eot) as f_value
  from dataedw.tt_fi_accounting_dept_m a,
       dataedw.dim_fi_subject          b,
       dataedw.dim_pb_department       c
 where a.l_subj_id = b.l_subj_id
   and a.l_dept_id = c.l_dept_id
   and (b.c_subj_code_l2 = '660102' or
       b.c_subj_code_l3 in ('66010301', '66010302'))
   and substr(c.l_effective_date, 1, 6) <= a.l_month_id
   and substr(c.l_expiration_date, 1, 6) > a.l_month_id
   and a.l_month_id = 201708
 group by c.c_dept_code;

--公共费用-部门-日
select c.c_dept_code as c_grain, sum(a.f_amount_eot) as f_value
  from dataedw.tt_fi_accounting_dept_d a,
       dataedw.dim_fi_subject          b,
       dataedw.dim_pb_department       c
 where a.l_subj_id = b.l_subj_id
   and a.l_dept_id = c.l_dept_id
   and b.c_subj_code_l2 in ('660102','660103','660104')
   and c.c_dept_cate = '5'
   and c.l_effective_date <= a.l_day_id
   and c.l_expiration_date > a.l_day_id
   and a.l_day_id = 20170731
 group by c.c_dept_code;

--公共费用-部门-月
select c.c_dept_code as c_grain, sum(a.f_amount_eot) as f_value
  from dataedw.tt_fi_accounting_dept_m a,
       dataedw.dim_fi_subject          b,
       dataedw.dim_pb_department       c
 where a.l_subj_id = b.l_subj_id
   and a.l_dept_id = c.l_dept_id
   and b.c_subj_code_l2 in ('660102','660103','660104')
   and c.c_dept_cate = '5'
   and substr(c.l_effective_date, 1, 6) <= a.l_month_id
   and substr(c.l_expiration_date, 1, 6) > a.l_month_id
   and a.l_month_id = 201708
 group by c.c_dept_code;
 
--项目个数-项目-日
select a.c_proj_code as c_grain, count(*) as f_value
  from dataedw.dim_pb_project_basic a,dataedw.dim_pb_project_biz b
 where a.l_proj_id = b.l_proj_id 
   and a.l_effective_date <= 20170731
   and a.l_expiration_date > 20170731
   and a.l_setup_date <= 20170731
   and b.c_busi_scope <> '0'
 group by a.c_proj_code;
 
--项目个数-项目-月
select a.c_proj_code as c_grain, count(*) as f_value
  from dataedw.dim_pb_project_basic a,dataedw.dim_pb_project_biz b
 where a.l_proj_id = b.l_proj_id 
   and substr(a.l_effective_date,1,6) <= 201707
   and substr(a.l_expiration_date,1,6) > 201707
   and substr(a.l_setup_date,1,6) <= 201707
   and b.c_busi_scope <> '0'
 group by a.c_proj_code;

--期次个数-期次-日
select a.c_stage_code as c_grain, count(*) as f_value
  from dataedw.dim_sr_stage a
 where a.l_effective_date <= 20170731
   and a.l_expiration_date > 20170731
   and a.l_setup_date <= 20170731
 group by a.c_stage_code;
 
--期次个数-期次-月
select a.c_stage_code as c_grain, count(*) as f_value
  from dataedw.dim_sr_stage a
 where substr(a.l_effective_date,1,6) <= 201707
   and substr(a.l_expiration_date,1,6) > 201707
   and substr(a.l_setup_date,1,6) <= 201707
 group by a.c_stage_code;
