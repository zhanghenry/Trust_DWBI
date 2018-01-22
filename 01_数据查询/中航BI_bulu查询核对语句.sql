--产品报酬信息
with temp_rate as
 (select t1.c_prod_code, min(t1.f_rate) as f_rate
    from datadock.tam_rate t1
   where t1.c_ietype_code = 'XTGDBC'
   group by t1.c_prod_code),
temp_scale as
 (select t2.c_prod_code,
         sum(case
               when t2.c_busi_type in ('03', '71') then
                t2.f_trade_share * -1
               else
                t2.f_trade_share
             end) as f_ye,
         sum(case
               when t2.c_busi_type in ('03', '71') then
                t2.f_trade_share
               else
                0
             end) as f_hb
    from datadock.tta_trust_order t2
   where t2.c_busi_type not in ('14', '15', '74')
     and t2.d_confirm <= to_date('20161231', 'YYYYMMDD')
   group by t2.c_prod_code),
temp_plan as
 (select tt3.*,
         sum(tt3.f_prod_plan) over(partition by tt3.c_proj_code) as f_proj_plan
    from (select t3.c_proj_code,
                 t3.c_prod_code,
                 sum(t3.f_plan) as f_prod_plan
            from datadock.tam_plan t3
           where t3.d_plan <= to_date('20161231', 'yyyymmdd')
             and t3.c_ietype_code = 'XTGDBC'
           group by t3.c_proj_code, t3.c_prod_code) tt3),
temp_actual as
 (select tt4.*,
         sum(tt4.f_prod_actual) over(partition by tt4.c_proj_code) as f_proj_actual
    from (select t4.c_proj_code,
                 t4.c_prod_code,
                 sum(t4.f_actual) as f_prod_actual
            from datadock.tam_order t4
           where t4.d_actual <= to_date('20161231', 'yyyymmdd')
             and t4.c_ietype_code = 'XTGDBC'
           group by t4.c_proj_code, t4.c_prod_code) tt4)
select a.c_prod_code as 产品编码,
       a.c_prod_name as 产品名称,
       c.f_ye as 受托余额,
       c.f_hb as 累计还本,
       a.d_setup as 产品起始日期,
       a.d_preexp as 预计到期日期,
       a.d_expiry 产品终止日期,
       b.f_rate as 信托报酬率,
       d.f_prod_plan as 信托报酬,
       e.f_prod_actual as 累计已支付报酬,
       (case
         when d.f_proj_plan < e.f_proj_actual then
          0
         else
          d.f_prod_plan - e.f_prod_actual
       end) as 尚未支付报酬
  from datadock.tde_product a,
       temp_rate            b,
       temp_scale           c,
       temp_plan            d,
       temp_actual          e
 where a.c_prod_code = b.c_prod_code(+)
   and a.c_prod_code = c.c_prod_code(+)
   and a.c_prod_code = d.c_prod_code(+)
   and a.c_prod_code = e.c_prod_code(+)
 order by a.d_setup;

select *
  from hstdc.ta_fundinfo a
 where exists
 (select 1 from hstdc.ta_order b where a.c_fundcode = b.c_fundcode);

--有付费计划但无法关联到TA实质产品的
select b.*, a.*
  from bulu_amfareplan a
 left outer join (select b3.c_projcode,
                          b3.c_fullname,
                          b3.d_begdate,
                          b3.c_projphase,
                          b1.c_fundcode,
                          b1.d_setupdate,
                          b1.d_issuedate
                     from hstdc.ta_fundinfo b1, hstdc.pm_projectinfo b3
                    where b1.c_projcode = b3.c_projcode
                      and exists
                    (select 1
                             from hstdc.ta_order b2
                            where b1.c_fundcode = b2.c_fundcode)) b
    on a.vc_product_id = b.c_fundcode
 where b.c_fundcode is null order by a.l_begin_date;

