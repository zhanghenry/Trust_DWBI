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
