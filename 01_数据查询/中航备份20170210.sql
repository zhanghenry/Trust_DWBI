select a.*
  from tfi_voucher a, tfi_subject b, tde_department c
 where a.c_subj_code = b.c_subj_code
   and a.c_object_type = 'BM'
   and a.c_object_code = c.c_dept_code
   and c.c_dept_name like '%杭州%' and a.l_proj_flag = 1
   --and b.c_subj_code like '660137%'
   and a.d_business between to_date('20160101', 'yyyymmdd') and
       to_date('20161231', 'yyyymmdd');

select * from nc_vouchers t where t.c_jourid = '1002D51000000001TWR5';

select * from nc_asitem  t where t.c_combid = '1002D510000000019OTD';

select sum(t.sygm) from (
select tsharecurrents.l_contractserialno,
       sum(case
             when c_businflag in ( '03', '71','15') then
              f_occurshares
             else
              f_occurshares
           end) sygm
  from tsharecurrents@hsta
 where c_fundcode = 'ZH00VM'
   and to_char(d_cdate, 'yyyymmdd') <= '20161231'
 group by tsharecurrents.l_contractserialno having sum(case
             when c_businflag in ( '03', '71','15') then
              f_occurshares
             else
              f_occurshares
           end) <> 0
) t;

select *
  from (select cpdm, sum(ljjsgm) ljjsgm, sum(sygm) sygm
          from (select c_fundcode cpdm,
                       sum(case
                             when to_char(d_cdate, 'yyyymmdd') <= '20161231' and
                                  c_businflag in ('03', '71') then
                              -f_occurshares
                             else
                              0
                           end) ljjsgm,
                       sum(case
                             when to_char(d_cdate, 'yyyymmdd') > '20161231' and
                                  c_businflag in
                                  ('50', '02', '03', '70', '71', '74') then
                              -f_occurshares
                             else
                              0
                           end) sygm
                  from tsharecurrents@hsta where c_fundcode = 'ZH00VM'
                 group by c_fundcode
                union
                select c_fundcode cpdm, 0 ljjsgm, sum(f_realshares) sygm
                  from tstaticshares@hsta where c_fundcode = 'ZH00VM'
                 group by c_fundcode
                union ALL
                select c_fundcode cpdm, 0 ljjsgm, f_balancesum sygm
                  from ttrustcontracts@hsta t3
                 where t3.c_isfundsetup = '2'
                   and f_balancesum > 0
                   and to_char(t3.d_setupdate, 'yyyymmdd') <= '20161231' and c_fundcode = 'ZH00VM'
                   and not exists
                 (select 1
                          from tsharecurrents@hsta t4
                         where t4.c_businflag = '50'
                           and t3.c_fundcode = t4.c_fundcode)) tt
         group by cpdm) tt
 where tt.cpdm = 'ZH00VM';
 
select t.d_cdate,
       t.d_requestdate,
       t.c_cserialno,
       t.c_businflag,
       t.f_occurshares,
       t.f_occurbalance,
       t.f_lastshares
 --sum(t.f_occurshares)
  from tsharecurrents t
 where t.c_fundcode = 'ZH00VM'
   and t.d_cdate <= to_date('20161231', 'yyyymmdd') and t.c_businflag = '74'
   and t.l_contractserialno = 18867
 order by t.d_cdate;

select * from tfundinfo_bulu t where t.c_property = '2';


select t.d_cdate,
       t.d_requestdate,
       t.c_cserialno,
       t.c_businflag,
       t.f_occurshares,
       t.f_occurbalance,
       t.f_lastshares
  from tsharecurrents t
 where t.c_fundcode = 'ZH00VM' and t.f_occurshares = 0;
 
 select /*t.d_cdate,
       t.d_requestdate,
       t.c_cserialno,
       t.c_businflag,
       t.f_occurshares,
       t.f_occurbalance,
       t.f_lastshares,
       t.l_contractserialno*/
       sum(t.f_lastshares)
  from tsharecurrents t
 where t.c_fundcode = 'ZH00VM' and t.d_sharevaliddate = to_date('20161231','yyyymmdd') order by t.d_cdate desc;
 
 select * from tsharecurrents t where t.c_fundcode = 'ZH00VM';
 
 select a.d_confirm,
        a.c_busi_type,
        a.c_busi_type_n,
        a.f_trade_share as 交易确认,
        b.f_occurshares as 份额流水,
        abs(a.f_trade_share) - abs(b.f_occurshares) as 差异
   from datadock.tta_trust_order a, tsharecurrents b
  where a.c_prod_code = b.c_fundcode
    and a.d_confirm = b.d_cdate
    and a.c_busi_type = b.c_businflag
    and a.c_prod_code = 'ZH00VM'
    and a.c_busi_type <> '74'
  order by a.d_confirm;
  
select sum(a.f_balance_agg)
  from tt_tc_scale_cont_m a, dim_pb_project_basic b
 where a.l_proj_id = b.l_proj_id
   and a.l_month_id = 201612
   and b.c_proj_code = 'AVICTC2013X0539';


select t.l_prod_id,
       sum(t.f_balance_agg) as f_balance_agg,
       sum(t.f_decrease_agg) as f_decrease_agg
  from tt_tc_scale_cont_m t, dim_pb_product t1
 where t.l_month_id = 201612
   and t.l_prod_id = t1.l_prod_id 
   and substr(t1.l_effective_date, 1, 6) <= t.l_month_id
   and substr(t1.l_expiration_date, 1, 6) > t.l_month_id
   and t1.c_prod_code = 'ZH00VM' --ZH016M,ZH02AR,ZH01RX
 group by t.l_prod_id;

