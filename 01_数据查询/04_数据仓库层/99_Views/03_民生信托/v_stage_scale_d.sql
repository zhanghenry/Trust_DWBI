create or replace view v_stage_scale_d as
with temp_info as(
select t1.l_dayid as l_day_id,
       t3.l_proj_id,
       t3.c_proj_code,
       t2.l_stage_id,
       t2.c_stage_code,
       t2.l_period,
       t4.c_property_type
  from dim_day              t1,
       dim_sr_stage         t2,
       dim_pb_project_basic t3,
       dim_pb_project_biz   t4
 where t2.l_proj_id = t3.l_proj_id
   and t2.l_proj_id = t4.l_proj_id
   and t2.l_effective_date <= t1.l_dayid
   and t2.l_expiration_date > t1.l_dayid
   and t2.l_setup_date <= t1.l_dayid
   and t1.year_id between 2013 and 2020
 group by t1.l_dayid,
          t3.l_proj_id,
          t3.c_proj_code,
          t2.l_stage_id,
          t2.c_stage_code,
          t2.l_period,
          t4.c_property_type),
temp_scale as (
select t1.l_day_id,
       t2.l_stage_id,
       sum(t1.f_increase_eot) as f_increase_eot,
       sum(t1.f_decrease_eot) as f_decrease_eot,
       sum(t1.f_balance_agg) as f_balance_agg,
       sum(case when substr(t2.l_setup_date, 1, 6) >= substr(t1.l_day_id, 1, 4) || '01' and substr(t2.l_setup_date, 1, 6) <= substr(t1.l_day_id, 1, 6) then t1.f_balance_eot else 0 end) as f_net_inc_eot
  from tt_sr_scale_stage_d  t1,
       dim_sr_stage         t2
 where t1.l_stage_id = t2.l_stage_id
   and t2.l_setup_date <= t1.l_day_id
 group by t1.l_day_id,
          t2.l_stage_id
),
temp_bridge as (
select c1.l_dayid as l_day_id,
       d2.l_stage_id,
       sum(decode(a1.c_scatype_code, '50', b1.f_scale, 0)) as f_setup_eot,
       sum(case when substr(b1.l_change_date,1,4) = substr(c1.l_dayid,1,4) and a1.c_scatype_code = '62' then b1.f_scale else 0 end) as f_bridge_eot,
       sum(case when substr(b1.l_change_date,1,4) < substr(c1.l_dayid,1,4) then b1.f_scale else 0 end) as f_balance_ly
  from dim_pb_scale_type a1, tt_sr_scale_flow_d b1,dim_day c1,dim_sr_stage d1,dim_sr_stage d2
 where a1.l_scatype_id = b1.l_scatype_id
 and b1.l_change_date <= c1.l_dayid
 and b1.l_stage_id = d1.l_stage_id
 and d1.c_stage_code = d2.c_stage_code
 and d2.l_effective_date <= c1.l_dayid
 and d2.l_expiration_date > c1.l_dayid
 group by c1.l_dayid, d2.l_stage_id),
temp_property_scale as (
select a.c_stagescode as c_stage_code,to_char(d.d_date,'yyyymmdd') as l_day_id,
       sum(case when to_char(a.d_varydate,'yyyy') < to_char(d.d_date,'yyyy') then a.f_scale else 0end) as f_balance_ly,--年初存续规模
       sum(a.f_scale) as f_balance,--当前规模余额
       sum(case when a.c_busiflag = '62' and to_char(a.d_varydate,'yyyy') = to_char(d.d_date,'yyyy') then a.f_scale else 0end) as f_bridge, --本年过桥规模
       sum(case when a.c_busiflag = '50' then a.f_scale else 0end) as f_setup, --成立规模
       sum(case when to_char(b.d_setup,'yyyy') = to_char(d.d_date,'yyyy') then a.f_scale else 0end) as f_net_increase,--净增规模
       sum(case when to_char(a.d_varydate,'yyyy') = to_char(d.d_date,'yyyy') and a.f_scale > 0 then a.f_scale else 0end) as f_increase,--新增规模
       sum(case when to_char(a.d_varydate,'yyyy') = to_char(d.d_date,'yyyy') and a.f_scale < 0 then a.f_scale*-1 else 0end) as f_decrease --清算规模
  from dataods.tta_saclevary  a,
       dataods.tpm_stagesinfo b,
       dataods.tprojectinfo   c,
       dataods.topenday       d
 where a.c_stagescode = b.c_stagescode
   and b.c_projectcode = c.c_projectcode
   and a.d_varydate <= d.d_date
   and c.c_propertytype_indiv = '1'
   and b.l_period <> 0
   group by a.c_stagescode,to_char(d.d_date,'yyyymmdd')
)
select tp1.l_day_id,
       tp1.l_proj_id,
       tp1.c_proj_code,
       tp1.l_stage_id,
       tp1.c_stage_code,
       tp1.l_period,
       tp1.c_property_type,
       sum(case when tp1.c_property_type = '1' and tp1.l_period <> 0 then tp3.f_increase else tp4.f_increase_eot end) f_increase_eot,--本年新增
       sum(case when tp1.c_property_type = '1' and tp1.l_period <> 0 then tp3.f_decrease else tp4.f_decrease_eot end) f_decrease_eot,--本年清算
       sum(case when tp1.c_property_type = '1' and tp1.l_period <> 0 then tp3.f_balance_ly  else tp2.f_balance_ly end)  f_balacne_bot, --年初存续
       sum(case when tp1.c_property_type = '1' and tp1.l_period <> 0 then tp3.f_net_increase  else tp4.f_net_inc_eot end) as f_balance_eot,--本年净增规模,
       sum(case when tp1.c_property_type = '1' and tp1.l_period <> 0 then tp3.f_balance  else tp4.f_balance_agg end) f_balance_agg ,--规模余额
       sum(case when tp1.c_property_type = '1' and tp1.l_period <> 0 then tp3.f_bridge else tp2.f_bridge_eot end) f_bridge_eot ,--过桥规模
       sum(case when tp1.c_property_type = '1' and tp1.l_period <> 0 then tp3.f_setup else tp2.f_setup_eot end) f_setup_scale --本年成立规模
  from temp_info             tp1,
       temp_bridge           tp2,
       temp_property_scale   tp3,
       temp_scale            tp4
  where tp1.l_stage_id = tp2.l_stage_id(+)
  and tp1.l_day_id  = tp2.l_day_id(+)
  and tp1.l_day_id = tp3.l_day_id(+)
  and tp1.c_stage_code = tp3.c_stage_code(+)
  and tp1.l_stage_id = tp4.l_stage_id(+)
  and tp1.l_day_id = tp4.l_day_id(+)
  group by tp1.l_day_id,
           tp1.l_proj_id,
           tp1.c_proj_code,
           tp1.l_stage_id,
           tp1.c_stage_code,
           tp1.l_period,
           tp1.c_property_type;
