--4.1部门资产汇总
select 
null as 日期,
null as 部门编号,
null as 部门名称,
null as 资产总额,
null as 期初资金,
null as 期末资金,
null as 资金余额,
null as 可用资金,
null as 可取资金,
null as 本金,
null as 期初收入,
null as 收益率%,
null as 资金占用,
null as 买入金额,
null as 卖出金额,
null as 净资产,
null as 冻结金额,
null as 解冻金额,
null as 预买金额,
null as 股票资产,
null as 基金资产,
null as 债券资产,
null as 债券利息,
null as 新股资产,
null as 期权资产,
null as 融资融券负债资产,
null as 合计,
null as 正回购,
null as 逆回购,
null as 当日融资购回金额，
null as 当日融券购回金额,
null as 合计，
null as 申购冻结,
null as 配股冻结,
null as 应收资产,
null as 当日申购资产,
null as 合计，
null as 累计盈亏,
null as 浮动盈亏，
null as 股票收益,
null as 基金收益,
null as 债券收益,
null as 回购收益,
null as 红利收益，
null as 新股收益,
null as 存款利息收益，
null as 合计,
null as 证券持股比例,
null as 股票持股比例,
null as 存款资产,
null as 其他资产，
null as 合计
from 
;

--4.2项目资产汇总 
select t1.l_date as 日期,
       null as 部门编号,
       null as 部门名称,
       null as 资产总额,
       t1.en_begin_balance as 期初资金,
       t1.en_current_balance as 期末资金,
       t1.en_current_balance as 资金余额,
       null as 可用资金,
       null as 可取资金,
       null as 本金,
       t1.en_begin_invest as 期初投入,
       null as 收益率,
       null as 资金占用,
       t1.en_buy_balance as 买入金额,
       t1.en_sale_balance as 卖出金额,
       t1.en_net_asset as 净资产,
       t1.en_frozen_balance as 冻结金额,
       t1.en_unfrozen_balance as 解冻金额,
       t1.en_prebuy_balance as 预买金额,
       t1.en_stock_asset as 股票资产,
       t1.en_fund_asset as 基金资产,
       t1.en_bond_asset as 债券资产,
       t1.en_interest_asset as 债券利息,
       t1.en_newstock_asset as 新股资产,
       t1.en_futures_asset as 期权资产,
       (t1.en_rz_asset + t1.en_rq_asset) as 融资融券负债资产,
       null as 合计,
       null as 正回购,
       null as 逆回购,
       null as 当日融资购回金额,
       null as 当日融券购回金额,
       null as 合计,
       t1.en_sg_asset as 申购冻结,
       t1.en_pg_asset as 配股冻结,
       null as 应收资产,
       null as 当日申购资产,
       null as 合计,
       null as 累计盈亏,
       null as 浮动盈亏,
       t1.en_stock_profit as 股票收益,
       t1.en_fund_profit as 基金收益,
       t1.en_bond_profit as 债券收益,
       t1.en_hg_profit as 回购收益,
       t1.en_bond_profit as 红利收益,
       t1.en_newstock_profit as 新股收益,
       t1.en_interest_profit as 存款利息收益,
       null as 合计,
       null as 证券持股比例,
       null as 股票持股比例,
       null as 存款资产,
       null as 其他资产,
       null as 合计
  from projectasset t1
 where t1.l_project_id = 10457
   and t1.l_date = 20180614;



--4.3账号资产汇总
select 
null as 日期,
null as 部门编号,
null as 部门名称,
null as 资产总额,
null as 期初资金,
null as 期末资金,
null as 资金余额,
null as 可用资金,
null as 可取资金,
null as 本金,
null as 期初收入,
null as 收益率,
null as 资金占用,
null as 买入金额,
null as 卖出金额,
null as 净资产,
null as 冻结金额,
null as 解冻金额,
null as 预买金额,
null as 股票资产,
null as 基金资产,
null as 债券资产,
null as 债券利息,
null as 新股资产,
null as 期权资产,
null as 融资融券负债资产,
null as 合计,
null as 正回购,
null as 逆回购,
null as 当日融资购回金额，
null as 当日融券购回金额,
null as 合计,
null as 申购冻结,
null as 配股冻结,
null as 应收资产,
null as 当日申购资产,
null as 合计,
null as 累计盈亏,
null as 浮动盈亏，
null as 股票收益,
null as 基金收益,
null as 债券收益,
null as 回购收益,
null as 红利收益，
null as 新股收益,
null as 存款利息收益，
null as 合计,
null as 证券持股比例,
null as 股票持股比例,
null as 存款资产,
null as 其他资产，
null as 合计
from 
;

