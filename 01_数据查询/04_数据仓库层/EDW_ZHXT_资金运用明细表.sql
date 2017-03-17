--资金运用底表查询语句--新   
select v4."账套编号(FA)",
       v1."项目编号(TCMP)",
       v1."项目名称(TCMP)",
       v1."业务部门(TCMP)",
       v1."管理类型(TCMP)",
       v1."项目类型(TCMP)",
       v1."功能分类(BULU)",
       v1."项目实质投向(BULU)",
       v1."项目开始日期(TCMP)",
       v1."项目终止日期(TCMP)",
       v1. "项目预计到期(TCMP)",
       v1."项目状态(TCMP)",
       v1."是否资金池(BULU)",
       v1."普惠金融(TCMP)",
       v1."是否场内场外(TCMP)",
       v2."合同代码(AM)",
       v2."合同名称(AM)",
       v2."合同起始日(AM)",
       v2."合同终止日(AM)",
       v2."合同类型(AM)",
       v2."合同实质投向(BULU)",
       v2."实质交易对手(BULU)",
       v2."合同交易对手(AM)",
       v2."投资方式(BULU)",
       v2."资金用途(BULU)",
       v2."退出方式(BULU)",
       v2."投资行业(BULU)",
       v2."资金运用省份(BULU)",
       v2."资金运用城市(BULU)",
       v2."融资成本(AM)",
       v3."投资合同规模",
       v3."本年新增规模",
       v3."累计返本",
       decode(v2.l_cont_id,null,v4.f_balance_zc,v3.f_invest_ratio*v4.f_balance_zc) as "FA投资规模",
       decode(sum(nvl(v3.投资合同规模,0))over(partition by v1.l_proj_id),sum(nvl(v4.f_balance_zc,0))over(partition by v1.l_proj_id)/nvl(count(v4.f_balance_zc)over(partition by v1.l_proj_id),1),'是','否') "是否与FA一致",
       v2."合作伙伴(BULU)",
       v2."是否签署类战略合作协议(BULU)",
       v2."非证券投资行业(BULU)",
       v2."非证券投资方式(BULU)",
       v2."公司战略业务(BULU)",
       v2."PPP财政收入(BULU)",
       v2."PPP项目属性(BULU)",
       v2."PPP项目主导方(BULU)",
       v2."PPP主要还款来源(BULU)",
       v2."不动产类型(BULU)",
       v2."绿色信托类型(BULU)",
       v2."普惠金融服务商(BULU)",
       v2."普惠金融业务类型(BULU)",
       v2. "合作政府级别"
  from v_pb_proj_info v1,v_to_balance_proj_m v4, v_ic_cont_info v2,v_ic_invest_cont_m v3
 where v1.l_proj_id = v4.l_proj_id
   and v1.l_prod_id = v4.l_prod_id
   and v1.l_proj_id = v2.l_proj_id(+)
   and v1.l_prod_id = v2.l_prod_id(+)
   and v2.l_cont_id = v3.l_cont_id(+);

--20170315之前
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
           and c.l_effective_flag = 1
           and t.l_month_id = to_char(To_Date('31-12-2016', 'dd-mm-yyyy'), 'yyyymm')
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
       case  when nvl(substr(c.l_expiry_date, 1, 6), 209912) > 201612 then '存续' else '清算' end as "项目状态(TCMP)",
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
       --decode(d.l_pitch_flag, 0, t1.f_agg, 1, t2.tz_balance, 0) as "投资合同规模",
       decode(d.c_special_type,'A',0,t1.f_agg)as "投资合同规模",
       t1.f_inc_eot as "本年新增规模",
       t1.f_dec_agg as "累计返本",
       count(a.c_cont_code) over(partition by h.c_book_code),
       decode(d.c_special_type,'A',0,round(t2.tz_balance / count(a.c_cont_code) over(partition by h.c_book_code), 2)) as "FA投资规模",
       t2.f_equal as "是否与FA一致",
       a.c_coop_partner as "合作伙伴(BULU)",
       a.l_strategic_flag as "是否签署类战略合作协议(BULU)",
       null as "非证券投资行业(BULU)",
       null as "非证券投资方式(BULU)",
       a.c_special_type_n as "公司战略业务(BULU)",
       a.c_fiscal_revenue_n as "PPP财政收入(BULU)",
       decode(a.c_special_type,'7',a.c_subspecial_type_n,null) as "PPP项目属性(BULU)",
       a.c_leading_party as "PPP项目主导方(BULU)",
       a.c_repay_way_n as "PPP主要还款来源(BULU)",
       decode(a.c_special_type,'4',a.c_subspecial_type_n,null) as "不动产类型(BULU)",
       decode(a.c_special_type,'5',a.c_subspecial_type_n,null) as "绿色信托类型(BULU)",
       a.c_servicer as "普惠金融服务商(BULU)",
       decode(a.c_special_type,'1',a.c_subspecial_type_n,null) as "普惠金融业务类型(BULU)"
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
   and (nvl( d.c_special_type,'0' ) <> 'A' OR (nvl( d.c_special_type,'0' ) = 'A' and a.c_busi_type=  '1')) --不取小贷非贷款的合同
   and a.c_cont_type <> '99'--不取虚拟合同
   and substr(c.l_Effective_Date,1,6) <= t1.l_month_id
   and substr(c.l_expiration_date,1,6) > t1.l_month_id
