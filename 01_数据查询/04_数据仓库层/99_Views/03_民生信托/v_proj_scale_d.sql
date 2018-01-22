create or replace view v_proj_scale_d as
select l_day_id,
       l_proj_id,
       c_proj_code,
       l_stage_id,
       c_stage_code,
       l_period,
       c_property_type,
       case when c_property_type = '1' and l_period <>0 then 0 else f_increase_eot end f_increase_eot,
       case when c_property_type = '1' and l_period <>0 then 0 else f_decrease_eot end f_decrease_eot,
       case when c_property_type = '1' and l_period <>0 then 0 else f_balacne_bot end f_balacne_bot,
       case when c_property_type = '1' and l_period <>0 then 0 else f_balance_eot end f_balance_eot,
       case when c_property_type = '1' and l_period <>0 then 0 else f_balance_agg end f_balance_agg,
       case when c_property_type = '1' and l_period <>0 then 0 else f_bridge_eot end f_bridge_eot,
       case when c_property_type = '1' and l_period <>0 then 0 else f_setup_scale end f_setup_scale
  from v_stage_scale_d
 --where l_day_id = 20170831
union all
select a.l_day_id     as l_day_id,
       b.l_proj_id    as l_proj_id,
       b.c_proj_code as c_proj_code,
       0              as l_stage_id,
       null           as c_stage_code,
       0              as l_period,
       null           as c_property_type,
       0              as f_increase_eot,
       0              as f_decrease_eot,
       0              as f_balacne_bot,
       0              as f_balance_eot,
       0              as f_balance_agg,
       0              as f_bridge_eot,
       0              as f_setup_scale
  from tt_sr_ie_stage_d a, dim_pb_project_basic b, dim_pb_project_biz c,dim_pb_ie_type d,dim_pb_ie_status e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_ietype_id = d.l_ietype_id
   and a.l_iestatus_id = e.l_iestatus_id
   and e.l_recog_flag = 0
   and d.c_ietype_code_l1 = 'TZSR'
   and c.c_busi_scope = '0'
   --and a.l_day_id = 20170828
   group by a.l_day_id,b.l_proj_id,b.c_proj_code having sum(a.f_planned_eoy) <> 0;