--4.4证券汇总查询
--4.4.1公司证券汇总查询
--4.4.2部门证券汇总查询
--4.4.3项目证券汇总查询
--4.4.4

--4.5项目证券账号分布
--4.5.1项目证券账号分布
--4.5.2股东证券账号分布
select t1.l_date as 日期,
       t1.l_workgroup_id as 资金账号,
       t4.vc_workgroup_name as 账号简称,
       t1.vc_stockholder_id as 股东账号,
       t1.vc_stock_code as 证券代码,
       t2.vc_stock_name as 证券名称,
       t1.c_exchange_type as 证券类别,
       t4.l_depgroup_id as 营业部资金账号,
       t1.l_current_amount as 持仓量,
       t1.l_current_amount - t1.l_frozen_amount as 可用量,
       t1.l_current_amount * t3.en_last_price as 市值,
       case
         when t1.l_current_amount = 0 then
          0
         else
          t1.en_untransfered_invest / t1.l_current_amount
       end as 成本价,
       t1.en_untransfered_invest as 资金占用,
       null as 利息成本价,
       null as 利息成本,
       (t1.l_current_amount * t3.en_last_price) - t1.en_untransfered_invest as 浮动盈亏,
       t1.l_frozen_amount as 冻结数量,
       t1.l_unfrozen_amount as 解冻数量,
       t1.l_prebuy_amount as 预买数量,
       t1.l_presale_amount as 预上市数量,
       t1.vc_bind_seat as 托管席位
  from hswinhis2 .. groupholderstock t1,
       hswinhis2 .. stockcodes t2,
       hswinhis2 .. stockprice t3,
       hswinrun2 .. workgroup t4
 where t1.vc_stock_code = t2.vc_stock_code
   and t1.l_date = t2.l_date
   and t1.vc_stock_code = t3.vc_stock_code
   and t1.l_date = t3.l_date
   and t1.l_workgroup_id = t4.l_workgroup_id
   and t1.l_workgroup_id = 10457202
   and t1.l_date = 20180614;

--4.5.3股东证券项目账号分布
--4.5.4股东证券项目分布

--4.6运行日报

--4.7新股中签查询
select * from sgnewstockrecord;

--4.8回购查询

--4.9标准券查询

--4.10指令查询

--4.11委托汇总查询
SELECT t1.l_date AS 日期,
       t1.l_branch_id AS 部门编号,
       t1.l_project_id AS 项目编号,
       t1.l_workgroup_id AS 资金帐号,
       t1.vc_stock_code AS 证券代码,
       t1.vc_stock_name AS 证券名称,
       t1.l_department_no AS 营业部号,
       t1.l_entrust_operator AS 操作员,
       t1.c_exchange_type AS 交易类别,
       t1.c_stock_bs AS 证券方向,
       t1.c_fund_bs AS 资金方向,
       NULL AS 买入数量,
       NULL AS 买入均价,
       NULL AS 买入金额,
       NULL AS 卖出数量,
       NULL AS 卖出均价,
       NULL AS 卖出金额,
       t1.l_entrust_amount AS 委托总量,
       t1.l_entrust_amount * t1.en_entrust_price AS 委托总额,
       NULL AS 买成数量,
       NULL AS 买成均价,
       NULL AS 买成金额,
       NULL AS 卖成数量,
       NULL AS 卖成均价,
       NULL AS 卖成金额,
       NULL AS 成交总量,
       NULL AS 成交总额,
       NULL AS 买撤数量,
       NULL AS 卖撤数量,
       NULL AS 买卖方向,
       t1.c_entrust_direction AS 委托方向,
       t1.c_report_way AS 申报模式,
       NULL AS 订单类型,
       t1.en_prefrozen_balance AS 预计冻结金额,
       t1.l_amount_per_hand AS 每手数量,
       t1.l_entrust_time AS 委托时间,
       t1.c_entrust_status AS 委托状态,
       t1.*
  FROM entrusts t1
 WHERE t1.l_date >= 20180101
   AND t1.l_date <= 20180615
   AND t1.l_project_id = 30003;

