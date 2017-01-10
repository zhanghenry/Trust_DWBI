--收入整体
select c.c_proj_code as 项目编码,
       c.c_proj_name as 项目名称,
       b.c_stage_code as 产品编码,
       b.l_setup_date as 产品成立日期,
       b.l_expiry_date as 产品到期日期,
       b.c_stage_name as 产品名称,
       d.c_dept_name as 部门名称,
       sum(decode(a.l_revtype_id, 2, a.f_actual_agg, 0)) as 累计已支付信托报酬,
       sum(decode(a.l_revtype_id, 2, a.f_actual_eot, 0)) as 本年已支付信托报酬,
       sum(decode(a.l_revtype_id, 2, a.f_planned_agg, 0)) as 累计未支付信托报酬,
       sum(decode(a.l_revtype_id, 4, a.f_actual_agg, 0)) as 累计已支付财顾费,
       sum(decode(a.l_revtype_id, 4, a.f_actual_eot, 0)) as 本年已支付财顾费,
       sum(decode(a.l_revtype_id, 4, a.f_planned_agg, 0)) as 累计未支付财顾费
  from tt_sr_tstrev_stage_m a,
       dim_sr_stage         b,
       dim_pb_project_basic c,
       dim_pb_department    d
 where a.l_stage_id = b.l_stage_id
   and b.l_proj_id = c.l_proj_id
   and c.l_dept_id = d.l_dept_id
   and substr(c.l_effective_date, 1, 6) <= 201608
   and substr(c.l_expiration_date, 1, 6) > 201608
   and a.l_month_id = 201608
 group by c.c_proj_code,
          c.c_proj_name,
          b.c_stage_code,
          b.c_stage_name,
          b.l_setup_date,
          b.l_expiry_date,
          d.c_dept_name
having sum(a.f_actual_eot) <> 0 or sum(a.f_planned_eot) <> 0
 order by b.l_setup_date;

--项目收入
select d.c_proj_code,
       d.c_proj_name,
       d.l_setup_date,
       d.c_Proj_Phase_n,
       b.c_ietype_name,
       sum(a.f_actual_agg) as 累计实现收入,
       sum(a.f_planned_agg) as 累计计划收入,
       sum(a.f_planned_agg - a.f_actual_agg) as 累计未计提收入
  from tt_ic_ie_party_m a, dim_pb_ie_type b, dim_pb_project_basic d
 where a.l_month_id = 201609
   and a.l_proj_id = d.l_proj_id
   and d.l_effective_flag = 1
   and a.l_ietype_id = b.l_ietype_id
   and b.c_ietype_code_l1 = 'XTSR'
 group by d.c_proj_code,
          d.c_proj_name,
          d.l_setup_date,
          d.c_Proj_Phase_n,
          b.c_ietype_name
 order by d.c_proj_phase_n, d.l_setup_date;

--项目信托报酬
select d.c_proj_code as 项目编码,
       d.c_proj_name as 项目名称,
       d.l_setup_date as 成立日期,
       d.c_Proj_Phase_n as 项目阶段,
       e.c_dept_name as 部门名称,
       b.c_ietype_name as 收入类型,
       sum(a.f_actual_agg) as 累计实现收入,
       sum(a.f_planned_agg) as 累计计划收入,
       sum(a.f_planned_agg - a.f_actual_agg) as 累计未计提收入
  from tt_ic_ie_party_m     a,
       dim_pb_ie_type       b,
       dim_pb_project_basic d,
       dim_pb_department    e
 where a.l_month_id = 201610
   and a.l_proj_id = d.l_proj_id
   and d.l_dept_id = e.l_dept_id
   and a.l_month_id >= substr(d.l_effective_date, 1, 6)
   and a.l_month_id < substr(d.l_expiration_date, 1, 6)
   and a.l_ietype_id = b.l_ietype_id
   and b.c_ietype_code_l3 = 'XTGDBC'
 group by d.c_proj_code,
          d.c_proj_name,
          d.l_setup_date,
          d.c_Proj_Phase_n,
          e.c_dept_name,
          b.c_ietype_name
having sum(a.f_planned_agg - a.f_actual_agg) < 0
 order by e.c_dept_name, d.c_proj_phase_n, d.l_setup_date;

--产品收入
select d.c_proj_code,
       d.c_proj_name,
       c.c_prod_code,
       c.c_prod_name,
       b.c_ietype_name,
       sum(a.f_actual_agg) as 累计实现收入,
       sum(a.f_planned_agg) as 累计计划收入,
       sum(a.f_actual_agg - a.f_planned_agg) as 累计未计提收入
  from tt_ic_ie_party_d     a,
       dim_pb_ie_type       b,
       dim_pb_product       c,
       dim_pb_project_basic d
 where a.l_day_id = 20161110
   and a.l_prod_id = c.l_prod_id
   and a.l_proj_id = d.l_proj_id
   and d.l_effective_flag = 1
   and a.l_ietype_id = b.l_ietype_id
   and b.c_ietype_code_l1 = 'XTSR'
 group by d.c_proj_code,
          d.c_proj_name,
          c.c_prod_code,
          c.c_prod_name,
          b.c_ietype_name; 
 
--信托业务收入按业务范围、项目类型、功能分类、事务性质
select c.c_busi_scope,
       c.c_busi_scope_n,
       c.c_proj_type,
       c.c_proj_type_n,
       c.c_func_type,
       c.c_func_type_n,
       c.c_affair_props,
       c.c_affair_props_n,
       round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201608
 group by c.c_busi_scope,
          c.c_busi_scope_n,
          c.c_proj_type,
          c.c_proj_type_n,
          c.c_func_type,
          c.c_func_type_n,
          c.c_affair_props,
          c.c_affair_props_n
having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_busi_scope, c.c_proj_type, c.c_func_type, c.c_affair_props;
 
--信托业务收入按项目类型
select c.c_proj_type_n, sum(a.f_planned_eot) / 10000
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201606
 group by c.c_proj_type_n;
 
--信托业务收入按收入状态
select A.L_REVSTATUS_ID, sum(a.f_actual_eot) / 10000
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b
 where a.l_proj_id = b.l_proj_id
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201606
 group by A.L_REVSTATUS_ID;