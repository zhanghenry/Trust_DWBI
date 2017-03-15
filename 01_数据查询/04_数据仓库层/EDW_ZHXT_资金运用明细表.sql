--资金运用明细底表
with temp_cont_scale as (
select t.l_month_id,
       a.l_cont_id,
       b.l_prod_id,
       b.l_proj_id,
       sum(t.f_balance_agg) f_agg,
       sum(decode(trunc(b.l_setup_date / 10000), 2016, t.f_balance_agg, t.f_invest_eot)) f_inc_eot,
       sum(t.f_return_agg) f_dec_agg
  from tt_ic_invest_cont_m t, dim_ic_contract a, dim_pb_product b
 where t.l_cont_id = a.l_cont_id
   and a.l_prod_id = b.l_prod_id
   and t.l_month_id =
       to_char(To_Date('31-12-2016', 'dd-mm-yyyy'), 'yyyymm')
   and a.l_effective_date <= 20161231
   and a.l_expiration_date > 20161231
 group by t.l_month_id, a.l_cont_id, b.l_prod_id, b.l_proj_id),
temp_zc_fa as (
select distinct t1.l_prod_id,
                t1.fa_balance,
                t1.tz_balance,
                t2.ta_balance,
                tz_balance_xd,
                (case when nvl(t1.tz_balance, 0) - nvl(t2.ta_balance, 0) = 0 then '是' else  '否' end) as f_equal
  from (select b.l_prod_id,
               sum(case when c.c_subj_code_l1 = '4001' and c.c_subj_code_l2 <> '400100' then t.f_balance_agg else 0 end) as fa_balance,
               sum(case when c.c_subj_code_l1 in ('1101', '1111', '1303', '1501', '1503', '1531', '1541', '1122', '1511') then t.f_balance_agg else 0 end) as tz_balance,
               sum(case when c.c_subj_code_l1 in ('1303') then t.f_balance_agg else 0 end) as tz_balance_xd
          from tt_to_accounting_subj_m t,
               dim_to_book             a,
               dim_pb_product          b,
               dim_to_subject          c
         where t.l_book_id = a.l_book_id
           and a.l_prod_id = b.l_prod_id
           and t.l_subj_id = c.l_subj_id
           and substr(c.l_Effective_Date, 1, 6) <= t.l_month_id
           and substr(c.l_expiration_date, 1, 6) > t.l_month_id
           and t.l_month_id =
               to_char(To_Date('31-12-2016', 'dd-mm-yyyy'), 'yyyymm')
         group by b.l_prod_id) t1,
       (select a.l_prod_id,
               sum(a.f_agg) over(partition by a.l_proj_id) as ta_balance
          from temp_cont_scale a) t2
 where t1.l_prod_id = t2.l_prod_id)
