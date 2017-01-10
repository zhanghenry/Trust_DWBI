--资金来源明细底表
with temp_prod_scale as
 (select t.l_prod_id,
         sum(t.f_balance_agg) as f_balance_agg,
         sum(t.f_decrease_agg) as f_decrease_agg
    from tt_tc_scale_cont_m t, dim_pb_product t1
   where t.l_month_id = 201610
     and t.l_prod_id = t1.l_prod_id --and t1.l_prod_id = 1102
     and substr(t1.l_effective_date, 1, 6) <= t.l_month_id
     and substr(t1.l_expiration_date, 1, 6) > t.l_month_id
     --and t1.c_prod_code = 'ZH08NN'
   group by t.l_prod_id),
temp_prod_revenue as
 (select t.l_prod_id,
         nvl(sum(decode(t1.c_ietype_code_l2, 'XTBC', t.f_actual_agg, 0)), 0) as f_actual_xtbc, --累计已支付信托报酬
         nvl(sum(decode(t1.c_ietype_code_l2, 'XTCGF', t.f_actual_eot, 0)), 0) as f_actual_xtcgf, --本年已支付信托财顾费
         nvl(sum(decode(t1.c_ietype_code_l2, 'XTBC', t.f_planned_agg, 0)), 0) as f_planned_xtbc, --累计计划信托报酬
         nvl(sum(decode(t1.c_ietype_code_l2, 'XTCGF', t.f_planned_agg, 0)),
             0) as f_planned_xtcgf --累计计划财顾费
    from tt_ic_ie_prod_m t, dim_pb_ie_type t1
   where t.l_month_id = 201610
     and t.l_ietype_id = t1.l_ietype_id
   group by t.l_prod_id),
temp_benefical_right as
 (select t.l_prod_id,
         min(t.f_expect_field) as f_min_field,
         max(t.f_expect_field) as f_max_field
    from dim_tc_beneficial_right t
   group by t.l_prod_id),
temp_sale_way as
 (select t.l_prod_id, wmsys.wm_concat(distinct t.c_sale_way_n) as c_sale_way
    from dim_tc_contract t
   where substr(t.l_effective_date, 1, 6) <= 201610
     and substr(t.l_expiration_date, 1, 6) > 201610
   group by t.l_prod_id),
temp_ic_rate as
 (select t.l_prod_id,
         min(t.f_rate) as f_min_rate,
         max(t.f_rate) as f_max_rate
    from dim_ic_rate t
   group by t.l_prod_id)
select l.c_book_code as 帐套编号,
       b.c_proj_code as 项目编号,
       b.c_proj_name as 项目名称,
       a.c_prod_code as 产品编码,
       d.c_dept_name as 业务部门,
       c.c_manage_type_n as 管理类型,
       c.c_proj_type_n as 项目类型,
       c.c_func_type_n as 功能分类,
       nvl(e.f_balance_agg, 0) as 产品受托余额,
       null as FA规模,
       null as 投资余额,
       nvl(decode(c.l_pool_flag, 1, 0, e.f_decrease_agg), 0) as 累计还本, --类资金池项目不统计
       nvl(decode(a.c_struct_type, '0', e.f_balance_agg, 0), 0) as 优先,
       nvl(decode(a.c_struct_type, '2', e.f_balance_agg, 0), 0) as 劣后,
       decode(c.l_pool_flag, 1, b.l_setup_date, a.l_setup_date) 产品起始日期, --类资金池取项目成立日期
       decode(c.l_pool_flag, 1, b.l_expiry_date, a.l_expiry_date) 产品终止日期, --类资金池项目刦项目终止日期
       to_char(k.f_min_rate,'0.0000') || '-' || to_char(k.f_max_rate,'0.0000') as 产品信托报酬率,
       (f.f_actual_xtbc + f.f_actual_xtcgf + f.f_planned_xtbc +
       f.f_planned_xtcgf) as 合同总收入,
       (f.f_actual_xtbc + f.f_planned_xtbc) as 信托报酬,
       f.f_actual_xtbc as 累计已支付信托报酬,
       f.f_planned_xtbc as 尚未支付信托报酬,
       f.f_actual_xtcgf as 累计已支付财务顾问费,
       f.f_planned_xtcgf as 尚未支付财务顾问费,
       c.c_invest_indus_n as 项目实质投向,
       null as 合同受益人单一,
       g.c_inst_name as 实质资金来源,
       j.c_sale_way as 集合资金销售渠道,
       a.c_special_settlor as 集合项目特殊委托人,
       to_char(i.f_min_field,'0.0000') || '-' || to_char(i.f_max_field,'0.0000') as 产品预计收益率,
       case
         when nvl(b.l_expiry_date, 20991231) > 20160930 then
          '存续'
         else
          '清算'
       end as 是否清算,
       decode(a.l_tot_flag, 1, '是') as 是否TOT
  from dim_pb_product       a,
       dim_pb_project_basic b,
       dim_pb_project_biz   c,
       dim_pb_department    d,
       temp_prod_scale      e,
       temp_prod_revenue    f,
       dim_pb_institution   g,
       temp_benefical_right i,
       temp_sale_way        j,
       temp_ic_rate         k ,
       dim_to_book          l
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and b.l_dept_id = d.l_dept_id(+)
   and c.l_bankrec_ho = g.l_inst_id(+)
   and a.l_prod_id = e.l_prod_id(+)
   and a.l_prod_id = f.l_prod_id(+)
   and a.l_prod_id = i.l_prod_id(+)
   and a.l_prod_id = j.l_prod_id(+)
   and a.l_prod_id = k.l_prod_id(+)
   --and b.c_proj_code = 'AVICTC2016X0247'
   and a.l_prod_id = l.l_prod_id(+)
   and substr(a.l_effective_date, 1, 6) <= 201610
   and substr(a.l_expiration_date, 1, 6) > 201610
 order by b.l_setup_date, b.c_proj_code, a.c_prod_code;