--TCMP项目只有1个TA产品，但没有付费计划的
with temp_fundinfo as
 (select c.*,d.*
    from hstdc.ta_fundinfo c,
         (select a.c_projcode as c_proj_code,a.d_begdate,a.d_enddate as d_expiry,e.c_orgname,count(*) as ct
            from hstdc.pm_projectinfo a, hstdc.ta_fundinfo b,hstdc.hr_org e
           where a.c_projcode = b.c_projcode and nvl(a.d_enddate,to_date('20991231','YYYYMMDD')) >= to_date('20150101','YYYYMMDD')
           and a.c_dptid = e.c_orgid
           group by a.c_projcode,a.d_begdate,a.d_enddate,e.c_orgname) d
   where c.c_projcode = d.c_proj_code
     and d.ct = 1)
select t2.c_fundcode as 产品编码,t2.c_fundname as 产品名称,t2.c_proj_code as 项目编码,t2.d_begdate as 项目成立日期,t2.d_expiry as 项目终止日期,t2.c_orgname as 部门
  from bulu_amfareplan t1
 right outer join temp_fundinfo t2
    on t2.c_fundcode = t1.vc_product_id
   and t1.vc_product_id is null
   order by t2.c_orgname,t2.d_begdate;

--多个子产品的但未填子产品编码
with temp_fundinfo as
(select c.*
  from hstdc.ta_fundinfo c,
       (select a.c_projcode, count(*) as ct
          from hstdc.pm_projectinfo a, hstdc.ta_fundinfo b
         where a.c_projcode = b.c_projcode
         group by a.c_projcode) d
 where c.c_projcode = d.c_projcode
   and d.ct > 1)
select b.c_projcode as 项目编码,
     b.c_fullname as 项目名称,
     b.c_dptid as 部门编码,
     b.c_orgname as 部门名称,
     b.d_begdate as 项目成立日期,
     b.c_fundcode as TA产品编码,
     a.l_serial_no as 付费序列号,
     a.vc_product_id as AM产品ID,
     a.c_ext_flag as 付费类别,
     a.l_begin_date as 起息日,
     a.l_end_date as 结息日,
     a.en_rate as 费率,
     a.en_plan_balance as 计划金额,
     a.vc_code as 子产品编码,
     a.vc_remark as 备注 
from (select t1.*
        from bulu_amfareplan t1, temp_fundinfo t2
       where t1.vc_product_id = t2.c_fundcode) a
left outer join (select t2.c_projcode,
                        t2.c_fullname,
                        t2.c_dptid,
                        t3.c_orgname,
                        t2.d_begdate,
                        t1.c_fundcode
                   from hstdc.ta_fundinfo t1, hstdc.pm_projectinfo t2,hstdc.hr_org t3
                  where t1.c_projcode = t2.c_projcode and t2.c_dptid = t3.c_orgid) b
  on a.vc_product_id = b.c_fundcode
where a.vc_code is null order by b.c_dptid,b.d_begdate,b.c_projcode;

--存在规模的产品但没有付费计划
select b.*, a.*
  from bulu_amfareplan a
 right outer join (select b3.c_projcode,
                          b3.c_fullname,
                          b3.d_begdate,
                          b3.c_projphase,
                          b1.c_fundcode,
                          b1.d_setupdate,
                          b1.d_issuedate
                     from hstdc.ta_fundinfo b1, hstdc.pm_projectinfo b3
                    where b1.c_projcode = b3.c_projcode
                      and exists
                    (select 1
                             from hstdc.ta_order b2
                            where b1.c_fundcode = b2.c_fundcode)) b
    on a.vc_product_id = b.c_fundcode
 where a.vc_product_id is null order by b.d_begdate;

select t.*
  from bulu_amfareplan t, hstdc.ta_fundinfo s
 where t.vc_product_id = s.c_fundcode
   and s.c_projcode = 'AVICTC2015X1091';

select * from hstdc.ta_fundinfo t where t.c_projcode = 'AVICTC2015X1091';