select * from dim_pb_product t where t.c_prod_code = 'ZH01RX';

select b.c_cont_code, sum(a.f_balance_agg)
  from tt_tc_scale_cont_m a, dim_tc_contract b
 where a.l_cont_id = b.l_cont_id
   and a.l_month_id = 201612
   and b.l_prod_id = 114
 group by b.c_cont_code;
 
select * from tde_product t where t.l_monetary_flag = 1;


select t.c_prod_code,s.c_prod_name,
       sum(case
             when t.c_busi_type in ('71','15', '03') then
              t.f_trade_share * -1
             else
              t.f_trade_share
           end)
  from tta_trust_order t, tde_product s
 where t.c_prod_code = s.c_prod_code and t.c_busi_type_n <> '分红结转'
   and s.l_monetary_flag = 1
   and t.d_confirm <= to_date('20161231', 'yyyymmdd')
 group by t.c_prod_code,s.c_prod_name
 order by t.c_prod_code,s.c_prod_name;

--份额按产品
select t.c_prod_code,s.c_prod_name,
       sum(case
             when t.c_busi_type in ('71','15', '03') then
              t.f_trade_share * -1
             else
              t.f_trade_share
           end)
  from tta_trust_order t, tde_product s
 where t.c_prod_code = s.c_prod_code and t.c_busi_type <> '74'
   --and s.l_monetary_flag = 1
   and s.c_prod_code = 'ZH00VM'
   and t.d_confirm <= to_date('20161231', 'yyyymmdd')
 group by t.c_prod_code,s.c_prod_name
 order by t.c_prod_code,s.c_prod_name;

--金额按产品
select t.c_prod_code,s.c_prod_name,
       sum(case
             when t.c_busi_type in ('71','15', '03') then
              t.f_trade_amt * -1
             else
              t.f_trade_amt
           end)
  from tta_trust_order t, tde_product s
 where t.c_prod_code = s.c_prod_code
   --and s.l_monetary_flag = 1
   and s.c_prod_code = 'ZH00VM'
   and t.d_confirm <= to_date('20161231', 'yyyymmdd') and t.c_busi_type <> '74'
 group by t.c_prod_code,s.c_prod_name
 order by t.c_prod_code,s.c_prod_name;
 
--金额汇总
select t.c_prod_code,s.c_prod_name,t.c_cont_code,
       sum(case
             when t.c_busi_type in ('71','15', '03') then
              t.f_trade_amt * -1
             else
              t.f_trade_amt
           end)
  from tta_trust_order t, tde_product s
 where t.c_prod_code = s.c_prod_code
   and s.c_prod_code = 'ZH016M'
   and t.d_confirm <= to_date('20161231', 'yyyymmdd') and t.c_busi_type <> '74'
 group by t.c_prod_code,s.c_prod_name,t.c_cont_code
 order by t.c_prod_code,s.c_prod_name,t.c_cont_code;

--份额按合同
select sum(f_fe) from (
select t.c_cont_code,
       sum(case
             when t.c_busi_type in ('71', '15', '03') then
              t.f_trade_share * -1
             else
              t.f_trade_share
           end) as f_fe
  from tta_trust_order t
 where t.c_prod_code = 'ZH00VM' and t.c_busi_type <> '74'
   and t.d_confirm <= to_date('20161231', 'yyyymmdd')
 group by t.c_cont_code having  sum(case
             when t.c_busi_type in ('71', '15', '03') then
              t.f_trade_share * -1
             else
              t.f_trade_share
           end) <> 0
 order by t.c_cont_code
) t;

--流水
select * from tta_trust_order t where t.c_cont_code = '18867' and t.c_busi_type <> '74' and t.c_busi_type_n = '分红结转';

select * from tta_trust_order t where t.c_prod_code = 'ZH016M' and t.c_busi_type <> '74';


--部门费用结构 
select  a.l_object_id,
       sum(a.f_amount) as 总费用,
       sum(decode(a.l_proj_flag, 1, a.f_amount, 0)) as 项目费用,
       sum(decode(a.l_proj_flag, 0, a.f_amount, 0)) as 固定费用
  from tt_fi_accounting_flow_d a, dim_fi_subject b
 where a.c_object_type = 'GS'
   and b.l_effective_flag = 1
   and a.l_subj_id = b.l_subj_id
   and b.c_subj_code like '6601%'
   and a.l_busi_date between 20160101 and 20161231
 group by a.l_object_id
 order by a.l_object_id;

--新增合同收入
select d.l_proj_id,d.c_proj_code, d.c_proj_name, sum(a.f_planned_agg)/10000
  from tt_ic_ie_prod_m      a,
       dim_pb_ie_type       b,
       dim_pb_ie_status     c,
       dim_pb_project_basic d
 where a.l_ietype_id = b.l_ietype_id
   and a.l_iestatus_id = c.l_iestatus_id
   and a.l_proj_id = d.l_proj_id
   and c.c_iestatus_code = 'NEW'
   and a.l_month_id = 201612-- and d.c_proj_code = 'AVICTC2015X1256'
   and substr(d.l_effective_date, 1, 6) <= a.l_month_id
   and substr(d.l_expiration_date, 1, 6) > a.l_month_id
 group by d.l_proj_id,d.c_proj_code, d.c_proj_name;