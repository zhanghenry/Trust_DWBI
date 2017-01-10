--财务报告-资产负债表
select a.c_item_code, a.c_item_name, c.f_money_bot, c.f_money_eot
  from dim_fi_statement_item a, dim_fi_statement b, tt_fi_statement_m c
 where a.l_state_id = b.l_state_id
   and a.l_item_id = c.l_item_id
   and a.l_state_id = c.l_state_id
   and c.l_month_id = 201611
   and b.c_state_code = 'CAZC_RMB_HB';
   
--财务报告-利润表
select a.c_item_code, a.c_item_name, c.f_money_bot, c.f_money_eot
  from dim_fi_statement_item a, dim_fi_statement b, tt_fi_statement_m c
 where a.l_state_id = b.l_state_id
   and a.l_item_id = c.l_item_id
   and a.l_state_id = c.l_state_id
   and c.l_month_id = 201611
   and b.c_state_code = 'CASY_RMB_HB';