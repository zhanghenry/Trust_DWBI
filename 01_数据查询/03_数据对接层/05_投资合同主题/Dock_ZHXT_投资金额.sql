select rowid,t.* from ttainfo t;

select * from tam_contract t where t.c_cont_code = 'CWTZ_102796';

select *
  from tam_order t
 where t.c_cont_code = 'DK1150J7'
   and t.c_order_type = 'TZ'
   and t.d_plan <= to_date('20170331', 'yyyymmdd');

select * from tam_order t where t.c_cont_code = 'DK1120JV';

select * from tam_order t where t.d_plan =  to_date('20160731', 'yyyymmdd');

SELECT T2.c_Proj_Code as C_PROJ_CODE,
       T2.C_PROD_CODE AS C_PROD_CODE,
       T2.C_CONT_CODE AS C_CONT_CODE,
       TO_CHAR(T1.D_PLAN, 'YYYYMM') AS C_MONTH,
       SUM(T1.F_INVEST)*-1 AS F_BALANCE_INVEST
  FROM TAM_ORDER T1, TAM_CONTRACT T2
 WHERE T1.C_ORDER_TYPE = 'TZ'
   AND T1.c_prod_code = t2.c_prod_code
   AND T1.C_ORDER_SN NOT LIKE 'XNHT_%'
   AND T2.C_CONT_TYPE = 'XN' and t2.c_cont_code = 'DK1131FP'
 GROUP BY T2.C_PROJ_CODE,
          T2.C_PROD_CODE,
          T2.C_CONT_CODE,
          TO_CHAR(T1.D_PLAN, 'YYYYMM');
          
SELECT t2.c_book_code,T2.C_PROJ_CODE AS C_PROJ_CODE,
       T2.C_PROD_CODE AS C_PROD_CODE,
       to_char(t1.d_business, 'YYYYMM') AS C_MONTH,
       SUM(CASE
             WHEN T3.C_SUBJ_CODE LIKE '1303%' THEN
              T1.F_BALANCE
             ELSE
              0
           END) AS F_BALANCE_DK,
       SUM(T1.F_BALANCE) AS F_BALANCE_ZC
  FROM TFA_VOUCHER T1, TFA_BOOK T2, TFA_SUBJECT T3
 WHERE T1.C_BOOK_CODE = T2.C_BOOK_CODE and t2.c_proj_code = 'AVICTC2012X0227' and t1.d_business <= to_date('20170331','yyyymmdd')
   AND T1.C_BOOK_CODE = T3.C_BOOK_CODE
   AND T1.C_SUBJ_CODE = T3.C_SUBJ_CODE
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
   /*AND EXISTS (select 1
          from tam_contract t4
         where t2.c_prod_code = t4.c_prod_code
           and t4.c_cont_type = 'XN')*/
 GROUP BY t2.c_book_code,T2.C_PROJ_CODE, T2.C_PROD_CODE, to_char(t1.d_business, 'YYYYMM');
 
select t1.*
  from tfa_voucher t1, tfa_book t2
 where t1.c_book_code = t2.c_book_code
   and t2.c_proj_code = 'AVICTC2013X0308'
   and t1.d_business <= to_date('20170331', 'yyyymmdd')
   AND SUBSTR(T1.C_SUBJ_CODE, 1, 4) IN
       ('1101',
        '1111',
        '1303',
        '1501',
        '1503',
        '1531',
        '1541',
        '1122',
        '1511');
