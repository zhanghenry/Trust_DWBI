--估值按帐套实收信托
select s.c_book_code,
 sum(t.f_balance)
  from tfa_voucher t, tfa_book s
 where t.c_book_code = s.c_book_code
   and t.c_subj_code like '4001%'
   and t.c_voucher_status < '32'
   and t.d_business <= to_date('20161130', 'yyyymmdd')
 group by s.c_book_code
having sum(t.f_balance) <> 0;

--估值资产--按帐套
select t.c_book_code, sum(t.f_balance)
  from tfa_voucher t, tfa_book s
 where t.c_book_code = s.c_book_code
   and t.c_subj_code like '1%'
   and t.c_voucher_status < '32'
   and t.d_business <= to_date('20161130', 'yyyymmdd')
 group by t.c_book_code
having sum(t.f_balance) <> 0;

--估值资产-投向行业
select b.c_book_code,
       b.c_book_name,
       sum(decode(c.c_invest_indus, 'HYTX_JCCY', a.f_balance, 0)) as 基础产业,
       sum(decode(c.c_invest_indus, 'HYTX_FDC', a.f_balance, 0)) as 房地产,
       sum(decode(c.c_invest_indus, 'HYTX_ZQ', a.f_balance, 0)) as 证券,
       sum(decode(c.c_invest_indus, 'HYTX_JRJG', a.f_balance, 0)) as 金融机构,
       sum(decode(c.c_invest_indus, 'HYTX_GSQY', a.f_balance, 0)) as 工商企业,
       sum(decode(c.c_invest_indus, 'HYTX_QT', a.f_balance, 0)) as 其他
  from tfa_voucher a, tfa_book b, tfa_subject c
 where a.c_book_code = c.c_book_code
   and a.c_subj_code = c.c_subj_code
   and b.c_book_code = c.c_book_code
   and a.c_voucher_status < '32'
   and a.c_indust_code is not null
   and a.d_business <= to_date('20161130', 'yyyymmdd')
 group by b.c_book_code, b.c_book_name;

--估值资产-资金运用方式
select b.c_book_code, b.c_book_name, 
sum(decode(c.c_fduse_way,'YYFS_DK',a.f_balance,0)) as 贷款,
sum(decode(c.c_fduse_way,'YYFS_JYXJRZC',a.f_balance,0)) as 交易性金融资产,
sum(decode(c.c_fduse_way,'YYFS_KGCSJCYZDQ',a.f_balance,0)) as 可供出售及持有至到期,
sum(decode(c.c_fduse_way,'YYFS_GQTZ',a.f_balance,0)) as 股权投资,
sum(decode(c.c_fduse_way,'YYFS_ZL',a.f_balance,0)) as 租赁,
sum(decode(c.c_fduse_way,'YYFS_MRFS',a.f_balance,0)) as 买入返售,
sum(decode(c.c_fduse_way,'YYFS_CC',a.f_balance,0)) as 拆出,
sum(decode(c.c_fduse_way,'YYFS_CFTY',a.f_balance,0)) as 存放同业,
sum(decode(c.c_fduse_way,'YYFS_QT',a.f_balance,0)) as 其他
  from tfa_voucher a, tfa_book b,tfa_subject c
 where a.c_book_code = c.c_book_code
   and a.c_subj_code = c.c_subj_code
   and b.c_book_code = c.c_book_code
   and a.c_voucher_status < '32'
   and a.c_fduse_code is not null
   and a.d_business <= to_date('20161130', 'yyyymmdd')
 group by b.c_book_code, b.c_book_name; 
 
--指定项目FA凭证科目明细
SELECT TFA_VOUCHER.D_BUSINESS,
       TFA_VOUCHER.C_BOOK_CODE,
       TFA_VOUCHER.C_SUBJ_CODE,
       TFA_VOUCHER.C_COMMENTS,
       TFA_VOUCHER.C_DIRECTION_TYPE,
       TFA_VOUCHER.F_DEBIT,
       TFA_VOUCHER.F_CREDIT,
       TFA_SUBJECT.C_SUBJ_NAME,
       TFA_SUBJECT.C_SUBJ_TYPE,
       TFA_BOOK.C_PROJ_CODE
  FROM TFA_VOUCHER, TFA_SUBJECT, TFA_BOOK
 WHERE TFA_VOUCHER.D_BUSINESS <= TO_DATE(20160831, 'YYYYMMDD')
   and TFA_SUBJECT.C_SUBJ_TYPE IN ('6')
   and TFA_SUBJECT.C_SUBJ_CODE not like '6408%'
   and TFA_BOOK.L_VALID_FLAG = 1
   AND TFA_VOUCHER.C_BOOK_CODE = TFA_SUBJECT.C_BOOK_CODE
   and TFA_SUBJECT.C_SUBJ_CODE = TFA_VOUCHER.C_SUBJ_CODE
   and TFA_SUBJECT.C_BOOK_CODE = TFA_BOOK.C_BOOK_CODE
   and TFA_BOOK.c_proj_code = 'F878';

