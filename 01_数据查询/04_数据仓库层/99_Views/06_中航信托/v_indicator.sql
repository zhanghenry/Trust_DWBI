create or replace view v_indicator as
select t.l_month_id, (case when a.c_item_name like '%营业收入%' then 1
                           when a.c_item_name like '%利润总额%' then 2 else 6 end) as l_order,
                     (case when a.c_item_name like '%营业收入%' then '营业收入'
                           when a.c_item_name like '%利润总额%' then '利润总额' else '管理费用' end) as c_name, t.f_money_eot
  from tt_fi_statement_m t, dim_fi_statement_item a, dim_fi_statement b
 where t.l_item_id = a.l_item_id and a.l_state_id = b.l_state_id
   and ( a.c_item_name like '%营业收入%' or a.c_item_name like '%利润总额%' or a.c_item_name like '%业务及管理费%' )
 union all
select a.month_id as l_month_id, 3 as l_order, '经济增加值' as c_name,
       t.f_actual as f_value
  from tt_pb_budget_y t, dim_month a, dim_pb_budget_item b
 where t.l_year_id = a.year_id and t.l_item_id = b.l_item_id
   and a.month_of_year = 12
   and b.c_item_code = 'GS000016'
 union all
select t.l_month_id, 4 as l_order, 'ROE' as c_name, ( case when sum(case when a.c_item_name like '%所有者权益合计%' then (t.f_money_eot + t.f_money_bot) / 2 else 0 end) <> 0 then
       sum(case when a.c_item_name like '%净利润%' then t.f_money_eot else 0 end) /
       sum(case when a.c_item_name like '%所有者权益合计%' then (t.f_money_eot + t.f_money_bot) / 2 else 0 end) else null end) as f_value
  from tt_fi_statement_m t, dim_fi_statement_item a, dim_fi_statement b
 where t.l_item_id = a.l_item_id and a.l_state_id = b.l_state_id
 group by t.l_month_id
 union all
select t.l_month_id, 7 as l_order, 'ROA' as c_name, ( case when sum(case when a.c_item_name like '%资产合计%' then (t.f_money_eot + t.f_money_bot) / 2 else 0 end) <> 0 then
       sum(case when a.c_item_name like '%利润总额%' then t.f_money_eot else 0 end) /
       sum(case when a.c_item_name like '%资产合计%' then (t.f_money_eot + t.f_money_bot) / 2 else 0 end) else null end) as f_value
  from tt_fi_statement_m t, dim_fi_statement_item a, dim_fi_statement b
 where t.l_item_id = a.l_item_id and a.l_state_id = b.l_state_id
 group by t.l_month_id
 union all
select t.l_month_id, 5 as l_order, '成本费用率' as c_name, ( case when sum(case when a.c_item_code in ('020123','020122','020112') then t.f_money_eot else 0 end) <> 0 then
       sum(case when a.c_item_code in ('020125','020126','020112') then t.f_money_eot else 0 end) else null end) /
       sum(case when a.c_item_code in ('020113','020108') then t.f_money_eot else 0 end)
        as f_value
  from tt_fi_statement_m t, dim_fi_statement_item a, dim_fi_statement b
 where t.l_item_id = a.l_item_id and a.l_state_id = b.l_state_id
 group by t.l_month_id;
