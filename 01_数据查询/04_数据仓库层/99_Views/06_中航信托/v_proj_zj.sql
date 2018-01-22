create or replace view v_proj_zj as
with temp_prod_scale as
 (select t.l_prod_id, a.l_proj_id ,
         sum(t.f_balance_agg ) as f_balance_agg ,
         sum(t.f_increase_eot ) as f_increase_eot ,
         sum(t.f_decrease_agg ) as f_decrease_agg
    from tt_tc_scale_cont_m t ,dim_pb_product a
   where t.l_month_id = 201612 and t.l_prod_id = a.l_prod_id
     and substr(a.l_effective_date,1,6)<=201612
   and substr( a.l_expiration_date,1 ,6) > 201612
   group by t.l_prod_id , a.l_proj_id ),
temp_prod_revenue as
 (select t.l_prod_id,
         nvl(sum (decode( t1.c_ietype_code_l2, 'XTBC', t.f_actual_agg, 0)), 0 ) as f_actual_xtbc, --累计已支付信托报酬
         nvl(sum (decode( t1.c_ietype_code_l2, 'XTCGF', t.f_actual_eot, 0)), 0 ) as f_actual_xtcgf, --本年已支付信托财顾费
         nvl(sum (decode( t1.c_ietype_code_l2, 'XTBC', t.f_planned_agg, 0)), 0 ) as f_planned_xtbc, --累计计划信托报酬
         nvl(sum (decode( t1.c_ietype_code_l2, 'XTCGF', t.f_planned_agg, 0)), 0 ) as f_planned_xtcgf --累计计划财顾费
    from tt_ic_ie_prod_m t ,dim_pb_ie_type t1
   where t.l_month_id = 201612
   and t.l_ietype_id = t1.l_ietype_id
   group by t.l_prod_id
   ),
temp_benefical_right as
 (select t.l_prod_id,
         min(t.f_expect_field ) as f_min_field ,
         max(t.f_expect_field ) as f_max_field
    from dim_tc_beneficial_right t
   group by t.l_prod_id ),
temp_sale_way as
 (select t.l_prod_id, wmsys.wm_concat (distinct t.c_sale_way_n ) as c_sale_way ,
         wmsys.wm_concat (distinct case when c.c_proj_type = '1' then b.c_cust_name else null end ) as c_settlor_name
    from dim_tc_contract t , dim_pb_product a , dim_ca_customer b , dim_pb_project_biz c
   where t.l_prod_id = a.l_prod_id and t.l_settlor_id = b.l_cust_id (+) and a.l_proj_id = c.l_proj_id
     and substr( t.l_effective_date,1 ,6) <= 201612
     and substr( t.l_expiration_date,1 ,6) > 201612
   group by t.l_prod_id ),
temp_ic_rate as
 (select t.l_prod_id,
         min(t.f_rate) as f_min_rate ,
         max(t.f_rate) as f_max_rate
    from dim_ic_rate t
   group by t.l_prod_id ),
temp_fa as (
select t1.l_prod_id, t1.fa_balance, t1.tz_balance , (case when nvl( t1.fa_balance,0 ) - nvl (t2.ta_balance ,0) = 0 then '是' else '否' end ) as f_equal
  from (
select b.l_prod_id, sum (case when c.c_subj_code_l1 = '4001' and c.c_subj_code_l2 <> '400100' then t.f_balance_agg else 0 end) as fa_balance,
       sum( case when c.c_subj_code_l1 in ('1101', '1111','1303' ,'1501', '1503','1531' ,'1541', '1122') then t.f_balance_agg else 0 end ) as tz_balance
  from tt_to_accounting_subj_m t , dim_to_book a , dim_pb_product b , dim_to_subject c
 where t.l_book_id = a.l_book_id and a.l_prod_id = b.l_prod_id and t.l_subj_id = c.l_subj_id
   and t.l_month_id = 201612
 group by b.l_prod_id ) t1 , (select a.l_prod_id , sum(a.f_balance_agg ) over(partition by a.l_proj_id) as ta_balance from temp_prod_scale a ) t2
 where t1.l_prod_id = t2.l_prod_id
  )