--估值帐套净值、7日年化
select *
  from (select t1.c_book_code, t2.c_proj_code, t2.c_proj_name
          from tfa_book t1, tde_project t2
         where t1.c_proj_code = t2.c_proj_code
           and t2.c_dept_code = '841') a
  left outer join (select *
                     from tfa_valuation
                    where d_valuation = to_date('20160930', 'yyyymmdd')) b
    on a.c_book_code = b.c_book_code;   
   
--指定项目FA实收信托赎回记录  
SELECT TFA_VOUCHER.D_BUSINESS,
       TFA_VOUCHER.C_BOOK_CODE,
       TFA_VOUCHER.C_SUBJ_CODE,
       TFA_VOUCHER.C_COMMENTS,
       TFA_VOUCHER.C_DIRECTION_TYPE,
       TFA_VOUCHER.F_DEBIT,
       TFA_VOUCHER.F_CREDIT,
       TFA_SUBJECT.C_SUBJ_NAME,
       TFA_SUBJECT.C_SUBJ_TYPE,
       TFA_BOOK.C_PROJ_CODE
  FROM TFA_VOUCHER, TFA_SUBJECT, TFA_BOOK
 WHERE TFA_VOUCHER.D_BUSINESS <= TO_DATE(20160630, 'YYYYMMDD')
   and TFA_VOUCHER.C_SUBJ_CODE LIKE '4001%'
   and TFA_BOOK.L_VALID_FLAG = 1
   AND TFA_VOUCHER.C_COMMENTS NOT LIKE '%非交易过户'
   AND TFA_VOUCHER.C_COMMENTS NOT LIKE '%转让%'
   AND TFA_VOUCHER.C_COMMENTS NOT LIKE '%科目编码调整'
   AND TFA_VOUCHER.F_DEBIT <> 0
   AND TFA_VOUCHER.C_BOOK_CODE = TFA_SUBJECT.C_BOOK_CODE
   and TFA_SUBJECT.C_SUBJ_CODE = TFA_VOUCHER.C_SUBJ_CODE
   and TFA_SUBJECT.C_BOOK_CODE = TFA_BOOK.C_BOOK_CODE
   and TFA_BOOK.C_PROJ_CODE = 'C040';
   
--指定项目FA中非交易过户记录
SELECT B.C_SUBJ_CODE AS C_OUT_SUBJ_CODE,
       A.C_BOOK_CODE AS C_BOOK_CODE,
       A.D_BUSINESS  AS D_BUSINESS,
       A.C_SUBJ_CODE AS C_IN_SUBJ_CODE,
       A.F_DEBIT     AS F_IN_TRANSFER
  FROM (SELECT TFA_BOOK.C_BOOK_CODE,
               TFA_BOOK.C_PROJ_CODE,
               TFA_VOUCHER.D_BUSINESS,
               TFA_VOUCHER.C_SUBJ_CODE,
               TFA_VOUCHER.F_DEBIT
          FROM TFA_BOOK, TFA_VOUCHER
         WHERE TFA_BOOK.C_BOOK_CODE = TFA_VOUCHER.C_BOOK_CODE
           AND TFA_VOUCHER.C_SUBJ_CODE LIKE '4001%'
           AND TFA_BOOK.L_VALID_FLAG = 1
           AND TFA_VOUCHER.F_DEBIT <> 0
           AND TFA_VOUCHER.D_BUSINESS <= TO_DATE('20160630', 'YYYYMMDD')
           AND (TFA_VOUCHER.C_COMMENTS LIKE '%非交易过户' OR
               TFA_VOUCHER.C_COMMENTS LIKE '%转让%' OR
               TFA_VOUCHER.C_COMMENTS LIKE '%科目编码调整')) A,
       (SELECT TFA_BOOK.C_BOOK_CODE,
               TFA_VOUCHER.D_BUSINESS,
               TFA_VOUCHER.C_SUBJ_CODE,
               TFA_VOUCHER.F_CREDIT
          FROM TFA_BOOK, TFA_VOUCHER
         WHERE TFA_BOOK.C_BOOK_CODE = TFA_VOUCHER.C_BOOK_CODE
           AND TFA_VOUCHER.C_SUBJ_CODE LIKE '4001%'
           AND TFA_BOOK.L_VALID_FLAG = 1
           AND TFA_VOUCHER.F_CREDIT <> 0
           AND TFA_VOUCHER.D_BUSINESS <= TO_DATE('20160630', 'YYYYMMDD')
           AND (TFA_VOUCHER.C_COMMENTS LIKE '%非交易过户' OR
               TFA_VOUCHER.C_COMMENTS LIKE '%转让%' OR
               TFA_VOUCHER.C_COMMENTS LIKE '%科目编码调整')) B
 WHERE A.C_BOOK_CODE = B.C_BOOK_CODE
   AND A.D_BUSINESS = B.D_BUSINESS
   AND A.F_DEBIT = B.F_CREDIT
   AND A.C_PROJ_CODE = 'C040';
