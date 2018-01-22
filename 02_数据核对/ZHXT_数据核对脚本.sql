--Dock投资规模-AM合同
select a.c_cont_code, sum(a.f_invest) * -1
  from datadock.tam_order a
 where a.c_order_type = 'TZ'
   and a.d_actual <= to_date('20170731', 'yyyymmdd')
 group by a.c_cont_code having sum(a.f_invest) <> 0;

--EDW投资规模-AM合同
select t1.c_cont_code, sum(t.f_balance_agg) as f_balance_agg
  from dataedw.tt_ic_invest_cont_m t, dataedw.dim_ic_contract t1
 where t.l_cont_id = t1.l_cont_id
   and t.l_month_id = 201707
   and substr(t1.l_effective_date, 1, 6) <= t.l_month_id
   and substr(t1.l_expiration_date, 1, 6) > t.l_month_id
 group by t1.c_cont_code
having sum(t.f_balance_agg) <> 0;

--Dock投资规模-AM虚拟合同
select a.c_prod_code, sum(a.f_invest) * -1
  from datadock.tam_order a
 where a.c_order_type = 'TZ'
   and a.d_actual <= to_date('20170731', 'yyyymmdd')
   and exists (select 1 from datadock.tam_contract b where a.c_prod_code = b.c_prod_code and b.c_cont_type = 'XN' and b.c_cont_code like 'CWTZ%')
 group by a.c_prod_code
having sum(a.f_invest) <> 0;

--Dock投资规模-FA产品--虚拟
SELECT T2.C_PROD_CODE AS C_PROD_CODE,
       --SUM(CASE WHEN T3.C_SUBJ_CODE LIKE '1303%' THEN T1.F_BALANCE ELSE 0 END) AS F_BALANCE_DK,
       SUM(T1.F_BALANCE) AS F_BALANCE_ZC
  FROM datadock.TFA_VOUCHER T1, datadock.TFA_BOOK T2, datadock.TFA_SUBJECT T3
 WHERE T1.C_BOOK_CODE = T2.C_BOOK_CODE
   AND T1.C_BOOK_CODE = T3.C_BOOK_CODE
   AND T1.C_SUBJ_CODE = T3.C_SUBJ_CODE
   AND t1.d_business <= to_date('20170731','yyyymmdd')
   AND SUBSTR(T3.C_SUBJ_CODE, 1, 4) IN
       ('1101',
        '1111',
        '1303',
        '1501',
        '1503',
        '1531',
        '1541',
        '1122',
        '1511')
   AND EXISTS (select 1
          from tam_contract t4
         where t2.c_prod_code = t4.c_prod_code
           and t4.c_cont_type = 'XN' and t4.c_cont_code like 'CWTZ%')
 GROUP BY T2.C_PROD_CODE having SUM(T1.F_BALANCE) <> 0;

--Dock投资规模-产品
select a.c_prod_code, sum(case when c.c_special_type = 'A' and b.c_cont_code not like 'XEDK%' and b.c_busi_type = '1' then 0 else a.f_invest end) * -1
  from datadock.tam_order a,datadock.tam_contract b,datadock.tde_project c
 where a.c_cont_code = b.c_cont_code 
   and a.c_proj_code = c.c_proj_code
   and a.c_order_type = 'TZ'
   and a.d_actual <= to_date('20170731', 'yyyymmdd')
 group by a.c_prod_code
having sum(a.f_invest) <> 0;
 
--EDW投资规模-产品
select t2.c_prod_code, sum(case when t3.c_special_type = 'A' and t1.c_cont_code not like 'XEDK%' and t1.c_busi_type = '1' then 0 else t.f_balance_agg end) as f_balance_agg
  from dataedw.tt_ic_invest_cont_m t,
       dataedw.dim_ic_contract     t1,
       dataedw.dim_pb_product      t2,
       dataedw.dim_pb_project_biz  t3
 where t.l_cont_id = t1.l_cont_id
   and t1.l_prod_id = t2.l_prod_id
   and t2.l_proj_id = t3.l_proj_id
   and t.l_month_id = 201707
   and substr(t1.l_effective_date, 1, 6) <= t.l_month_id
   and substr(t1.l_expiration_date, 1, 6) > t.l_month_id
 group by t2.c_prod_code
having sum(t.f_balance_agg) <> 0;

select * from dataedw.dim_pb_product t where t.c_prod_code='ZH07DJ';
select * from datadock.tde_product t where t.c_prod_code = 'ZH041T';
select * from hstdc.ta_fundinfo t where t.c_fundcode = 'ZH09ZU';

select * from dataedw.tt_ic_invest_cont_m t where t.l_prod_id = 5997 and t.l_month_id = 201707;
select * from dataedw.dim_ic_contract t where t.l_cont_id in (4511,5271);
