--计划放款总额
select sum(a.f_loan_amt)
  from tcf_loan_flow a, tcf_contract b, tcf_loan c
 where a.c_cont_code = b.c_cont_code
   and a.c_loan_code = c.c_loan_code
   and b.c_cont_status <> 'SETL'
   and c.c_finance_status <> 'CLSDB';

--已放款总额
select sum(a.f_loan_amt)
  from tcf_loan_flow a, tcf_contract b, tcf_loan c
 where a.c_cont_code = b.c_cont_code
   and a.c_loan_code = c.c_loan_code
   and b.c_cont_status <> 'SETL'
   and c.c_finance_status <> 'CLSDB'
   and a.c_loan_status = '200';
   
--未放款总额
select sum(a.f_loan_amt)
  from tcf_loan_flow a, tcf_contract b
 where a.c_cont_code = b.c_cont_code   
and a.c_loan_status = '100';

select * from tcf_loan_flow t where t.c_loan_status = '100';
   
select * from tcf_contract t where t.c_cont_code = 'HT201704201000000042191';
   

