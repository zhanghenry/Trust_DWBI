create or replace view v_project_summary_d as
select d3.l_dayid,
       d1.l_proj_id,
       '当前存续' as c_status,
       MAX(case
             when d1.l_preexp_date > d3.l_dayid or d1.l_preexp_date is null then
              1
             else
              0
           end) c_pro_count,
       MAX(case
             when d2.c_property_type = '1' and ds.l_period = 0 then --准资产证券化
              vs.f_balacne_bot
             when d2.c_property_type <> '1' or d2.c_property_type is null then
              vs.f_balacne_bot
             else
              0
           end) f_scale

  from dim_pb_project_basic d1,
       dim_pb_project_biz   d2,
       dim_day              d3,
       dim_sr_stage         ds,
       v_stage_status_scale vs
 where d1.l_proj_id = d2.l_proj_id
   and d1.l_proj_id = ds.l_proj_id
   and ds.l_stage_id = vs.l_stage_id
   and d1.l_proj_id = vs.l_proj_id
   and d2.c_busi_scope in (1, 2)
   and d1.l_effective_date <= d3.l_dayid
   and d1.l_expiration_date >= d3.l_dayid
   and vs.l_day_id = d3.l_dayid
 group by d3.l_dayid, d1.l_proj_id

union all

select d3.l_dayid,
       d1.l_proj_id,
       '年初存续' as c_status,
       MAX(case
             when d1.l_setup_date <=
                  to_char(trunc(d3.day_date, 'YYYY') - 1, 'yyyymmdd') and
                  (d1.l_preexp_date is null or
                  d1.l_preexp_date >
                  to_char(trunc(d3.day_date, 'YYYY') - 1, 'yyyymmdd')) then
              1
             else
              0
           end) c_pro_count,

       MAX(case
             when d2.c_property_type = '1' and ds.l_period = 0 then --准资产证券化
              vs.f_beginyear_scale
             when d2.c_property_type <> '1' or d2.c_property_type is null then
              vs.f_beginyear_scale
             else
              0
           end) f_scale

  from dim_pb_project_basic d1,
       dim_pb_project_biz   d2,
       dim_day              d3,
       dim_sr_stage         ds,
       v_stage_status_scale vs
 where d1.l_proj_id = d2.l_proj_id
   and d1.l_proj_id = ds.l_proj_id
   and ds.l_stage_id = vs.l_stage_id
   and d1.l_proj_id = vs.l_proj_id
   and d2.c_busi_scope in (1, 2)
   and d1.l_effective_date <= d3.l_dayid
   and d1.l_expiration_date >= d3.l_dayid
   and vs.l_day_id = d3.l_dayid
 group by d3.l_dayid, d1.l_proj_id

union all

select d3.l_dayid,
       d1.l_proj_id,
       '本年新增' as c_status,
       MAX(case
             when d1.l_setup_date >
                  to_char(trunc(d3.day_date, 'YYYY') - 1, 'yyyymmdd') then
              1
             else
              0
           end) c_pro_count,
       MAX(case
             when d2.c_property_type = '1' and ds.l_period = 0 then --准资产证券化
              vs.f_increase_eot
             when d2.c_property_type <> '1' or d2.c_property_type is null then
              vs.f_increase_eot
             else
              0
           end) f_scale

  from dim_pb_project_basic d1,
       dim_pb_project_biz   d2,
       dim_day              d3,
       dim_sr_stage         ds,
       v_stage_status_scale vs
 where d1.l_proj_id = d2.l_proj_id
   and d1.l_proj_id = ds.l_proj_id
   and ds.l_stage_id = vs.l_stage_id
   and d1.l_proj_id = vs.l_proj_id
   and d2.c_busi_scope in (1, 2)
   and d1.l_effective_date <= d3.l_dayid
   and d1.l_expiration_date >= d3.l_dayid
   and vs.l_day_id = d3.l_dayid
 group by d3.l_dayid, d1.l_proj_id

union all

select d3.l_dayid,
       d1.l_proj_id,
       '本年清算' as c_status,
       MAX(case
             when d1.l_preexp_date >
                  to_char(trunc(d3.day_date, 'YYYY') - 1, 'yyyymmdd') and
                  (d1.l_preexp_date is not null and
                  d1.l_preexp_date <= d3.l_dayid) then
              1
             else
              0
           end) c_pro_count,

       MAX(case
             when d2.c_property_type = '1' and ds.l_period = 0 then --准资产证券化
              vs.f_decrease_eot
             when d2.c_property_type <> '1' or d2.c_property_type is null then
              vs.f_decrease_eot
             else
              0
           end) f_scale
  from dim_pb_project_basic d1,
       dim_pb_project_biz   d2,
       dim_day              d3,
       dim_sr_stage         ds,
       v_stage_status_scale vs
 where d1.l_proj_id = d2.l_proj_id
   and d1.l_proj_id = ds.l_proj_id
   and ds.l_stage_id = vs.l_stage_id
   and d1.l_proj_id = vs.l_proj_id
   and d2.c_busi_scope in (1, 2)
   and d1.l_effective_date <= d3.l_dayid
   and d1.l_expiration_date >= d3.l_dayid
   and vs.l_day_id = d3.l_dayid
 group by d3.l_dayid, d1.l_proj_id;
