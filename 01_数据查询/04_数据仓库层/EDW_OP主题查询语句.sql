--经营指标
select a.c_indic_code,
       a.c_indic_name,
       b.f_indic_actual as 实际值,
       b.f_indic_budget as 预算值,
       b.f_indic_change as 变化值
  from dim_op_indicator a, tt_op_indicator_m b
 where a.l_indic_id = b.l_indic_id
   and b.l_month_id = 201611;

--自定义报告-固定费用执行情况
--长安在用
select a.c_item_code, a.c_item_name, c.f_value1 as 实际, c.f_value2 as 预计
  from dim_op_report_item a, dim_op_report b, tt_op_report_m c
 where a.l_report_id = b.l_report_id
   and a.l_item_id = c.l_item_id
   and b.c_report_code = 'GDFYZXQK'
   and c.l_month_id = 201610;
   
--自定义报告-利润简表
--长安在用
select a.c_item_code,
       a.c_item_name,
       c.f_value1    as 本年发生值,
       c.f_value2    as 本月发生值,
       c.f_value3    as 本年预算值
  from dim_op_report_item a, dim_op_report b, tt_op_report_m c
 where a.l_report_id = b.l_report_id
   and a.l_item_id = c.l_item_id
   and b.c_report_code = 'LRJB'
   and c.l_month_id = 201611;