--select * from hswinrun2.entrustdirections ;
   
--4.12成交汇总查询
--4.12.1系统回报成交汇总
SELECT t1.l_branch_id         as 部门编码,
       null                   as 部门名称,
       t1.l_project_id        as 项目编码,
       null                   as 项目简称,
       null                   as 营业部号,
       t1.l_workgroup_id      as 资金帐号,
       null                   as 帐号简称,
       t1.c_exchange_type     as 交易类别,
       t1.c_stock_type        as 证券类别,
       t1.vc_stock_code       as 证券代码,
       t1.vc_stock_name       as 证券名称,
       t1.c_entrust_direction as 委托方向,
       t1.l_date              as 成交日期,
       t1.vc_stockholder_id   as 股东帐号,
       t1.l_business_no       as 成交编号,
       t1.l_business_amount   as 成交数量,
       t1.en_business_price   as 成交均价,
       null                   as 净价金额,
       null                   as 成交全价,
       t1.en_business_balance as 成交全价金额,
       null                   as 国债利息,
       null                   as 交易所成交均价,
       null                   as 收盘价,
       t1.l_business_time     as 成交时间,
       null                   as 申报模式
  FROM realdeal t1
 WHERE t1.l_date >= 20180101
   AND t1.l_date <= 20180615;
   
--4.12.2清算成交汇总

--4.12.3银行间成交汇总
SELECT t1.l_date                     as 成交日期,
       t1.l_time                     as 成交时间,
       t1.vc_deal_no                 as 成交编号,
       t1.l_entrust_serial_no        as 委托序号,
       t1.l_project_id               as 项目编号,
       null                          as 项目简称,
       t1.l_workgroup_id             as 资金帐号,
       null                          as 帐号简称,
       t1.vc_stockholder_id          as 股东帐号,
       t1.c_entrust_direction        as 委托方向,
       t1.vc_stock_code              as 证券代码,
       t1.en_total_face_value        as 卷面总额,
       t1.en_rate                    as 回购利率,
       t1.en_first_settle_interest   as 首期应计利息,
       t1.en_first_net_price         as 首期净价,
       t1.en_first_full_price        as 首期全价,
       t1.en_first_clear_balance     as 首期结算金额,
       t1.en_first_mature_yield      as 首期收益率,
       t1.en_second_clear_balance    as 到期结算金额,
       t1.en_second_mature_yield     as 到期收益率,
       t1.l_first_settle_date        as 首次交割日,
       t1.l_second_settle_date       as 到期交割日,
       t1.l_hg_days                  as 回购天数,
       t1.l_settle_speed             as 清算速度,
       t1.l_trade_rival_no           as 交易对手,
       t1.l_use_days                 as 实际占款天数,
       t1.c_first_settle_type        as 首次交割方式,
       t1.c_second_settle_type       as 到期交割方式,
       t1.en_mature_settle_interest  as 到期应计利息,
       t1.en_mature_net_price        as 到期净价,
       t1.en_js_fare                 as 结算服务费,
       t1.en_gh_fare                 as 结算代理费,
       t1.en_sx_fare                 as 手续费,
       t1.en_mature_full_price       as 到期交易全价价格,
       t1.en_first_interest_balance  as 首次交易利息金额,
       t1.en_second_interest_balance as 到期交易利息金额,
       t1.c_cancel_flag              as 撤单标志,
       null                          as 证券名称
  FROM bankrealdeal t1
 WHERE t1.l_date >= 20180101
   AND t1.l_date <= 20180615;

