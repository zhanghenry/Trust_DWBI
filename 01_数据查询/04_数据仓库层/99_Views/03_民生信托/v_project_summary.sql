create or replace view v_project_summary as
select t.l_day_id as l_dayid,
       b.l_proj_id,
       x.rn as l_status,
       decode(x.rn, 1, '本年新增', 2, '本年清算', 3,'年初存续', 4,'当前存续', null) as c_status,
       case when x.rn = 1 then sum(case when c.c_property_type = '1' and  a.l_period <> 0  --准资产证券化
                                         then 0 else t.f_increase_eot end)
            when x.rn = 2 then sum(case when c.c_property_type = '1' and  a.l_period <> 0  --准资产证券化
                                     then 0 else t.f_decrease_eot end)
            when x.rn = 3 then sum(case when c.c_property_type = '1' and  a.l_period <> 0  --准资产证券化
                                     then 0 else t.f_balacne_bot end)
            when x.rn = 4 then sum(case when c.c_property_type = '1' and  a.l_period <> 0  --准资产证券化
                                     then 0 else t.f_balance_agg end)
            else null end as f_scale,
       case when x.rn = 1 then (case when b.l_setup_date >= substr(t.l_day_id,1,4)||'0101'
                                      and b.l_setup_date <= t.l_day_id
                                     then 1 else 0 end)
            when x.rn = 2 then (case when nvl(b.l_expiry_date,20991231) >= substr(t.l_day_id,1,4)||'0101'
                                      and nvl(b.l_expiry_date,20991231) <= t.l_day_id
                                     then 1 else 0 end)
            when x.rn = 3 then (case when nvl(b.l_expiry_date,20991231) >= substr(t.l_day_id,1,4)||'0101'
                                         and b.l_setup_date < substr(t.l_day_id,1,4)||'0101'
                                     then 1 else 0 end)
            when x.rn = 4 then (case when nvl(b.l_expiry_date,20991231) > t.l_day_id
                                      and b.l_setup_date <= t.l_day_id
                                     then 1 else 0 end)
            else null end as c_pro_count
  from tt_sr_scale_stage_d t, dim_sr_stage a, dim_pb_project_basic b, dim_pb_project_biz c,
       (select 1 rn from dual union select 2 from dual union select 3 from dual union select 4 from dual) x
 where t.l_stage_id  = a.l_stage_id
   and a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and b.l_effective_date <= t.l_day_id
   and b.l_expiration_date > t.l_day_id
 group by t.l_day_id, b.l_proj_id, b.l_setup_date, b.l_expiry_date, x.rn;