select max(l.c_book_code) over(partition by b.c_proj_code order by b.c_proj_code) as 帐套编号,
       b.c_proj_code as 项目编号 ,
       b.c_name_full as 项目名称 ,
       a.c_prod_code as 产品编码 ,
       --a.c_prod_name as 产品名称,
       d.c_dept_name as 业务部门 ,
       c.c_manage_type_n as 管理类型 ,
       c.c_proj_type_n as 项目类型 ,
       c.c_func_type_n as 功能分类 ,
       b.l_setup_date                                 as 项目开始日期 ,
       decode( c.l_pool_flag, 1, b.l_setup_date, a.l_setup_date ) 产品起始日期 ,
       b.l_expiry_date                                          as 项目终止日期 ,
       decode( c.l_pool_flag, 1, b.l_expiry_date, a.l_expiry_date ) 产品终止日期 ,
       nvl( e.f_balance_agg, 0) as 产品受托余额,
       m.fa_balance as FA规模 ,
       max(m.f_equal) over(partition by b.c_proj_code order by b.c_proj_code) as 是否一致 ,
       m.tz_balance as 投资余额 ,
       nvl( decode(c.l_pool_flag , 1, 0, e.f_decrease_agg), 0) as 累计还本,
       nvl( decode(c.l_pool_flag , 1, 0, e.f_increase_eot), 0) as 本年新增规模,
       nvl( decode(a.c_struct_type , '0', e.f_balance_agg , 0), 0) as 优先,
       nvl( decode(a.c_struct_type , '2', e.f_balance_agg , 0), 0) as 劣后,
       (case when k.f_min_rate is null and k.f_max_rate is null then null else to_char(k.f_min_rate * 100 , 'fm9999999990.00') || '%-' || to_char(k.f_max_rate * 100, 'fm9999999990.00')|| '%' end) as 产品信托报酬率 ,
       f.f_planned_xtbc + f.f_planned_xtcgf as 合同总收入 ,
       f.f_planned_xtbc as 信托报酬 ,
       f.f_planned_xtcgf as 财务顾问费 ,
       (case when f.f_planned_xtbc - f.f_actual_xtbc < 0 then 0 else f.f_planned_xtbc - f.f_actual_xtbc end ) as 尚未支付信托报酬 ,
       f.f_actual_xtcgf as 累计已支付财务顾问费 ,
       (case when f.f_planned_xtcgf - f.f_actual_xtcgf < 0 then 0 else f.f_planned_xtcgf - f.f_actual_xtcgf end ) as 尚未支付财务顾问费 ,
       c.c_invest_indus_n as 实质投向 ,
       g.c_inst_name as 单一资金来源 ,
       j.c_sale_way as 集合资金销售渠道 ,
       j.c_settlor_name as 单一合同委托人 ,
       (case when i.f_min_field is null and i.f_max_field is null then null else to_char(i.f_min_field * 100 ,'fm9999999990.00') || '%-' || to_char(i.f_max_field* 100,'fm9999999990.00' )||'%' end) as 预计收益率,
       case
         when nvl(substr (b.l_expiry_date ,1, 6), 209912) > 201612 then
          '存续'
         else
          '清算'
       end as 项目状态 ,
       decode( a.l_tot_flag, 0, '否',1 ,'是', null) as 是否TOT ,
       decode( c.l_pool_flag,0 ,'否', 1,'是' ,null) as 是否资金池,
       row_number() over(partition by b.c_proj_code order by a.c_prod_code) as rn
  from dim_pb_product       a ,
       dim_pb_project_basic b ,
       dim_pb_project_biz   c ,
       dim_pb_department    d ,
       temp_prod_scale     e ,
       temp_prod_revenue   f ,
       dim_pb_institution   g ,
       temp_benefical_right i ,
       temp_sale_way        j ,
       temp_ic_rate         k ,
       dim_to_book          l ,
       temp_fa              m
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and b.l_dept_id = d.l_dept_id (+)
   and c.l_bankrec_ho = g.l_inst_id (+)
   and a.l_prod_id = e.l_prod_id (+)
   and a.l_prod_id = f.l_prod_id (+)
   and substr( b.l_effective_date,1 ,6) <= 201612
   and substr( b.l_expiration_date,1 ,6) > 201612
   and a.l_prod_id = i.l_prod_id (+)
   and a.l_prod_id = j.l_prod_id (+)
   and a.l_prod_id = k.l_prod_id (+)
   and a.l_prod_id = l.l_prod_id (+)
   and a.l_prod_id = m.l_prod_id (+)
 order by b.l_setup_date , b.c_proj_code , l.c_book_code , a.c_prod_code;
