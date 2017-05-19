--同一批次的不同到期日
select distinct tt.产品编码,tt.产品名称 from (
select d.c_projectcode as 项目编码,
       a.c_fundcode as 产品编码,
       d.c_fundname as 产品名称,
       a.d_cdate as 确认日期,
       b.l_serialno as 合同内部序列号,
       b.c_trustcontractid as 合同外部序列号,
       b.d_contractsigndate as 合同签约日期,
       b.d_contractenddate as 合同到期日期,
       a.f_confirmshares as 认申购份额,
       c.c_custname as 客户姓名,
       decode(c.c_custtype, '1', '自然人', '机构') as 客户类型,
       count(distinct
             nvl(b.d_contractenddate, to_date('20991231', 'yyyymmdd'))) over(partition by a.c_fundcode, a.d_cdate) as 合同到期日差异数量
  from tconfirm a, ttrustcontractdetails b, ttrustclientinfo c, tfundinfo d
 where a.l_contractserialno = b.l_serialno
   and b.c_clientinfoid = c.c_clientinfoid
   and c.c_custtype = '1'
   and a.c_businflag in ('50', '02')
   and to_char(a.d_cdate, 'yyyy') >= '2016'
   and a.c_fundcode = d.c_fundcode
 order by a.c_fundcode, a.d_cdate ) tt where tt.合同到期日差异数量 > 1;