union all
select t5.c_book_code as "账套编号(FA)",
       t2.c_proj_code as "项目编号(TCMP)",
       t2.c_name_full as "项目名称(TCMP)",
       t4.c_dept_name as "业务部门(TCMP)",
       t3.c_manage_type_n as "管理类型(TCMP)",
       t3.c_proj_type_n as "项目类型(TCMP)",
       t3.c_func_type_n as "功能分类(BULU)",
       t3.c_invest_indus_n as "项目实质投向(BULU)",
       to_date(t2.l_setup_date, 'yyyymmdd') as "项目开始日期(TCMP)",
       to_date(t2.l_expiry_date, 'yyyymmdd') as "项目终止日期(TCMP)",
       to_date(t2.l_preexp_date, 'yyyymmdd') as "项目预计到期(TCMP)",
       case when nvl(substr(t2.l_expiry_date, 1, 6), 209912) > 201612 then  '存续' else  '清算' end as "项目状态(TCMP)",
       decode(t3.l_pool_flag, 0, '否', 1, '是', null) as "是否资金池(BULU)",
       decode(t3.c_special_type, 'A', '是', '否') as "普惠金融(TCMP)",
       decode(t3.l_pitch_flag, 0, '否', 1, '是', null) as "是否场内场外(TCMP)",
       substr(t1.c_cont_code,1,4) as "合同代码(AM)",
       decode(substr(t1.c_cont_code,1,4),'XEDK','小额贷款','场外投资') as "合同名称(AM)",
       null as "合同起始日(AM)",
       null as "合同终止日(AM)",
       null as "合同类型(AM)",
       null "合同实质投向(BULU)",
       null "实质交易对手(BULU)",
       null "合同交易对手(AM)",
       null as "投资方式(BULU)",
       null as "资金用途及退出方式(BULU)",
       null as "投资行业(BULU)",
       null as "资金运用省份(BULU)",
       null as "资金运用城市(BULU)",
       null as "融资成本(AM)",
       t6.f_balance_agg as "投资合同规模",
       null as "本年新增规模",
       null as "累计返本",
       null,
       t7.tz_balance as "FA投资规模",
       decode(t6.f_balance_agg,t7.tz_balance,'是','否') as "是否与FA一致",
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
  from dim_ic_contract      t1,
       dim_pb_project_basic t2,
       dim_pb_project_biz   t3,
       dim_pb_department    t4,
       dim_to_book          t5,
       tt_ic_invest_cont_m  t6,
       temp_zc_fa           t7
 where t1.c_cont_type = '99'
   and t1.l_proj_id = t2.l_proj_id
   and t2.l_proj_id = t3.l_proj_id
   and t2.l_dept_id = t4.l_dept_id
   and t1.l_prod_id = t5.l_prod_id(+)
   and t1.l_cont_id = t6.l_cont_id
   and t2.l_proj_id = t6.l_proj_id
   and t1.l_prod_id = t7.l_prod_id(+)
   and t1.l_effective_flag = 1
   and t6.l_month_id = 201612;
     
create or replace view v_zhxt_zjjjdb as
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
       case when nvl(substr(c.l_expiry_date, 1, 6), 209912) > 201612 then  '存续' else '清算' end as "项目状态(TCMP)",
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
       j.f_balance_agg as "投资合同规模",
       j.f_invest_eot as "本年新增规模",
       j.f_return_agg as "累计返本",
       --count(a.c_cont_code) over(partition by h.c_book_code),
       k.f_balance_zc,
       j.f_invest_ratio,
       k.f_balance_zc*j.f_invest_ratio "FA投资规模",
       null as "是否与FA一致",
       a.c_coop_partner as "合作伙伴(BULU)",
       a.l_strategic_flag as "是否签署类战略合作协议(BULU)",
       null as "非证券投资行业(BULU)",
       null as "非证券投资方式(BULU)",
       a.c_special_type_n as "公司战略业务(BULU)",
       a.c_fiscal_revenue_n as "PPP财政收入(BULU)",
       decode(a.c_special_type, '7', a.c_subspecial_type_n, null) as "PPP项目属性(BULU)",
       a.c_leading_party as "PPP项目主导方(BULU)",
       a.c_repay_way_n as "PPP主要还款来源(BULU)",
       decode(a.c_special_type, '4', a.c_subspecial_type_n, null) as "不动产类型(BULU)",
       decode(a.c_special_type, '5', a.c_subspecial_type_n, null) as "绿色信托类型(BULU)",
       a.c_servicer as "普惠金融服务商(BULU)",
       decode(a.c_special_type, '1', a.c_subspecial_type_n, null) as "普惠金融业务类型(BULU)",
       a.c_gov_level_n as "合作政府级别"
  from dim_pb_project_basic c,
       dim_pb_project_biz   d,
       dim_ic_contract      a,
       dim_pb_product       b,
       dim_pb_area          e,
       dim_pb_industry      f,
       dim_ic_counterparty  g,
       dim_to_book          h,
       dim_pb_department    i,
       v_ic_invest_cont_m   j,
       v_to_balance_proj_m  k
 where c.l_proj_id = d.l_proj_id
   and c.l_proj_id = b.l_proj_id(+)
   and c.l_dept_id = i.l_dept_id(+)
   and c.l_proj_id = k.l_proj_id(+)
   and c.l_proj_id = a.l_proj_id(+)
   and a.l_fduse_area = e.l_area_id(+)
   and a.l_invindus_id = f.l_indus_id(+)
   and a.l_party_id = g.l_party_id(+)
   and a.l_prod_id = h.l_prod_id(+)
   and a.l_cont_id = j.L_CONT_ID(+)
   and ((nvl(d.c_special_type, '0') <> 'A' and  a.c_busi_type <> '1') or nvl(a.c_cont_type,'99') = '99') --不取小贷且贷款的合同
   --and c.l_setup_date <= 20161231
   and j.L_MONTH_ID = 201612
   and k.l_month_id = 201612
   and c.c_proj_code = 'AVICTC2015X1517'
   and substr(c.l_Effective_Date, 1, 6) <= j.l_month_id
   and substr(c.l_expiration_date, 1, 6) > j.l_month_id;
