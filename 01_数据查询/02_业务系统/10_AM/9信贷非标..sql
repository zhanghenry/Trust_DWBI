--9.5关联资产管理
--9.5.1保证资产管理
select t1.l_collateral_no as 资产序号,
       (select d1.vc_caption
          from dictionary d1
         where d1.l_key = 1255
           and d1.c_value = t1.c_collateral_status) as 抵质押状态,
       null as 产品状态,
       t1.vc_product_id as 产品代码,
       t1.vc_collateral_name as 资产名称,
       t1.l_start_date as 开始日期,
       t1.l_deal_date as 到期日期,
       (select d1.vc_caption
          from dictionary d1
         where d1.l_key = 1224
           and d1.c_value = t1.c_collateral_type) as 资产性质,
       null as 资产类别,
       t1.l_guarantor as 抵质押人,
       t1.l_current_amount as 入库数量,
       null as 保管编号,
       null as 红利金额,
       null as 红股数量,
       t1.en_begin_value as 期初价值,
       t1.vc_collateral_id as 凭证编号,
       t1.vc_collateral_code as 登记编号,
       t1.en_begin_value as 评估价值
  from collateral t1
 where t1.vc_product_id = 'AJ0733';
 
 
--9.5.1抵质押资产信息-查看-抵押物
select t1.vc_product_id as 产品代码,
       null as 供选产品代码,
       null as 合同代码,
       t1.vc_contract_no as 抵押合同号,
       t1.vc_collateral_name as 资产名称,
       null as 签约日期,
       t1.l_begin_date as 开始日期,
       t1.l_end_date as 到期日期,
       (select d1.vc_caption
          from dictionary d1
         where d1.l_key = 1224
           and d1.c_value = t1.c_collateral_type) as 资产性质,
       (select d1.vc_caption
          from dictionary d1
         where d1.l_key = 1225
           and d1.c_value = t1.c_asset_type) as 资产类型,
       (select d1.vc_caption
          from dictionary d1
         where d1.l_key = 1282
           and d1.c_value = t1.c_asset_type_ex) as 明细类别,
       t1.l_guarantor as 抵押人,
       t1.l_land_area as 土地面积,
       t1.vc_house_position as 坐落部位,
       t1.l_start_date as 入库日期,
       t1.l_begin_amount as 入库数量,
       t1.en_collected_rate as 地质押率,
       null as 充抵成本,
       (select d1.vc_caption
          from dictionary d1
         where d1.l_key = 1344
           and d1.c_value = CAST(t1.l_right_sequence as VARCHAR)) as 清偿顺序,
       (select d1.vc_caption
          from dictionary d1
         where d1.l_key = 1252
           and d1.c_value = t1.c_storage_mode) as 保管方式,
       null as 保管编号,
       t1.en_begin_value as 期初价值,
       t1.vc_collateral_id as 他须权证编号,
       t1.vc_registration_authority as 登记机关,
       t1.vc_collateral_code as 登记编号,
       t1.l_registration_date as 登记日期,
       t1.l_effective_date as 有效期限,
       t1.l_evaluate_date as 评估日期,
       t1.en_last_price as 评估价格,
       t1.en_market_value as 评估价值,
       t1.en_collateral_balance as 抵质押金额,
       t1.c_evaluate_currency as 评估币种,
       null as 评估说明,
       (select d1.vc_caption
          from dictionary d1
         where d1.l_key = 1313
           and d1.c_value = t1.c_evaluate_way) as 评估方法,
       t1.l_evaluate_organization as 评估机构,
       t1.c_is_insuranced as 是否入保,
       t1.vc_remark as 抵押说明,
       t1.l_insurance_check_date as 核保日期
  from collateral t1
 where t1.vc_contract_no = 'AJSDDY-ZJ';

