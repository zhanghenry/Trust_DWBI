--估值资产
SELECT T2.C_PROJ_CODE AS C_PROJ_CODE,
       SUM(T1.F_BALANCE) AS F_BALANCE_ZC
  FROM TFA_VOUCHER T1, TFA_BOOK T2, TFA_SUBJECT T3
 WHERE T1.C_BOOK_CODE = T2.C_BOOK_CODE
   AND T1.C_BOOK_CODE = T3.C_BOOK_CODE
   AND T1.C_SUBJ_CODE = T3.C_SUBJ_CODE and t1.d_business <= to_date('20170331','yyyymmdd')
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
 GROUP BY T2.C_PROJ_CODE having SUM(T1.F_BALANCE) <> 0;
 
--估值资产明细
SELECT  SUBSTR(T3.C_SUBJ_CODE, 1, 4),
       SUM(T1.F_BALANCE) AS F_BALANCE_ZC
  FROM TFA_VOUCHER T1, TFA_BOOK T2, TFA_SUBJECT T3
 WHERE T1.C_BOOK_CODE = T2.C_BOOK_CODE and t2.c_proj_code = 'AVICTC2013X0045'
   AND T1.C_BOOK_CODE = T3.C_BOOK_CODE
   AND T1.C_SUBJ_CODE = T3.C_SUBJ_CODE and t1.d_business <= to_date('20170331','yyyymmdd')
   AND SUBSTR(T3.C_SUBJ_CODE, 1, 4) IN
       ('1101',
        '1111',
        '1303',
        '1501',
        '1503',
        '1531',
        '1541',
        '1122',
        '1511') group by  SUBSTR(T3.C_SUBJ_CODE, 1, 4);

--估值资产明细
SELECT  T3.C_SUBJ_CODE,
       SUM(T1.F_BALANCE) AS F_BALANCE_ZC
  FROM TFA_VOUCHER T1, TFA_BOOK T2, TFA_SUBJECT T3
 WHERE T1.C_BOOK_CODE = T2.C_BOOK_CODE and t2.c_proj_code = 'AVICTC2013X0045'
   AND T1.C_BOOK_CODE = T3.C_BOOK_CODE
   AND T1.C_SUBJ_CODE = T3.C_SUBJ_CODE and t1.d_business <= to_date('20170331','yyyymmdd')
   AND SUBSTR(T3.C_SUBJ_CODE, 1, 4) IN
       ('1101',
        '1111',
        '1303',
        '1501',
        '1503',
        '1531',
        '1541',
        '1122',
        '1511') group by  T3.C_SUBJ_CODE having   SUM(T1.F_BALANCE) <> 0;
        
select t.*/*sum(t.f_balance)*/
  from tfa_voucher t, tfa_book t1, tde_project t2
 where t.c_book_code = t1.c_book_code
   and t1.c_proj_code = t2.c_proj_code
   and t.d_business <= to_date('20170331','yyyymmdd')
   and t2.c_proj_code = 'AVICTC2013X0790'
   --and t.c_book_code = '201691'
   and SUBSTR(t.C_SUBJ_CODE, 1, 4) IN
       ('1101',
        '1111',
        '1303',
        '1501',
        '1503',
        '1531',
        '1541',
        '1122',
        '1511');
