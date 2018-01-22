select * from datadock.tam_order t where t.c_cont_code = 'QT91603M';
select * from datadock.tam_order t where t.c_cont_code = 'CWTZ_304021' and t.c_order_type = 'TZ';
select * from datadock.tam_order t where t.c_proj_code = 'AVICTC2016X0638' and t.c_order_type = 'TZ';
select * from datadock.tam_order t where t.c_prod_code = 'ZH07DJ' and t.c_order_type = 'TZ' and t.c_cont_code like 'XEDK%';

select * from hstdc.am_order t where t.c_fundcode = 'ZH043Z';


select * from datadock.tam_contract t where t.c_cont_code = 'DK11201B';
select * from datadock.tam_order t where t.c_cont_code = 'QS71501H';

select * from datadock.tde_product t where t.c_prod_code = 'ZH01NI';

select * from dataedw.dim_ic_contract t where t.c_cont_code = 'DK1150CW';

select * from dataedw.tt_ic_invest_cont_m t where t.l_cont_id = 135 and t.l_month_id >= 201701;
select * from dataedw.tt_ic_invest_cont_d t where t.l_cont_id = 135 and t.l_day_id >= 20170701;


select * from hstdc.am_order t where t.c_extype is null and t.c_afflid is not null and exists(select 1 from hstdc.am_repayplan s where t.c_afflid = to_number(s.c_planid));

select * from hstdc.am_repayplan t where to_number(t.c_planid) = '2811';
select * from hstdc.am_order t where t.c_afflid = '2811';

select aa.c_cont_code
  from (select distinct a.c_prod_code, a.c_cont_code
          from datadock.tam_order a
         where a.c_order_type = 'TZ') aa
 group by aa.c_cont_code
having count(*) > 1;

select *
  from datadock.tam_contract a
 where a.c_prod_code is null
   and exists (select 1
          from datadock.tam_order b
         where a.c_cont_code = b.c_cont_code
           /*and b.c_order_type = 'TZ'*/);

select * from tfundinfo_hsta t where t.c_fundcode = 'ZH0BHX';

select * from ta_fundinfo t where t.c_fundcode = 'ZH02F6';

SELECT T2.C_PROJ_CODE AS C_PROJ_CODE,
       T2.C_PROD_CODE AS C_PROD_CODE,
       to_char(t1.d_business, 'YYYYMM') AS C_MONTH,
       SUM(CASE WHEN T3.C_SUBJ_CODE LIKE '1303%' THEN T1.F_BALANCE ELSE 0 END) AS F_BALANCE_DK,
       SUM(T1.F_BALANCE) AS F_BALANCE_ZC
  FROM datadock.TFA_VOUCHER T1, datadock.TFA_BOOK T2, datadock.TFA_SUBJECT T3
 WHERE T1.C_BOOK_CODE = T2.C_BOOK_CODE
   AND T1.C_BOOK_CODE = T3.C_BOOK_CODE
   AND T1.C_SUBJ_CODE = T3.C_SUBJ_CODE
   AND SUBSTR(T3.C_SUBJ_CODE, 1, 4) IN ('1101', '1111', '1303','1501','1503','1531','1541','1122','1511')
   AND EXISTS (select 1 from tam_contract t4 where t2.c_prod_code = t4.c_prod_code and t4.c_cont_type = 'XN')
   and t2.c_Prod_code = 'ZH041T'
 GROUP BY T2.C_PROJ_CODE, T2.C_PROD_CODE, to_char(t1.d_business, 'YYYYMM');
 
select to_char(t.d_actual, 'yyyymm'), sum(t.f_invest) * -1
  from datadock.tam_order t
 where t.c_prod_code = 'ZH07DJ'
   and t.c_order_type = 'TZ'
 group by to_char(t.d_actual, 'yyyymm');
 
 
SELECT T2.c_Proj_Code as C_PROJ_CODE,
       T2.C_PROD_CODE AS C_PROD_CODE,
       T2.C_CONT_CODE AS C_CONT_CODE,
       TO_CHAR(T1.D_PLAN, 'YYYYMM') AS C_MONTH,
       SUM(T1.F_INVEST)*-1 AS F_BALANCE_INVEST
  FROM datadock.TAM_ORDER T1, datadock.TAM_CONTRACT T2
 WHERE T1.C_ORDER_TYPE = 'TZ'
   AND T1.c_prod_code = t2.c_prod_code
   AND T1.C_ORDER_SN NOT LIKE 'XNHT_%'
   AND T2.C_CONT_TYPE = 'XN'
   and t2.c_Prod_code = 'ZH043Z'
 GROUP BY T2.C_PROJ_CODE,
          T2.C_PROD_CODE,
          T2.C_CONT_CODE,
          TO_CHAR(T1.D_PLAN, 'YYYYMM');
          
select * from hsstg.v_ts2am_order_xt t where t.c_pactid = 'DK11201B';
select * from hstdc.am_order t where t.c_pactid = 'DK11201B';
select * from datadock.tam_order t where t.c_cont_code = 'DK11201B';

select * from datadock.tde_product t where t.c_prod_code in ('ZH004E','ZH013J','ZH00TH');
select * from datadock.tde_product t where t.c_prod_code in ('ZH004E','ZH009L','ZH0035','ZH003M','ZH003V');

select * from BULU_AMFAREPLAN t where t.l_serial_no  in (11277,49711,49712,5468);

select * from hstdc.am_repayplan t where t.c_pactid = 'DK11201B';
select * from BULU_AMFAREPLAN t where t.vc_product_id = 'ZH004E';
select * from hstdc.am_order t where t.c_fundcode = 'ZH004E';

