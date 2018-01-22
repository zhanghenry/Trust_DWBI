select a.l_proj_id,c.l_stage_id,b.c_ietype_name,a.f_actual_eoy 
  from tt_sr_ie_stage_m a, dim_pb_ie_type b,dim_sr_prod_stage c
 where a.l_ietype_id = b.l_ietype_id
 and a.l_proj_id = c.l_proj_id
   --and b.c_ietype_code = 'TZZYFX'
   and a.l_month_id = 201612;
   
select * from dim_sr_prod_stage t where t.l_proj_id = 1351;
select * from tt_sr_ie_stage_m t where t.l_proj_id = 1351;

select *
  from dim_sr_prod_stage a
 where exists
 (select 1 from tt_sr_ie_stage_m b where a.l_proj_id = b.l_proj_id);

--信托收入期次明细
select c.c_proj_code as 项目编码,
       c.c_proj_name as 项目名称,
       b.c_stage_code as 期次编码,
       sum(case when d.c_ietype_code = 'XTGDBC' then a.f_planned_eoy end) as 固定报酬,
       sum(case when d.c_ietype_code = 'XTFDBC' then a.f_planned_eoy end) as 浮动报酬,
       --sum(case when d.c_ietype_code_l2 = 'XTBC' then a.f_planned_eoy end) as 信托报酬,
       sum(case when d.c_ietype_code_l2 = 'XTCGF' then a.f_planned_eoy end) as 财顾费,
       sum(case when d.c_ietype_code_l2 = 'XTYXFY' then a.f_planned_eoy end) as 营销费用,
       sum(case when d.c_ietype_code = 'XTFXBC' then a.f_planned_eoy end) as 分享报酬,  
       sum(case when d.c_ietype_code = 'XTFXCGF' then a.f_planned_eoy end) as 分享报酬,
       sum(case when d.c_ietype_code = 'TZZYFX' then a.f_planned_eoy end) as 自营分享/*,
       sum(case when d.c_ietype_code = 'XTDLZF' then a.f_planned_eoy end) as 信托独立支付*/
  from tt_sr_ie_stage_m     a,
       dim_sr_stage         b,
       dim_pb_project_basic c,
       dim_pb_ie_type       d,
       dim_pb_ie_status     e
 where a.l_stage_id = b.l_stage_id
   and a.l_proj_id = c.l_proj_id
   and a.l_ietype_id = d.l_ietype_id
   and a.l_iestatus_id = e.l_iestatus_id
   and a.l_month_id = 201612
 group by c.c_proj_code, c.c_proj_name, b.c_stage_code
 order by c.c_proj_code, c.c_proj_name, b.c_stage_code;

--自营收入项目明细
select b.c_proj_code,
       b.c_proj_name,
       sum(case when c.c_ietype_code in ('TZSY','TZLX','TZFX','TZWYJ') then a.f_actual_eoy else 0 end) as 投资收益,
       sum(decode(c.c_ietype_code, 'TZZYFX', a.f_actual_eoy, 0)) as 自营分享
  from tt_sr_ie_stage_m     a,
       dim_pb_project_basic b,
       dim_pb_ie_type       c,
       dim_pb_ie_status     d,
       dim_pb_project_biz   e
 where a.l_proj_id = b.l_proj_id
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and b.l_proj_id = e.l_proj_id
   and e.c_busi_scope is null
   and a.l_month_id = 201612
 group by b.c_proj_code, b.c_proj_name;
   
--信托规模
select b.c_stage_code,
       a.f_increase_eot,
       a.f_decrease_eot,
       a.f_balance_agg
  from tt_sr_scale_stage_m a, dim_sr_stage b
 where a.L_stage_id = b.l_stage_id
   and a.l_month_id = 201612;
 
select * from tt_sr_ie_stage_m t where t.l_ietype_id = 22 and t.l_month_id = 201612;
select * from dim_pb_ie_type;

select * from dim_pb_budget_item t where t.l_item_id = 186;
