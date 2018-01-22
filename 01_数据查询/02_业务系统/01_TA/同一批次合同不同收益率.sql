--同一批次不同收益率
select distinct tt.产品编码,tt.产品名称 from (
select f.c_projectcode as 项目编码,
       d.c_fundcode as 产品编码,
       f.c_fundname as 产品名称,
       d.d_cdate as 确认日期,
       d.l_serialno as 合同内部序列号,
       d.c_trustcontractid as 合同外部序列号,
       d.d_contractsigndate as 合同签约日期,
       d.d_contractenddate as 合同到期日期,
       d.f_shares as 认申购金额,
       d.c_feqj as 份额区间,
       d.c_custname as 客户姓名,
       decode(d.c_custtype, '1', '自然人', '机构') as 客户类型,
       decode(nvl(e.f_profit, 0),0,d.f_profit,e.f_profit) as 收益率,
       count(distinct nvl(e.f_profit, 0)) over(partition by d.c_fundcode, d.d_cdate) as 收益率差异数量
  from (select a.c_fundcode,
               a.d_cdate,
               b.l_serialno,
               b.c_trustcontractid,
               b.d_contractsigndate,
               b.d_contractenddate,
               a.f_shares,
               case
                 when a.f_shares < 3000000 then
                  '300万以内'
                 when a.f_shares >= 3000000 and a.f_shares < 10000000 then
                  '300万到1000万以内'
                 else
                  '1000万以上'
               end as c_feqj,
               b.f_profit,
               b.c_profitclass,
               c.c_custname,
               c.c_custtype
          from (select a1.c_fundcode,
                       a1.d_cdate,
                       a1.l_contractserialno,
                       sum(a1.f_confirmshares) as f_shares
                  from tconfirm a1
                 where a1.c_businflag in ('50', '02')
                   and to_char(a1.d_cdate, 'yyyy') >= '2016'
                 group by a1.c_fundcode, a1.d_cdate, a1.l_contractserialno) a,
               ttrustcontractdetails b,
               ttrustclientinfo c
         where a.l_contractserialno = b.l_serialno
           and b.c_clientinfoid = c.c_clientinfoid
           and c.c_custtype = '1') d,
       ttrustfundprofit e,
       tfundinfo f
 where d.c_fundcode = e.c_fundcode(+)
   and d.c_profitclass = e.c_profitclass(+)
   and d.c_fundcode = f.c_fundcode(+)
 order by d.c_fundcode, d.d_cdate
 ) tt where tt.收益率差异数量 > 1
 ;

--合同收益率信息
select t1.c_fundcode, t.c_profitclass, t.f_profit,t2.f_profit,t.l_parentserialno
  from ttrustcontractdetails t, ttrustcontracts t1, ttrustfundprofit t2
 where t.l_contractserialno = t1.l_serialno
   and t.c_profitclass = t2.c_profitclass
   and t1.c_fundcode = t2.c_fundcode
   and t.l_serialno in (434563);

--合同交易信息
select * from tconfirm t where t.l_contractserialno = 434563 ;

--合同收益分配信息
select t.f_curbenefitcapital,t.f_repaycapital,t.f_profit from tprofitdealcurrentdetails t where t.l_contractserialno = 434563;
