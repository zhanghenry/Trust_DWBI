--项目投资余额
select b.c_proj_code,
       b.c_proj_name,
       sum(a.f_invest_agg),
       sum(a.f_return_agg),
       sum(a.f_invest_agg) - sum(a.f_return_agg) as 投资余额
  from tt_ic_invest_cont_m a, dim_pb_project_basic b,dim_ic_contract c
 where a.l_proj_id = b.l_proj_id
   and a.l_month_id = 201610
   and b.c_proj_code = 'AVICTC2015X1176'
 group by b.c_proj_code, b.c_proj_name;
 
--产品投资余额
select b.c_prod_code as 产品编码,
       b.c_prod_name as 产品名称,
       b.l_setup_date,
       sum(a.f_balance_agg) as 投资余额
  from tt_ic_invest_cont_m a, dim_pb_product b, dim_ic_contract c
 where a.l_prod_id = b.l_prod_id
   and a.l_cont_id = c.l_cont_id
   and a.l_month_id = 201608
   and substr(c.l_effective_date, 1, 6) <= 201608
   and substr(c.l_expiration_date, 1, 6) > 201608
 group by b.c_prod_code, b.c_prod_name, b.l_setup_date
 order by sum(a.f_balance_agg);
 
--资管合同投资规模
--按投向行业
select b.c_invest_indus_n, round(sum(a.f_balance_agg) / 100000000, 2)
  from tt_ic_invest_cont_m  a,
       dim_ic_contract      b,
       dim_pb_project_basic c,
       dim_pb_department    d
 where a.l_cont_id = b.l_cont_id
   and b.l_proj_id = c.l_proj_id
   and c.l_dept_id = d.l_dept_id
   and d.c_dept_code <> '841'
   and substr(b.l_effective_date, 1, 6) <= 201609
   and substr(b.l_expiration_date, 1, 6) > 201609
   and a.l_month_id = 201609
 group by b.c_invest_indus_n;
