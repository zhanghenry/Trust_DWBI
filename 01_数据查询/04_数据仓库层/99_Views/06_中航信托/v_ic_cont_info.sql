create or replace view v_ic_cont_info as
with temp_special_type as
 (select t.l_cont_id,
         listagg(t.c_props_type_n, ',') within group(order by t.l_cont_id, t.c_props_type) as c_special_type_n
    from dim_ic_contract_derive t
   where t.l_effective_flag = 1
   group by t.l_cont_id)
select ic1.l_proj_id,
       ic1.l_prod_id,
       ic1.l_cont_id,
       ic1.c_cont_code                          as "合同代码(AM)",
       ic1.c_cont_name                          as "合同名称(AM)",
       to_date(ic1.l_begin_date, 'yyyymmdd')    as "合同起始日(AM)",
       to_date(ic1.l_expiry_date, 'yyyymmdd')   as "合同终止日(AM)",
       decode(pb2.l_pitch_flag,1,'其他投资',ic1.c_busi_type_n)    as "合同类型(AM)",
       ic1.c_invest_indus_n                     as "合同实质投向(BULU)",
       ic1.c_real_party                         as "实质交易对手(BULU)",
       ic2.c_party_name                         as "合同交易对手(AM)",
       ic1.c_invest_way_n                       as "投资方式(BULU)",
       ic1.c_fduse_way_n                        as "资金用途(BULU)",
       ic1.c_exit_way_n                         as "预计退出方式(BULU)",
       pb1.c_indus_name                         as "投资行业(BULU)",
       pb2.c_prov_name                          as "资金运用省份(BULU)",
       pb2.c_city_name                          as "资金运用城市(BULU)",
       ic1.f_cost_rate                          as "融资成本(AM)",
       ic1.c_coop_partner                       as "合作伙伴(BULU)",
       decode(ic1.l_strategic_flag,1,'是','否') as "是否签署类战略合作协议(BULU)",
       pb1.c_indus_name                         as "非证券投资行业(BULU)",
       null                                     as "非证券投资方式(BULU)",
       temp1.c_special_type_n                     as "公司战略业务(BULU)",
       ic1.c_fiscal_revenue_n                   as "PPP财政收入(BULU)",
       decode(ic1.c_special_type, '7', ic1.c_subspecial_type_n, null) as "PPP项目属性(BULU)",
       ic1.c_leading_party                                            as "PPP项目主导方(BULU)",
       ic1.c_repay_way_n                                              as "PPP主要还款来源(BULU)",
       decode(ic1.c_special_type, '4', ic1.c_subspecial_type_n, null) as "不动产类型(BULU)",
       decode(ic1.c_special_type, '5', ic1.c_subspecial_type_n, null) as "绿色信托类型(BULU)",
       ic1.c_servicer                                                 as "普惠金融服务商(BULU)",
       decode(ic1.c_special_type, '1', ic1.c_subspecial_type_n, null) as "普惠金融业务类型(BULU)",
       ic1.c_gov_level_n                                              as "合作政府级别(BULU)",
       decode(ic1.l_xzhz_flag,1,'是','否')                            as "是否信政合作(BULU)",
       decode(ic1.l_invown_flag,1,'是','否')                          as "是否投资公司信托项目(BULU)",
       ic1.c_func_type_n                                              as "合同功能分类(BULU)",
       ic1.c_manage_type_n                                            as "合同管理方式(BULU)",
       pb2.c_special_type
  from dim_ic_contract ic1,dim_ic_counterparty ic2,dim_pb_industry pb1,dim_pb_area pb2,dim_pb_project_biz pb2,temp_special_type temp1
 where substr(ic1.l_Effective_Date, 1, 6) <= 201707
   and substr(ic1.l_expiration_date, 1, 6) > 201707
   and ic1.l_party_id = ic2.l_party_id(+)
   and ic1.l_invindus_id = pb1.l_indus_id(+)
   and ic1.l_fduse_area = pb2.l_area_id(+)
   and ic1.l_proj_id = pb2.l_proj_id(+)
   and ic1.l_cont_id = temp1.l_cont_id(+)
   --不取小贷且贷款的合同
   and ((nvl(pb2.c_special_type, '0') = 'A' and  ic1.c_busi_type <> '1')
       or (nvl(ic1.c_cont_type,'XN') = 'XN')
       or (nvl(pb2.c_special_type, '0') <> 'A' )
   );
