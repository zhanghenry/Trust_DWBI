create or replace view v_stage_income_d as
select
       d6.l_dayid as l_day_id,
       d7.l_proj_id,
       d7.l_stage_id,
       --new
       sum(case when d1.c_ietype_code_l2 ='XTBC' and substr(d3.l_setup_date,1,4) = d6.year_id then t1.f_amount else 0 end) f_new_income,
       sum(case when d1.c_ietype_code_l2 in ('XTCGF') and substr(d3.l_setup_date,1,4) = d6.year_id then t1.f_amount else 0 end) f_cgf_new,
       sum(case when (d1.c_ietype_code_l1 = 'XTSR' or d1.c_ietype_code = 'XTDLZF') and substr(d3.l_setup_date,1,4) = d6.year_id then t1.f_amount else 0 end) f_htsr_new,--合同新增收入
       --exist
       sum(case when d1.c_ietype_code_l2 ='XTBC' and substr(d3.l_setup_date,1,4) < d6.year_id then t1.f_amount else 0 end) f_exist_income,
       sum(case when d1.c_ietype_code_l2 = 'XTCGF' and substr(d3.l_setup_date,1,4) < d6.year_id then t1.f_amount else 0 end) f_exist_cgf,
       --new+exist
       sum(case  when d1.c_ietype_code in ('XTGDBC')  then t1.f_amount else 0 end) f_gdbc,
       sum(case when d1.c_ietype_code in ('XTFDBC') then t1.f_amount else 0 end) f_fdbc,
       sum(case when d1.c_ietype_code_l2 in ('XTCGF') then t1.f_amount else 0 end) f_cgf,
       sum(case when d1.c_ietype_code in ('XTFXCGF') then t1.f_amount else 0 end) f_cgf_fx,
       sum(case when d1.c_ietype_code = 'XTFXBC' then t1.f_amount else 0 end) f_bc_fx,
       sum(case when d1.c_ietype_code_l2 in ('XTYXFY') then t1.f_amount else 0 end) f_yxf,
       sum(case when d1.c_ietype_code = 'TZZYFX' then t1.f_amount else 0 end) f_zyfx,
       sum(case when d1.c_ietype_code_l1 = 'XTSR' then t1.f_amount else 0 end) as f_xtsr,
       sum(case when d1.c_ietype_code_l1 = 'XTSR' or d1.c_ietype_code = 'XTDLZF' then t1.f_amount else 0 end) as f_htsr,--合同收入
       sum(case when d1.c_ietype_code_l1 = 'XTSR'  and d3.l_setup_date <= substr(d6.l_dayid,1,4) * 10000 + trunc(substr(d6.l_dayid,5,2)/3) * 300 + 31 then t1.f_amount else 0 end) as f_kpi_xtsr,
       sum(case when d1.c_ietype_code_l2 = 'XTBC' and d3.l_setup_date <= substr(d6.l_dayid,1,4) * 10000 + trunc(substr(d6.l_dayid,5,2)/3) * 300 + 31 then t1.f_amount else 0 end) as f_kpi_xtbc,
       sum(case when d1.c_ietype_code_l2 = 'XTCGF' and d3.l_setup_date <= substr(d6.l_dayid,1,4) * 10000 + trunc(substr(d6.l_dayid,5,2)/3) * 300 + 31 then t1.f_amount else 0 end) as f_kpi_xtcgf,
       sum(case when d1.c_ietype_code_l1 = 'XTSR' and d3.l_setup_date >= substr(d6.l_dayid,1,4)||'0101' and d3.l_setup_date <= substr(d6.l_dayid,1,4) * 10000 + trunc(substr(d6.l_dayid,5,2)/3) * 300 + 31 then t1.f_amount else 0 end) as f_kpi_xtsr_new,
        --期次状态
        MAX(case when substr(d3.l_setup_date,0,4) = substr(d6.l_dayid,0,4) then '新增'
            else '存续'  end) c_stage_status
  from dim_sr_stage     d3,
       tt_sr_ie_flow_d  t1,
       dim_pb_ie_type   d1,
       dim_pb_ie_status d2,
       dim_pb_project_basic d5,
       dim_day d6,
       dim_sr_stage    d7
 where d3.l_stage_id = t1.l_stage_id(+)
   and t1.l_ietype_id = d1.l_ietype_id
   and t1.l_iestatus_id = d2.l_iestatus_id
   and d3.l_proj_id = d5.l_proj_id
   and d5.l_setup_date <= d6.l_dayid
   and nvl(d3.l_setup_date,d5.l_setup_date) <= d6.l_dayid
   and t1.l_recog_flag = 0
   and t1.l_actual_flag = 0
   and substr(t1.l_change_date,1,4) = d6.year_id
   and d3.c_stage_code = d7.c_stage_code
   and d7.l_effective_date <= d6.l_dayid
   and d7.l_expiration_date > d6.l_dayid
   --and t1.l_change_date <= d6.l_dayid
   --and d6.l_dayid = 20160930
 group by d6.l_dayid,d7.l_proj_id,d7.l_stage_id;
