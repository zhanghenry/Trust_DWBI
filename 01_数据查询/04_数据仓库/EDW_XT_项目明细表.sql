--项目信息明细
with temp_scale as
 (select t1.l_proj_id,
         t1.f_increase_eot,
         t1.f_decrease_eot,
         t1.f_balance_eot
    from tt_sr_scale_proj_m t1, dim_pb_project_basic t2
   where t1.l_proj_id = t2.l_proj_id
     and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
     and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
     and t1.l_month_id = 201609),
temp_revenue as
 (select t1.l_proj_id,
         sum(case when t1.l_revtype_id = 2 and t1.l_revstatus_id = 1 then t1.f_actual_eot else 0 end) as f_new_xtbc,
         sum(case when t1.l_revtype_id = 2 and t1.l_revstatus_id = 2 then t1.f_actual_eot else 0 end) as f_exist_xtbc,
         sum(case when t1.l_revtype_id = 4 and t1.l_revstatus_id = 1 then t1.f_actual_eot else 0 end) as f_new_xtcgf,
         sum(case when t1.l_revtype_id = 4 and t1.l_revstatus_id = 2 then t1.f_actual_eot else 0 end) as f_exist_xtcgf
    from tt_sr_tstrev_proj_m t1, dim_pb_project_basic t2
   where t1.l_proj_id = t2.l_proj_id
     and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
     and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
     and t1.l_month_id = 201609
   group by t1.l_proj_id),
temp_fa as
 (select t1.l_proj_id, t1.f_scale_eot, t1.f_scale_agg
    from tt_po_rate_proj_d t1, dim_pb_project_basic t2
   where t1.l_proj_id = t2.l_proj_id
     and t2.l_effective_flag = 1
     and t1.l_day_id = 20160930)
select a.c_proj_code     as 项目编码,
       a.c_proj_name     as 项目名称,
       c.c_dept_name     as 信托部门,
       g.c_emp_name      as 信托经理 a.c_proj_phase_n as 项目阶段,
       a.c_proj_status_n as 项目状态,
       a.l_setup_date    as 成立日期,
       a.l_preexp_date   as 预到期日期,
       a.l_expiry_date   as 结束日期,
       b.c_busi_scope_n  as 业务范围,
       b.c_proj_type_n   as 项目类型,
       --b.c_property_type_n as 项目财产权类型,
       b.c_func_type_n as 功能类型,
       --b.c_coop_type_n as 合作类型,
       b.c_trust_type_n    as 信托类型,
       b.c_manage_type_n   as 管理方式,
       a.c_operating_way_n as 运行方式,
       b.c_special_type_n  as 特殊业务类型,
       b.c_fduse_way_n     as 资金运用方式,
       b.c_invest_indus_n  as 投向行业,
       b.c_invest_dir_n    as 投资方向,
       --b.c_invest_way_n as 投资方式,
       d.f_increase_eot as 本年新增规模,
       d.f_decrease_eot as 本年减少规模,
       d.f_balance_eot as 当前存续规模,
       f.f_scale_eot as FA存续信托规模,
       f.f_scale_agg as FA累计实收信托规模,
       e.f_new_xtbc as 新增信托报酬,
       e.f_exist_xtbc as 存续信托报酬,
       e.f_new_xtbc + e.f_exist_xtbc as 本年信托报酬,
       e.f_new_xtcgf as 新增信托财顾费,
       e.f_exist_xtcgf as 存续信托财顾费,
       e.f_new_xtcgf + e.f_exist_xtcgf as 本年信托财顾费
  from dim_pb_project_basic a,
       dim_pb_project_biz   b,
       dim_pb_department    c,
       temp_scale           d,
       temp_revenue         e,
       temp_fa              f,
       dim_pb_employee      g
 where a.l_proj_id = b.l_proj_id
   and a.l_dept_id = c.l_dept_id
   and a.l_tstmgr_id = g.l_emp_id
   and a.l_proj_id = d.l_proj_id(+)
   and a.l_proj_id = e.l_proj_id(+)
   and a.l_proj_id = f.l_proj_id(+)
   and a.l_effective_flag = 1
 order by a.l_setup_date;