--4.13资金流水查询
select t1.l_date            as 发生日期,
       t1.l_time            as 发生时间,
       t1.l_business_date   as 业务日期,
       t1.l_workgroup_id    as 资金帐号,
       null                 as 资金帐号简称,
       t1.vc_stockholder_id as 股东帐号,
       t1.c_exchange_type   as 交易类别,
       t1.c_stock_type      as 证券类别,
       t1.vc_stock_code     as 证券代码,
       null                 as 证券代码名称,
       t1.l_busin_flag      as 业务标志,
       t1.vc_ext_flag       as 业务类别,
       t1.en_occur_balance  as 资金发生额,
       t1.en_post_balance   as 后资金发生额,
       t1.l_occur_amount    as 证券发生额,
       t1.en_post_amount    as 后证券发生额,
       t1.c_stock_bs        as 证券买卖方向,
       t1.c_fund_bs         as 资金方向,
       t1.en_entrust_price  as 委托价格,
       t1.l_entrust_amount  as 委托数量,
       t1.c_flatform_type   as 平台类型,
       t1.vc_summary        as 备注,
       t1.l_branch_id       as 部门编码,
       t1.l_op_code         as 操作员编码,
       t1.l_project_id      as 项目编码,
       t1.l_department_no   as 营业部编码,
       t1.l_opworkstation   as 客户端
  from currents t1
 where t1.l_project_id = 10457
   and t1.l_date >= 20180101
   and t1.l_date <= 20180615;

--4.14柜员日志查询
select t1.l_date          as 操作日期,
       t1.l_time          as 操作时间,
       t1.l_serial_no     as 流水号,
       t1.l_op_code       as 柜员号,
       t1.l_busin_flag    as 业务标志,
       null               as 业务标志名称,
       t1.tx_detail       as 日志内容,
       t1.l_workgroup_id  as 资金帐号,
       t1.l_branch_id     as 部门编号,
       null               as 站点编号,
       t1.l_opworkstation as 工作站点,
       null               as 站点名称
  from operatorlog t1
 where t1.l_date = 20180614;

--4.15其他流水查询
--4.15.1资金证券其他流水
--4.15.2账号业务流水
--4.15.3项目资金冻结解冻流水
--4.15.4资产组成本调整流水查询

--4.16核算流水查询

--4.17证券冻结查询

--4.18场外查询
select

from
groupholderstock


--4.25债券持仓查询 
select 
null as 日期,
null as 资金账号,
null as 账号名称,
null as 市场类别,
null as 证券类别,
null as 证券代码,
null as 证券名称,
null as 托管市场,
null as 持仓数量,
null as 最新净价,
null as 当前利息,
null as 净价市值,
null as 全价市值,
null as 到期日,
null as 票面年利率,
null as 到期收益率,
null as 信用综合评级,
null as 净价成本,
null as 利息成本,
null as 全价成本,
null as 到期天数,
null as 累计收益,
null as 净价浮动盈亏,
null as 全价浮动盈亏,
null as 浮盈率,
null as 总盈亏,
null as 久期,
null as 利息浮动盈亏,
null as 利息累计盈亏,
null as 利息总盈亏,
null as 起息日期,
null as 修正久期,
null as 主体评级,
null as 债券评级,
null as 基点价值
from 
groupstock t1;

--项目帐号
select * from projectgroup t where t.l_project_id =  10457;

--资金帐号
select * from workgroup t where t.l_workgroup_id in (select t1.l_workgroup_id from projectgroup t1 where t1.l_project_id =  10457);

--资金帐号对应资产情况

--资金帐号对应股票持仓
select * from groupstock t where t.l_workgroup_id in (select t1.l_workgroup_id from projectgroup t1 where t1.l_project_id =  10457);

--资金帐号对应股东帐号
select * from stockholder t where t.l_workgroup_id in (select t1.l_workgroup_id from projectgroup t1 where t1.l_project_id =  10457);

--股东帐号对应股票持仓
select * from groupholderstock  t where t.l_workgroup_id in (select t1.l_workgroup_id from projectgroup t1 where t1.l_project_id =  10457);