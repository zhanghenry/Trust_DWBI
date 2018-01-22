create or replace view v_dept_kpi_m as
with temp_scale as
 (select a.l_month_id, a.l_dept_id, a.f_balance_eot
    from tt_pe_scale_dept_m a),
temp_ie as
 (select b.l_month_id, b.l_dept_id, sum(b.f_planned_eoy) as f_planned_eoy
    from tt_pe_ie_dept_m b, dim_pb_ie_type b2
   where b.l_ietype_id = b2.l_ietype_id
     and b2.c_ietype_code_l1 in ('XTSR', 'TZSR')
   group by b.l_month_id, b.l_dept_id)
select t2.l_month_id    as 月份,
       t1.l_dept_id     as 部门ID,
       t1.c_dept_name   as 部门名称,
       t1.c_dept_code   as 部门编码,
       t2.f_balance_eot as 净增规模,
       null             as 预算规模,
       t3.f_planned_eoy as 本年合同收入,
       null             as 预算收入,
       null             as 本年费用额度,
       null             as 已入账费用
  from dim_pb_department t1, temp_scale t2, temp_ie t3
 where t1.l_dept_id = t2.l_dept_id
   and t1.l_dept_id = t3.l_dept_id
   and t2.l_month_id = t3.l_month_Id;