select h.c_book_code as "账套编号(FA)",
       c.c_proj_code as "项目编号(TCMP)",
       c.c_name_full as "项目名称(TCMP)",
       i.c_dept_name as "业务部门(TCMP)",
       d.c_manage_type_n as "管理类型(TCMP)",
       d.c_proj_type_n as "项目类型(TCMP)",
       d.c_func_type_n as "功能分类(BULU)",
       d.c_invest_indus_n"项目实质投向(BULU)",
       to_date(c.l_setup_date, 'yyyymmdd') as "项目开始日期(TCMP)",
       to_date(c.l_expiry_date, 'yyyymmdd') as "项目终止日期(TCMP)",
       to_date(c.l_preexp_date, 'yyyymmdd') as "项目预计到期(TCMP)",
       case
         when nvl(substr(c.l_expiry_date, 1, 6), 209912) > 201612 then
          '存续'
         else
          '清算'
       end as "项目状态(TCMP)",
       decode(d.l_pool_flag, 0, '否', 1, '是', null) as "是否资金池(BULU)",
       decode(d.c_special_type, 'A', '是', '否') as "普惠金融(TCMP)",
       decode(d.l_pitch_flag, 0, '否', 1, '是', null) as "是否场内场外(TCMP)",
       a.c_cont_code as "合同代码(AM)",
       a.c_cont_name as "合同名称(AM)",
       to_date(a.l_begin_date, 'yyyymmdd') as "合同起始日(AM)",
       to_date(a.l_expiry_date, 'yyyymmdd') as "合同终止日(AM)",
       a.c_busi_type_n as "合同类型(AM)",
       a.c_invest_indus_n as "合同实质投向(BULU)",
       a.c_real_party as "实质交易对手(BULU)",
       g.c_party_name as "合同交易对手(AM)",
       a.c_invest_way_n as "投资方式(BULU)",
       a.c_fduse_way_n as "资金用途及退出方式(BULU)",
       f.c_indus_name as "投资行业(BULU)",
       e.c_prov_name as "资金运用省份(BULU)",
       e.c_city_name as "资金运用城市(BULU)",
       a.f_cost_rate as "融资成本(AM)",
       decode(d.l_pitch_flag, 0, t1.f_agg, 1, t2.tz_balance, 0) as "投资合同规模",
       t1.f_inc_eot as "本年新增规模",
       t1.f_dec_agg as "累计返本",
       count(a.c_cont_code) over(partition by h.c_book_code),
       round(t2.tz_balance / count(a.c_cont_code)
             over(partition by h.c_book_code),
             2) as "FA投资规模",
       t2.f_equal as "是否与FA一致",
       null as "合作伙伴(BULU)",
       null as "是否签署类战略合作协议(BULU)",
       null as "非证券投资行业(BULU)",
       null as "非证券投资方式(BULU)",
       null as "公司战略业务(BULU)",
       null as "PPP财政收入(BULU)",
       null as "PPP项目属性(BULU)",
       null as "PPP项目主导方(BULU)",
       null as "PPP主要还款来源(BULU)",
       null as "不动产类型(BULU)",
       null as "绿色信托类型(BULU)",
       null as "普惠金融服务商(BULU)",
       null as "普惠金融业务类型(BULU)"
  from temp_cont_scale             t1 ,
       temp_zc_fa                  t2 ,
       dim_ic_contract             a ,
       dim_pb_product              b ,
       dim_pb_project_basic        c ,
       dim_pb_project_biz          d ,
       dim_pb_area                 e ,
       dim_pb_industry             f ,
       dim_ic_counterparty         g ,
       dim_to_book                 h ,
       dim_pb_department           i
 where t1.l_prod_id = t2.l_prod_id (+)
   and t1.l_cont_id = a.l_cont_id
   and a.l_prod_id = b.l_prod_id
   and b.l_proj_id = c.l_proj_id
   and c.l_proj_id = d.l_proj_id
   and a.l_fduse_area = e.l_area_id (+)
   and a.l_invindus_id = f.l_indus_id (+)
   and a.l_party_id = g.l_party_id (+)
   and a.l_prod_id = h.l_prod_id (+)
   and c.l_dept_id = i.l_dept_id (+)
   and ( nvl( d.c_special_type,'0' ) <> 'A' or nvl(a.c_busi_type ,'0') <> '1' )
   and substr(c.l_Effective_Date,1,6) <= t1.l_month_id
   and substr(c.l_expiration_date,1,6) > t1.l_month_id
 union all
