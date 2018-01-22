create or replace view v_detail as
with temp_prod_scale as
 (select a.l_prod_id,
               a.l_proj_id,
               sum(t.f_balance_agg) as f_balance_agg,
               sum(t.f_increase_eot) as f_increase_eot,
               sum(decode(trunc(a.l_setup_date / 10000),
                          trunc(t.l_month_id /100),
                          t.f_balance_agg,
                          t.f_increase_eot)) as f_net_inc_eot,
               sum(decode(trunc(b.l_expiry_date / 10000),
                          trunc(t.l_month_id /100),
                          t.f_decrease_agg,
                          0)) as f_decrease_eot,
               sum(t.f_decrease_agg) as f_decrease_agg
          from dim_pb_product a,
               dim_pb_project_basic b,
               (select * from tt_tc_scale_cont_m where l_month_id = to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')) t
         where a.l_prod_id = t.l_prod_id(+)
           and a.l_proj_id = b.l_proj_id
           and substr(a.l_effective_date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
           and substr(a.l_expiration_date, 1, 6) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
         group by a.l_prod_id, a.l_proj_id, b.l_expiry_date),
temp_prod_revenue as
 (
  select tt.*,
  sum(tt.f_actual_xtbc)over(partition by tt.l_proj_id)  as f_proj_actual_xtbc,
  sum(tt.f_planned_xtbc)over(partition by tt.l_proj_id)  as f_proj_planned_xtbc,
  sum(tt.f_actual_xtcgf)over(partition by tt.l_proj_id)  as f_proj_actual_xtcgf,
  sum(tt.f_planned_xtcgf)over(partition by tt.l_proj_id)  as f_proj_planned_xtcgf  from (
  select t.l_prod_id,
         t.l_proj_id,
       nvl(sum(decode(t1.c_ietype_code_l2, 'XTBC', t.f_actual_agg, 0)), 0) as f_actual_xtbc, --累计已支付信托报酬
       nvl(sum(decode(t1.c_ietype_code_l2, 'XTBC', t.f_actual_eot, 0)), 0) as f_actual_xtbc_eot, --本年已支付信托报酬
       nvl(sum(decode(t1.c_ietype_code_l2, 'XTCGF', t.f_actual_agg, 0)), 0) as f_actual_xtcgf, --累计已支付信托财顾费
       nvl(sum(decode(t1.c_ietype_code_l2, 'XTCGF', t.f_actual_eot, 0)), 0) as f_actual_xtcgf_eot, --本年已支付信托财顾费
       nvl(sum(decode(t1.c_ietype_code_l2, 'XTBC', t.f_planned_agg, 0)), 0) as f_planned_xtbc, --累计计划信托报酬
       nvl(sum(decode(t1.c_ietype_code_l2, 'XTCGF', t.f_planned_agg, 0)), 0) as f_planned_xtcgf, --累计计划财顾费
       nvl(sum(decode(t1.c_ietype_code, 'XTBLBC', t.f_planned_agg, 0)), 0) as f_planned_xtblbc --累计计划信托报酬调整项
  from tt_ic_ie_prod_m t, dim_pb_ie_type t1,dim_pb_product t2
 where t.l_month_id = to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and t.l_ietype_id = t1.l_ietype_id
   and t.l_prod_id = t2.l_prod_id
   and substr(t2.l_effective_date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and substr(t2.l_expiration_date, 1, 6) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
 group by t.l_prod_id,t.l_proj_id) tt),
temp_benefical_right as
 (select t.l_prod_id,
       min(t.f_expect_field) as f_min_field,
       max(t.f_expect_field) as f_max_field
  from dim_tc_beneficial_right t, dim_pb_product t1
 where t.l_prod_id = t1.l_prod_id
   and substr(t1.l_effective_date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and substr(t1.l_expiration_date, 1, 6) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
 group by t.l_prod_id),
temp_sale_way as
 (select t.l_prod_id,
       wmsys.wm_concat(distinct t.c_sale_way_n) as c_sale_way,
       wmsys.wm_concat(distinct case
                         when c.c_proj_type = '1' then
                          b.c_cust_name
                         else
                          null
                       end) as c_benefic_name
  from dim_tc_contract    t,
       dim_pb_product     a,
       dim_ca_customer    b,
       dim_pb_project_biz c
 where t.l_prod_id = a.l_prod_id
   and t.l_benefic_id = b.l_cust_id(+)
   and a.l_proj_id = c.l_proj_id
   and substr(t.l_effective_date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and substr(t.l_expiration_date, 1, 6) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
 group by t.l_prod_id),
temp_ic_rate as
 (select t.l_prod_id,
       min(t.f_rate) as f_min_rate,
       max(t.f_rate) as f_max_rate
  from dim_ic_rate t, dim_pb_product t1
 where t.l_prod_id = t1.l_prod_id
   and substr(t1.l_effective_date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and substr(t1.l_expiration_date, 1, 6) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
 group by t.l_prod_id),
temp_fa as (
select a.c_book_code,
       b.l_prod_id,
       a.l_proj_id,
       sum(case
             when c.c_subj_code_l1 = '4001' and c.c_subj_code_l2 <> '400100' then
              t.f_balance_agg
             else
              0
           end) as fa_balance,
       sum(case
             when c.c_subj_code_l1 in ('1101', '1111','1303','1501','1503','1531','1541','1122','1511') then
              t.f_balance_agg
             else
              0
           end) as tz_balance
  from tt_to_accounting_subj_m t,
       dim_to_book             a,
       dim_pb_product          b,
       dim_to_subject          c
 where t.l_book_id = a.l_book_id
   and a.l_prod_id = b.l_prod_id
   and t.l_subj_id = c.l_subj_id
   and t.l_month_id = to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and c.l_effective_flag = 1
 group by a.c_book_code,b.l_prod_id,a.l_proj_id),
temp_fa_book as (
select *
  from (select row_number() over(partition by b.l_proj_id,a.l_prod_id order by b.c_book_code desc) as l_rn,
               a.l_prod_id,
               b.c_book_code
          from dim_pb_product a, dim_to_book b
         where a.l_proj_id = b.l_proj_id )
 where l_rn = 1
),
temp_fa_book_mprod as (
select a.l_prod_id, b.c_book_code
  from dim_pb_product a, dim_to_book b
 where a.l_mprod_id = b.l_prod_id
   and a.l_mprod_id <> 0
   and substr(b.l_effective_date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and substr(b.l_expiration_date, 1, 6) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
)
select nvl(p.c_book_code,nvl(n.c_book_code,m.c_book_code)) as "帐套编号",
       b.c_proj_code as "项目编号" ,
       b.c_name_full as "项目名称" ,
       d.c_dept_name as "业务部门" ,
       a.c_manage_type_n as "产品管理类型" ,
       c.c_proj_type_n as "项目类型" ,
       a.c_func_type_n as "产品功能分类" ,
       a.c_invest_indus_n as "产品实质投向" ,
       to_date (b.l_setup_date ,'yyyymmdd') as "项目开始日期" ,
       to_date (b.l_expiry_date ,'yyyymmdd') as "项目终止日期" ,
       to_date (b.l_preexp_date ,'yyyymmdd') as "项目预计到期" ,
       case when nvl( b.l_expiry_date, 20991231 ) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymmdd') then '存续' else '清算' end as "项目状态" ,
       decode( c.l_pool_flag,0 , '否' , 1 , '是' , null ) as "是否资金池" ,
       decode( c.c_special_type, 'A', '是' ,'否' ) as "是否小贷" ,
       a.c_prod_code as "产品编码" ,
       to_date (a.l_setup_date ,'yyyymmdd') "产品起始日期" ,
       to_date (a.l_expiry_date,'yyyymmdd') "产品终止日期" ,
       to_date (a.l_preexp_date ,'yyyymmdd') "产品清算日期" ,
       --g.c_inst_name as "单一资金来源(BULU)" ,
       --j.c_sale_way as "集合资金销售渠道(TA)" ,
       j.c_benefic_name as "单一合同受益人" ,
       (case when i.f_min_field is null and i.f_max_field is null then null else to_char(i.f_min_field * 100 , 'fm9999999990.00' ) || '%-' || to_char (i.f_max_field * 100 ,'fm9999999990.00' )|| '%' end) as 预计收益率 ,
       a.f_trustpay_rate,
       decode( a.l_tot_flag, 0, '否' , 1 , '是' , null ) as "是否TOT" ,
       nvl( e.f_balance_agg, 0) as 产品受托余额,
       nvl( decode ( a.c_struct_type , '0', e.f_balance_agg , 0), 0 ) as 优先 ,
       nvl( decode ( a.c_struct_type , '2', e.f_balance_agg , 0), 0 ) as 劣后 ,
       nvl( decode ( c.l_pool_flag , 1, 0 , e.f_decrease_agg ), 0) as 累计还本 ,
       nvl( decode ( c.l_pool_flag , 1, 0 , e.f_net_inc_eot ), 0) as 本年新增规模 ,
       nvl( e.f_decrease_eot,0 ) as 本年清算规模 ,
       m.fa_balance as FA规模 ,
       decode(nvl(sum(e.f_balance_agg)over(partition by a.l_proj_id),0),nvl(sum(nvl(m.fa_balance,0))over(partition by a.l_proj_id),0),'是','否') as 是否一致 ,
       m.tz_balance as 投资余额 ,
       to_char ((decode(k.f_min_rate,null,null,k.f_min_rate*100)), 'fm9999999990.00' )|| (decode(k.f_min_rate,null,null,'%')) as 产品信托报酬率 ,
       f.f_planned_xtbc + f.f_planned_xtcgf as 合同总收入 ,
       f.f_planned_xtbc as 信托报酬 ,
       f.f_planned_xtblbc as 信托报酬调整项 ,
       f.f_actual_xtbc as 累计支付信托报酬 ,
       (case when f.f_proj_planned_xtbc - f.f_proj_actual_xtbc < 0 then 0 else f.f_planned_xtbc - f.f_actual_xtbc end ) as 尚未支付信托报酬 ,
       f.f_planned_xtcgf as 财务顾问费 ,
       f.f_actual_xtcgf as 累计已支付财务顾问费 ,
       (case when f.f_proj_planned_xtcgf - f.f_proj_actual_xtcgf < 0 then 0 else f.f_planned_xtcgf - f.f_actual_xtcgf end ) as 尚未支付财务顾问费 ,
       f.f_actual_xtbc_eot as 本年支付信托报酬 ,
       f.f_actual_xtcgf_eot as 本年已支付财务顾问费,
       decode(c.l_openend_flag,1,'是','否') as "是否开放式"
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
       temp_fa              m,
       temp_fa_book         n,
       temp_fa_book_mprod   p
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and b.l_dept_id = d.l_dept_id (+)
   and c.l_bankrec_ho = g.l_inst_id (+)
   and a.l_prod_id = e.l_prod_id (+)
   and a.l_prod_id = f.l_prod_id (+)
   and substr( b.l_effective_date,1 , 6 ) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and substr( b.l_expiration_date,1 , 6 ) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and a.l_prod_id = i.l_prod_id (+)
   and a.l_prod_id = j.l_prod_id (+)
   and a.l_prod_id = k.l_prod_id (+)
   and a.l_prod_id = m.l_prod_id (+)
   and a.l_prod_id = n.l_prod_id(+)
   and a.l_prod_id = p.l_prod_id(+)
   and to_date(a.l_setup_date,'yyyymmdd') >= To_Date('01-01-2000', 'dd-mm-yyyy')
order by b.l_setup_date , b.c_proj_code , m.c_book_code , a.c_prod_code;
