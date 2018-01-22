--项目要素
--成立日期大于清算日期或预计到期日期
select *
  from pm_projectinfo a
 where (a.d_begdate > a.d_predue or
       a.d_begdate > nvl(a.d_enddate, a.d_begdate));

--合同有投资金额但没有合同信息
select a1.*
  from hstdc.am_pact a,
       (select b.c_cont_code, sum(b.f_invest) as f_invest
          from datadock.tam_order b
         where b.c_order_type = 'TZ'
           and b.c_order_sn not like 'XNHT%'
         group by b.c_cont_code) a1
 where a.c_pactid(+) = a1.c_cont_code
   and a.c_pactid is null
   and a1.f_invest <> 0;

--项目已经完结但存在信托规模的
select b.c_projcode, sum(a.f_debit - a.f_credit)
  from hstdc.fa_vouchers a, hstdc.fa_fundinfo b
 where a.c_fundid = b.c_fundid
   and a.c_subcode like '4001%'
   and a.l_state < 32
 group by a.c_fundid;

--有到期日期但还有规模
select t4.d_expiry, t3.*
  from (select t2.c_proj_code, sum(t1.f_balance)
          from datadock.tfa_voucher t1, datadock.tfa_book t2
         where t1.c_book_code = t2.c_book_code
           and t1.c_subj_code like '4001%'
           and t1.c_voucher_status <> '32'
         group by t2.c_proj_code
        having sum(t1.f_balance) <> 0) t3,
       datadock.tde_project t4
 where t3.c_proj_code = t4.c_proj_code
   and t4.c_proj_phase = '99';
