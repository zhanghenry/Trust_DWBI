--流程信息
select distinct t.c_agentname from TFLOWINFO t where t.l_flowinfoid = 17458;

select * from tflowinfo t where t.c_projectcode = 'D062' and t.process_instanceid like 'projectChange%';

--流程附件
select * from TFLOWATTACH t where t.c_processinstanceid = 'projectChange.490712';

--流程审批记录
select * from TFLOWAPPROVES t where t.c_processinstanceid = 'projectChange.490712';

--流程涉及的表
select * from TACCOUNT_BANK_APPLY;--银行账户申请
select * from TACCOUNT_CAPITAL_APPLY;--银行资金申请
select * from TBENIFICAIARY_TRANSFER_INFO;--受益权转让申请
select * from TCAPITAL_TRANSFER_INFO;--资金交易信息
select * from TFLOWINFO_TEXT;--流程文本，空
select * from TPROJECT_CONTRACT;--项目合同
select * from TPROJECT_DISCLOSURE_APPROVAL;--披露，暂时无用
select * from TPROJECT_DIVIDESCHEME;--项目分成，暂时无用
select * from TPROJECT_FACTOR_TRACE;--项目要素--很重要
select * from TPROJECT_FILE_BILL;--项目文件之类的，应该有用
select * from TPROJECT_INFO;--项目
select * from TPROJECT_LIQUIDATION_INFO;--不清楚作用，应该没用到
select * from TRISK_COLLATERAL;--风险担保品，应该有用
select * from TRISK_COLLATERALOUT;--与风险担保相关
