create or replace view v_emp_kpi_m as
with temp_scale as
 (select a.l_month_id, a.l_emp_id, a.f_balance_eot
    from tt_pe_scale_emp_m a),
temp_ie as
 (select b.l_month_id, b.l_emp_id, sum(b.f_planned_eoy) as f_planned_eoy
    from tt_pe_ie_emp_m b, dim_pb_ie_type b2
   where b.l_ietype_id = b2.l_ietype_id
     and b2.c_ietype_code_l1 in ('XTSR', 'TZSR')
   group by b.l_month_id, b.l_emp_id),
temp_budget as
 (select c.l_year_id,
         c.l_object_id,
         sum(decode(c2.c_item_code, 'BMZ001', c.f_budget, 0)) as f_scale_budget,
         sum(decode(c2.c_item_code, 'BMZ002', c.f_budget, 0)) as f_ie_budget
    from tt_pb_budget_y c, dim_pb_budget_item c2
   where c.l_item_id = c2.l_item_id
     and c2.c_item_code in ('BMZ001', 'BMZ002')
   group by c.l_year_id, c.l_object_id)
select t2.l_month_id    as 月份,
       t1.l_emp_id     as 员工ID,
       t1.c_emp_code   as 员工编码,
       t1.c_emp_name   as 员工名称,
       t2.f_balance_eot as 净增规模,
       null             as 预算规模,
       t3.f_planned_eoy as 本年合同收入,
       null             as 预算收入,
       null             as 本年费用额度,
       null             as 已入账费用
  from dim_pb_employee t1, temp_scale t2, temp_ie t3
 where t1.l_emp_id = t2.l_emp_id
   and t1.l_emp_id = t3.l_emp_id
   and t2.l_month_id = t3.l_month_id;
