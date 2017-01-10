
--查询公司财报
select a.c_item_name,b.f_money_eot,b.f_money_bot
  from tfi_statement_item a, tfi_statement_value b
 where a.c_item_code = b.c_item_code
   and b.c_state_code = '1'
   and b.d_state = to_date('20160930', 'yyyymmdd')
   order by a.l_column_axis,a.l_row_axis;

--查询固有凭证科目金额
select c.c_subj_code, c.c_subj_name,c.c_direction_type, round(sum(a.f_debit-a.f_credit)/10000,2)
  from tfi_voucher a,
       tfi_subject b,
       (select t.c_subj_code, t.c_subj_name,t.c_direction_type
          from tfi_subject t
         where t.c_subj_cate = '1'
           and t.l_subj_level = 1 and t.c_direction_type = '1') c
 where a.c_subj_code = b.c_subj_code
   and a.c_object_type = 'GS'
   and a.l_fiscal_year = 2016
   and a.l_fiscal_month <= 5
   and substr(b.c_subj_code, 1, 4) = c.c_subj_code
 group by c.c_subj_code, c.c_subj_name,c.c_direction_type;

--项目实际收入
select t.c_proj_code, sum(t.f_revenue)
  from tde_revenue_change t
 where t.l_actual_flag = 1
   and t.d_revenue between to_date('20160101', 'yyyymmdd') and
       to_date('20160930', 'yyyymmdd')
 group by t.c_proj_code;

--用友项目收入分信托报酬和财顾费
select t.c_object_code, sum(t.f_credit)
  from tfi_voucher t
 where t.c_object_type = 'XM'
   and substr(t.c_subj_code, 1, 4) in ('6021', '6051')
   and t.d_business between to_date('20160101', 'yyyymmdd') and
       to_date('20160930', 'yyyymmdd')
 group by t.c_object_code;
 
