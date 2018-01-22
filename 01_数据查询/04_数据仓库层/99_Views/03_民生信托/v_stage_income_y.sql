create or replace view v_stage_income_y as
select d9.l_dayid,
        d7.l_proj_id,
        d7.c_proj_code,
        d10.l_stage_id,
        d10.c_stage_code,
  sum(case when substr(t3.l_change_date,0,4) = substr(d9.l_dayid,0,4)
                and d8.c_ietype_code in('XTGDBC','XTFDBC')
           then t3.f_amount else 0 end)  thisYear_trustpay ,
  sum(case when substr(t3.l_change_date,0,4) = substr(d9.l_dayid,0,4) + 1
                and d8.c_ietype_code in('XTGDBC','XTFDBC')
           then t3.f_amount else 0 end)  nextYear_trustpay ,
  sum(case when substr(t3.l_change_date,0,4) = substr(d9.l_dayid,0,4) +2
                and d8.c_ietype_code in('XTGDBC','XTFDBC')
           then t3.f_amount else 0 end)  lastYear_trustpay,
  sum(case when substr(t3.l_change_date,0,4)= substr(d9.l_dayid,0,4)
                and d8.c_ietype_code_l2 ='XTCGF'
           then t3.f_amount else 0 end)  thisYear2_constructfee,
  sum(case when substr(t3.l_change_date,0,4) = substr(d9.l_dayid,0,4)+1
                and d8.c_ietype_code_l2 ='XTCGF'
           then t3.f_amount else 0 end) nextYear2_constructfee ,
  sum(case when substr(t3.l_change_date,0,4) = substr(d9.l_dayid,0,4)+2
                and d8.c_ietype_code_l2 ='XTCGF'
           then t3.f_amount else 0 end)   lastYear2_constructfee
   from tt_sr_ie_flow_d t3,dim_pb_project_basic d7 ,
   dim_sr_stage d11,dim_pb_ie_type d8,dim_day d9,dim_sr_stage d10
  where d10.l_proj_id = d7.l_proj_id
  and t3.l_stage_id = d11.l_stage_id
  and t3.l_ietype_id = d8.l_ietype_id
  and t3.l_actual_flag = 0
  and t3.l_recog_flag = 0
  and d11.c_stage_code = d10.c_stage_code
  and d10.l_effective_date <= d9.l_dayid
  and d10.l_expiration_date > d9.l_dayid
 group by
       d9.l_dayid,
       d7.l_proj_id,
        d7.c_proj_code,
        d10.l_stage_id,
        d10.c_stage_code;