select max (h.c_book_code ) as "账套编号(FA)" ,
       max( c.c_proj_code) as "项目编号(TCMP)" ,
       max( c.c_name_full) as "项目名称(TCMP)" ,
       max( i.c_dept_name) as "业务部门(TCMP)" ,
       max( d.c_manage_type_n) as "管理类型(TCMP)" ,
       max( d.c_proj_type_n) as "项目类型(TCMP)" ,
       max( d.c_func_type_n) as "功能分类(BULU)" ,
       max( d.c_invest_indus_n) as "项目实质投向(BULU)" ,
       to_date (max( c.l_setup_date) ,'yyyymmdd' ) as "项目开始日期(TCMP)" ,
       to_date (max( c.l_expiry_date) ,'yyyymmdd' ) as "项目终止日期(TCMP)" ,
       to_date (max( c.l_preexp_date) ,'yyyymmdd' ) as "项目预计到期(TCMP)" ,
       max( case when nvl( substr ( c.l_expiry_date ,1 , 6), 209912 ) > 201612 then '存续' else '清算' end ) as "项目状态(TCMP)" ,
       max( decode( d.l_pool_flag ,0 , '否' , 1, '是' , null )) as "是否资金池(BULU)" ,
       max( decode( d.c_special_type , 'A', '是', '否' )) as "普惠金融(TCMP)" ,
       max( decode( d.l_pitch_flag, 0 , '否' , 1 , '是' , null )) as "是否场内场外(TCMP)" ,
       'XEDK' as "合同代码(AM)" ,
       '小额贷款合同' as "合同名称(AM)" ,
       to_date (min( a.l_begin_date),'yyyymmdd' ) as "合同起始日(AM)" ,
       to_date (max( a.l_expiry_date), 'yyyymmdd') as "合同终止日(AM)" ,
       max( a.c_busi_type_n) as "合同类型(AM)" ,
       '其他' as "合同实质投向(BULU)" ,
       '小贷专用对手方方' as "实质交易对手(BULU)" ,
       '小贷专用对手方方' as "合同交易对手(AM)" ,
       max( a.c_invest_way_n) as "投资方式(BULU)" ,
       max( a.c_fduse_way_n) as "资金用途及退出方式(BULU)" ,
       max( f.c_indus_name) as "投资行业(BULU)" ,
       max( e.c_prov_name) as "资金运用省份(BULU)" ,
       max( e.c_city_name) as "资金运用城市(BULU)" ,
       max( a.f_cost_rate) as "融资成本(AM)" ,
       sum( t2.tz_balance_xd) as "投资合同规模" ,
       sum( t1.f_inc_eot) as "本年新增规模" ,
       sum( t1.f_dec_agg) as "累计返本" ,
       null,
       sum( t2.tz_balance_xd) as "FA投资规模",
       '是' as "是否与FA一致" ,
       null as "合作伙伴(BULU)" ,
       null as "是否签署类战略合作协议(BULU)" ,
       null as "非证券投资行业(BULU)" ,
       null as "非证券投资方式(BULU)" ,
       null as "公司战略业务(BULU)" ,
       null as "PPP财政收入(BULU)" ,
       null as "PPP项目属性(BULU)" ,
       null as "PPP项目主导方(BULU)" ,
       null as "PPP主要还款来源(BULU)" ,
       null as "不动产类型(BULU)" ,
       null as "绿色信托类型(BULU)" ,
       null as "普惠金融服务商(BULU)" ,
       null as "普惠金融业务类型(BULU)"
  from temp_cont_scale             t1 ,
       temp_zc_fa                  t2 ,
       dim_ic_contract             a ,
       dim_pb_product              b ,
       dim_pb_project_basic        c ,
       dim_pb_project_biz          d ,
       dim_pb_area                 e ,
       dim_pb_industry             f ,
       dim_ic_counterparty         g ,
       dim_to_book                 h ,
       dim_pb_department           i
 where t1.l_prod_id = t2.l_prod_id (+)
   and t1.l_cont_id = a.l_cont_id
   and a.l_prod_id = b.l_prod_id
   and b.l_proj_id = c.l_proj_id
   and c.l_proj_id = d.l_proj_id
   and a.l_fduse_area = e.l_area_id (+)
   and a.l_invindus_id = f.l_indus_id (+)
   and a.l_party_id = g.l_party_id (+)
   and a.l_prod_id = h.l_prod_id (+)
   and c.l_dept_id = i.l_dept_id (+)
   and d.c_special_type = 'A' and a.c_busi_type = '1'
 group by c.c_proj_code ;
