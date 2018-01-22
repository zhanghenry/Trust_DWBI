create or replace view v2 as
with v_pb_proj_info1 as (
select pb1.l_proj_id,
       pb3.l_prod_id,
       to_date(pb3.l_setup_date,'yyyymmdd')        as "产品成立日"，
       pb1.c_proj_code          as "项目编号",
       pb1.c_name_full          as "项目名称",
       pb4.c_dept_name          as "业务部门",
       pb2.c_manage_type_n      as "项目管理类型",
       pb2.c_proj_type_n        as "项目类型",
       pb3.c_func_type_n        as "产品功能分类",
       pb3.c_invest_indus_n     as "产品实质投向",
       to_date(pb1.l_setup_date, 'yyyymmdd')                as "项目开始日期",
       to_date(pb1.l_expiry_date, 'yyyymmdd')               as "项目终止日期",
       to_date(pb1.l_preexp_date, 'yyyymmdd')               as "项目预计到期",
       case when nvl(substr(pb1.l_expiry_date, 1, 6), 209912) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm') then  '存续' else '清算' end as "项目状态",
       decode(pb2.l_pool_flag, 0, '否', 1, '是', null)  as "是否资金池",
       decode(pb2.c_special_type, 'A', '是', '否')      as "普惠金融",
       decode(pb2.l_pitch_flag, 0, '否', 1, '是', null) as "是否场内场外",
       decode(pb2.l_openend_flag, 0, '否', 1, '是', null) as "是否开放式"
  from dim_pb_project_basic pb1,
       dim_pb_project_biz   pb2,
       dim_pb_product       pb3,
       dim_pb_department    pb4
 where pb1.l_proj_id = pb2.l_proj_id
   and pb1.l_setup_date <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymmdd')
   and substr(pb1.l_Effective_Date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and substr(pb1.l_expiration_date, 1, 6) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and pb1.l_proj_id = pb3.l_proj_id
   and pb1.l_dept_id = pb4.l_dept_id),

v_to_balance_proj_m1 as (
select tt."L_MONTH_ID",tt."C_BOOK_CODE",tt."L_BOOK_ID",tt."L_PROJ_ID",tt."L_PROD_ID",tt."账套编号",tt."F_BALANCE_SCALE",tt."F_BALANCE_ZC",tt."F_BALANCE_DK",sum(tt.f_balance_zc)over(partition by tt.l_proj_id)  as f_proj_balance_zc from (
select to3.l_month_id, to1.c_book_code, to1.l_book_id, to1.l_proj_id, to1.l_prod_id,
       to1.c_book_code as "账套编号",
       sum(case when to2.c_subj_code_l1 = '4001' and to2.c_subj_code_l2 <> '400100' then to3.f_balance_agg else 0 end)                              as f_balance_scale,
       sum(case when to2.c_subj_code_l1 in ('1101', '1111', '1303', '1501','1503','1531','1541','1122','1511') then to3.f_balance_agg else 0 end) as f_balance_zc,
       sum(case when to2.c_subj_code_l1 in ('1303') then to3.f_balance_agg else 0 end)                                                            as f_balance_dk
  from dim_to_book to1, dim_to_subject to2, tt_to_accounting_subj_m to3
 where to1.l_book_id = to2.l_book_id
   and to1.l_book_id = to3.l_book_id
   and to2.l_subj_id = to3.l_subj_id
   and substr(to2.l_effective_date, 1, 6) <= to3.l_month_id
   and substr(to2.l_expiration_date, 1, 6) > to3.l_month_id
   --and to2.l_effective_flag = 1
   and to3.l_month_id = to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
 group by to3.l_month_id, to1.c_book_code,to1.l_book_id,to1.l_proj_id,to1.l_prod_id,to1.c_book_code) tt),

temp_special_type as (
select t.l_cont_id,
         listagg(t.c_props_type_n, ',') within group(order by t.l_cont_id, t.c_props_type) as c_special_type_n
    from dim_ic_contract_derive t
   where t.l_effective_flag = 1
   group by t.l_cont_id),
v_ic_cont_info1 as (
select ic1.l_proj_id,
       ic1.l_prod_id,
       ic1.l_cont_id,
       ic1.c_cont_code                          as "合同代码",
       ic1.c_cont_name                          as "合同名称",
       to_date(ic1.l_begin_date, 'yyyymmdd')    as "合同起始日",
       to_date(ic1.l_expiry_date, 'yyyymmdd')   as "合同终止日",
       decode(pb2.l_pitch_flag,1,'其他投资',ic1.c_busi_type_n)    as "合同类型",
       (case when nvl(pb2.c_special_type, '0') = 'A' and nvl(ic1.c_cont_type,'XN') = 'XN' and ic1.c_invest_indus_n is null then '其他'
        else ic1.c_invest_indus_n end) as "合同实质投向",
       ic1.c_real_party                         as "实质交易对手",
       ic2.c_party_name                         as "合同交易对手",
       ic1.c_invest_way_n                       as "投资方式",
       ic1.c_fduse_way_n                        as "资金用途",
       ic1.c_exit_way_n                         as "预计退出方式",
       pb1.c_indus_name                         as "投资行业",
       pb2.c_prov_name                          as "资金运用省份",
       pb2.c_city_name                          as "资金运用城市",
       ic1.f_cost_rate                          as "融资成本",
       ic1.c_coop_partner                       as "合作伙伴",
       decode(ic1.l_strategic_flag,1,'是','否') as "是否签署类战略合作协议",
       pb1.c_indus_name                         as "非证券投资行业",
       null                                     as "非证券投资方式",
       temp1.c_special_type_n                     as "公司战略业务",
       ic1.c_fiscal_revenue_n                   as "PPP财政收入",
       decode(ic1.c_special_type, '7', ic1.c_subspecial_type_n, null) as "PPP项目属性",
       ic1.c_leading_party                                            as "PPP项目主导方",
       ic1.c_repay_way_n                                              as "PPP主要还款来源",
       decode(ic1.c_special_type, '4', ic1.c_subspecial_type_n, null) as "不动产类型",
       decode(ic1.c_special_type, '5', ic1.c_subspecial_type_n, null) as "绿色信托类型",
       ic1.c_servicer                                                 as "普惠金融服务商",
       decode(ic1.c_special_type, '1', ic1.c_subspecial_type_n, null) as "普惠金融业务类型",
       ic1.c_gov_level_n                                              as "合作政府级别",
       decode(ic1.l_xzhz_flag,1,'是','否')                            as "是否信政合作",
       decode(ic1.l_invown_flag,1,'是','否')                          as "是否投资公司信托项目",
       ic1.c_func_type_n                                              as "合同功能分类",
       ic1.c_manage_type_n                                            as "合同管理方式",
       ic1.c_manage_type,
       pb2.c_special_type
  from dim_ic_contract ic1,dim_ic_counterparty ic2,dim_pb_industry pb1,dim_pb_area pb2,dim_pb_project_biz pb2,temp_special_type temp1
 where substr(ic1.l_Effective_Date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and substr(ic1.l_expiration_date, 1, 6) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and ic1.l_party_id = ic2.l_party_id(+)
   and ic1.l_invindus_id = pb1.l_indus_id(+)
   and ic1.l_fduse_area = pb2.l_area_id(+)
   and ic1.l_proj_id = pb2.l_proj_id(+)
   and ic1.l_cont_id = temp1.l_cont_id(+)
   and substr(ic1.l_begin_date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   --不取小贷且贷款的合同
   and ((nvl(pb2.c_special_type, '0') = 'A' and  ic1.c_busi_type <> '1')
       or (nvl(ic1.c_cont_type,'XN') = 'XN')
       or (nvl(pb2.c_special_type, '0') <> 'A' )
   )),

v_ic_invest_cont_m1 as (
select ic1.l_month_id,
       ic2.l_cont_id,
       ic2.l_prod_id,
       ic2.l_proj_id,
       ic1.f_balance_agg,
       ic1.f_invest_eot as f_invest_eot,
       ic1.f_return_agg,
       nvl（ratio_to_report(ic1.f_balance_agg) OVER(partition by ic1.l_month_id, ic2.l_proj_id),
       1/count(ic1.f_balance_agg)over(partition by ic1.l_month_id, ic2.l_proj_id)) f_invest_ratio
  from (select t.l_month_id,
               t.l_cont_id,
               sum(t.f_balance_agg) as f_balance_agg,
               sum(t.f_invest_eot) as f_invest_eot,
               sum(t.f_return_agg) as f_return_agg
          from tt_ic_invest_cont_m t
         group by t.l_month_id, t.l_cont_id) ic1,
       dim_ic_contract ic2,
       dim_pb_product pb1
 where ic1.l_month_id = to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and ic1.l_cont_id = ic2.l_cont_id
   and ic2.l_prod_id = pb1.l_prod_id
   and substr(ic2.l_effective_date, 1, 6) <= ic1.l_month_id
   and substr(ic2.l_expiration_date, 1, 6) > ic1.l_month_id)
select x."账套编号",x."项目编号",x."项目名称",x."业务部门",x."项目管理类型",x."项目类型",x."产品功能分类",x."产品实质投向",x."项目开始日期",x."项目终止日期",x."项目预计到期",x."项目状态",x."是否资金池",x."普惠金融",x."是否场内场外",x."产品成立日",x."合同代码",x."合同名称",x."合同起始日",x."合同终止日",x."合同类型",x."合同实质投向",x."实质交易对手",x."合同交易对手",x."资金用途",x."资金运用省份",x."资金运用城市",x."融资成本",x."投资合同规模",x."本年新增规模",x."累计返本",x."FA投资规模",x."是否与FA一致",x."预计退出方式",x."合作伙伴",x."投资方式",x."非证券投资行业",x."是否签署类战略合作协议",x."公司战略业务",x."PPP财政收入",x."PPP项目属性",x."PPP项目主导方",x."PPP主要还款来源",x."不动产类型",x."绿色信托类型",x."普惠金融服务商",x."普惠金融业务类型",x."是否信政合作",x."合作政府级别",x."是否投资公司信托项目",x."合同功能分类",x."合同管理方式" from (
select v4.c_book_code as "账套编号",
       v1."项目编号",
       v1."项目名称",
       v1."业务部门",
       v1."项目管理类型",
       v1."项目类型",
       v1."产品功能分类",
       v1."产品实质投向",
       v1."项目开始日期",
       v1."项目终止日期",
       v1."项目预计到期",
       v1."项目状态",
       v1."是否资金池",
       v1."普惠金融",
       v1."是否场内场外",
       v1."产品成立日",
       v2."合同代码",
       v2."合同名称",
       v2."合同起始日",
       v2."合同终止日",
       v2."合同类型",
       v2."合同实质投向",
       v2."实质交易对手",
       v2."合同交易对手",
       v2."资金用途",
       v2."资金运用省份",
       v2."资金运用城市",
       v2."融资成本",
       v3.f_balance_agg as "投资合同规模",
       v3.f_invest_eot as "本年新增规模",
       v3.f_return_agg as "累计返本",
       decode(v2.l_cont_id,null,v4.f_balance_zc,v3.f_invest_ratio*v4.f_proj_balance_zc) as "FA投资规模",
       decode(sum(nvl(v3.f_balance_agg,0))over(partition by v1.l_proj_id),v4.f_proj_balance_zc,'是','否') "是否与FA一致",
       v2."预计退出方式",
       v2."合作伙伴",
       v2."投资方式",
       v2."非证券投资行业",
       v2."是否签署类战略合作协议",
       v2."公司战略业务",
       v2."PPP财政收入",
       v2."PPP项目属性",
       v2."PPP项目主导方",
       v2."PPP主要还款来源",
       v2."不动产类型",
       v2."绿色信托类型",
       v2."普惠金融服务商",
       v2."普惠金融业务类型",
       v2."是否信政合作",
       v2."合作政府级别",
       v2."是否投资公司信托项目",
       v2."合同功能分类",
       v2."合同管理方式"
  from v_pb_proj_info1 v1,v_to_balance_proj_m1 v4, v_ic_cont_info1 v2,v_ic_invest_cont_m1 v3
 where v1.l_proj_id = v4.l_proj_id(+)
   and v1.l_prod_id = v4.l_prod_id(+)
   and v1.l_proj_id = v2.l_proj_id(+)
   and v1.l_prod_id = v2.l_prod_id(+)
   and v2.l_cont_id = v3.l_cont_id(+)
   ) x where (x."账套编号" is not null or x."合同代码" is not null);