select * from hstdc.pm_projectinfo t where t.c_fullname like '%天启707%';

--项目存在外部编码
select t.C_PROJECTCODE,t.C_PROJECTCODEALIAS from tprojectinfo_tcmp t where t.C_PROJECTCODE <> t.C_PROJECTCODEALIAS;

--科目余额
select *
  from nc_vouchers t
 where t.c_subcode like '1001%'
   and t.d_busi <= to_date('20160630', 'yyyymmdd') --and t.d_busi >= to_date('20160601', 'yyyymmdd')
   and t.c_fundid = '0001A1100000000002IE' order by t.l_year desc,t.l_month desc;
   
select sum(t.f_debit), sum(t.f_credit), sum(t.f_debit - t.f_credit)
  from nc_vouchers t
 where t.c_subcode like '1001%'
   and t.d_busi <= to_date('20160630', 'yyyymmdd') and t.d_busi >= to_date('20160101', 'yyyymmdd')
   and t.c_fundid = '0001A1100000000002IE';
   
SELECT AM_ORDER.C_ORDERID,
       AM_ORDER.C_PROJCODE,
       AM_ORDER.C_FUNDCODE,
       AM_ORDER.C_EXTYPE,
       AM_ORDER.D_DATE,
       AM_ORDER.D_DELIVERY,
       AM_ORDER.C_REMARK,
       AM_ORDER.F_DLVAMOUNT,
       am_order.c_status
  FROM AM_ORDER
 WHERE AM_ORDER.L_BUSIID = 22151
   and AM_ORDER.C_EXTYPE in ('101', '102', '105', '106')
   and AM_ORDER.C_PROJCODE is  null
   and AM_ORDER.D_DELIVERY <= to_date('20160930', 'yyyymmdd')
   and AM_ORDER.D_DELIVERY is not null
   --and am_order.c_projcode = 'AVICTC2014X0641' /*am_order.c_fundcode in ('ZH03Y8','ZH044Q')*/
 order by AM_ORDER.D_DELIVERY;
 

SELECT NC_FUNDINFO.C_FUNDID_HS,
       NC_VOUCHERS.C_JOURID,
       NC_VOUCHERS.D_BUSI,
       NC_VOUCHERS.C_DIGEST,
       NC_VOUCHERS.C_SUBCODE,
       NC_VOUCHERS.C_SUBNAME,
       NC_VOUCHERS.L_BALDIR,
       NC_VOUCHERS.F_DEBIT,
       NC_VOUCHERS.F_CREDIT,
       NC_VOUCHERS.L_STATE,
       NC_VOUCHERS.L_YEAR,
       NC_VOUCHERS.L_MONTH,
       NC_ASITEM.C_ITEMNO,
       NC_ASCLASS.C_CLASSNO
  FROM NC_FUNDINFO, NC_VOUCHERS, NC_ASITEM, NC_ASCLASS
 WHERE NC_ASCLASS.C_CLASSNO in ('2', 'jobass') --部门和项目辅助核算 
   AND NC_VOUCHERS.C_FUNDID = NC_FUNDINFO.C_FUNDID
   and NC_VOUCHERS.C_COMBID = NC_ASITEM.C_COMBID
   and NC_ASITEM.C_CLASSID = NC_ASCLASS.C_CLASSID;
  
select * from nc_vouchers a,nc_fundinfo b where a.c_fundid = b.c_fundid;
select * from nc_fundinfo;

--项目是否为小贷和场内场外
select t.L_PITCH_FLAG, t.c_promanageflg
  from tprojectinfo_bulu t, hstdc.pm_projectinfo s
 where (t.L_PITCH_FLAG = '1' or t.c_promanageflg = '8')
   and s.c_projcode = 'AVICTC2016X0638'
   and t.c_proj_code = s.c_projcode
   and s.c_projphase <> '99'
   and s.c_projphase >= 30;