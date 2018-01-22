create or replace view v_tmp_jd as
select
d2.l_proj_id,
d2.c_proj_code,
d1.l_stage_id,
d1.c_stage_code,
dm.quarter_id,
sum(case when d4.c_ietype_code_l3 = 'XTGDBC' and d5.l_recog_flag = 1 then t1.f_amount else 0 end ) f_gdbc,
sum(case when d4.c_ietype_code_l3 = 'XTFDBC' and d5.l_recog_flag = 1 then t1.f_amount else 0 end ) f_fdbc,
sum(case when d4.c_ietype_code_l2 = 'XTCGF' and d5.l_recog_flag = 1 then t1.f_amount else 0 end ) f_cgf
 from tt_sr_ie_flow_d t1,dim_sr_stage d1,dim_pb_project_basic d2,
 dim_pb_project_biz d3,dim_pb_ie_type d4,dim_pb_ie_status d5,dim_month dm
where t1.l_stage_id = d1.l_stage_id
and t1.l_ietype_id = d4.l_ietype_id
and t1.l_iestatus_id = d5.l_iestatus_id
and t1.l_proj_id = d2.l_proj_id
and t1.l_proj_id = d3.l_proj_id
and substr(t1.l_change_date,0,6) = dm.month_id
and t1.l_actual_flag = 0
group by d2.l_proj_id,
d2.c_proj_code,
d1.l_stage_id,
d1.c_stage_code,
dm.quarter_id;
