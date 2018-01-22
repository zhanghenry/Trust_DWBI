-- 存款利息
select nvl((select sum(a.f_amount_eot)
              from tt_fi_accounting_co_m a, dim_fi_subject b
             where a.l_subj_id = b.l_subj_id
               and b.c_subj_code_l2 = '601102'
               and a.l_month_id = :L_MONTH_ID) -
           (select sum(a.f_amount_eot)
              from tt_fi_accounting_co_m a, dim_fi_subject b
             where a.l_subj_id = b.l_subj_id
               and b.c_subj_code_l2 = '641102'
               and a.l_month_id = :L_MONTH_ID),
           0) as f_value
  from dual;
  
--贷款利息
select a.f_amount_eot as f_value
  from tt_fi_accounting_co_m a, dim_fi_subject b
 where a.l_subj_id = b.l_subj_id
   and b.c_subj_code_l2 = '601101'
   and a.l_month_id = :L_MONTH_ID;
   
--投资收益
select sum(a.f_amount_eot) as f_value
  from tt_fi_accounting_co_m a, dim_fi_subject b
 where a.l_subj_id = b.l_subj_id
   and b.c_subj_code_l1 in ('6101','6111')
   and a.l_month_id = :L_MONTH_ID;

--新增收入
select nvl((select sum(a.f_amount_eot)
              from tt_fi_accounting_co_m a, dim_fi_subject b
             where a.l_subj_id = b.l_subj_id
               and b.c_subj_code_l2 = '601202'
               and a.l_month_id = :L_MONTH_ID) -
           (select sum(a.f_amount_eot)
              from tt_fi_accounting_co_m a, dim_fi_subject b
             where a.l_subj_id = b.l_subj_id
               and b.c_subj_code_l1 = '6412'
               and a.l_month_id = :L_MONTH_ID),
           0) as f_value
  from dual;
  
--存续收入
select sum(a.f_amount_eot) as f_value
  from tt_fi_accounting_co_m a, dim_fi_subject b
 where a.l_subj_id = b.l_subj_id
   and b.c_subj_code_l2 = '601299'
   and a.l_month_id = :L_MONTH_ID; 
  
--财富直销收入
select nvl((select sum(a.f_amount_eot)
              from tt_fi_accounting_co_m a, dim_fi_subject b
             where a.l_subj_id = b.l_subj_id
               and b.c_subj_code_l2 = '601203'
               and a.l_month_id = :L_MONTH_ID) +
           (select sum(a.f_amount_eot)
              from tt_fi_accounting_co_m a, dim_fi_subject b
             where a.l_subj_id = b.l_subj_id
               and b.c_subj_code_l2 = '601204'
               and a.l_month_id = :L_MONTH_ID),
           0) as f_value
  from dual;   

--基金收入
select sum(a.f_amount_eot) as f_value
  from tt_fi_accounting_co_m a, dim_fi_subject b
 where a.l_subj_id = b.l_subj_id
   and b.c_subj_code_l2 = '605104'
   and a.l_month_id = :L_MONTH_ID; 

--居间收入
select nvl((select sum(a.f_amount_eot)
              from tt_fi_accounting_co_m a, dim_fi_subject b
             where a.l_subj_id = b.l_subj_id
               and b.c_subj_code_l2 = '605101'
               and a.l_month_id = :L_MONTH_ID) +
           (select sum(a.f_amount_eot)
              from tt_fi_accounting_co_m a, dim_fi_subject b
             where a.l_subj_id = b.l_subj_id
               and b.c_subj_code_l2 = '605103'
               and a.l_month_id = :L_MONTH_ID),
           0) as f_value
  from dual;

--营业税金及附加
select sum(a.f_amount_eot) as f_value
  from tt_fi_accounting_co_m a, dim_fi_subject b
 where a.l_subj_id = b.l_subj_id
   and b.c_subj_code_l1 = '6403'
   and a.l_month_id = :L_MONTH_ID; 
   
--租赁费
select sum(a.f_amount_eot) as f_value
  from tt_fi_accounting_co_m a, dim_fi_subject b
 where a.l_subj_id = b.l_subj_id
   and b.c_subj_code_l3 = '66010303'
   and a.l_month_id = :L_MONTH_ID; 
   
--资产摊提
select sum(a.f_amount_eot) as f_value
  from tt_fi_accounting_co_m a, dim_fi_subject b
 where a.l_subj_id = b.l_subj_id
   and b.c_subj_code_l2 = '660104'
   and a.l_month_id = :L_MONTH_ID; 

--弹性费用  
--不动产投资管理总部
select sum(a.f_amount_eot) as f_value
  from tt_fi_accounting_dept_m a, dim_fi_subject b, dim_pb_department c
 where a.l_subj_id = b.l_subj_id
   and (b.c_subj_code_l2 = '660102' or
       b.c_subj_code_l3 in ('66010301', '66010302'))
   and a.l_dept_id = c.l_dept_id
   and c.c_dept_code_l1 = '0_ms17'
   and c.c_dept_cate = '1'
   and c.l_effective_flag = 1
   and a.l_month_id = :L_MONTH_ID;
   
--固定人力成本 
--不动产投资管理总部
select nvl((select sum(a.f_amount_eot)
              from tt_fi_accounting_dept_m a,
                   dim_fi_subject          b,
                   dim_pb_department       c
             where a.l_subj_id = b.l_subj_id
               and a.l_dept_id = c.l_dept_id
               and c.l_effective_flag = 1
               and b.c_subj_code_l2 = '660101'
               and c.c_dept_code_l1 = '0_ms17'
               and a.l_month_id = :L_MONTH_ID) +
           (select sum(a.f_amount_eot)
              from tt_fi_accounting_dept_m a,
                   dim_fi_subject          b,
                   dim_pb_department       c
             where a.l_subj_id = b.l_subj_id
               and a.l_dept_id = c.l_dept_id
               and c.l_effective_flag = 1
               and b.c_subj_code_l3 = '66010113'
               and c.c_dept_code_l1 = '0_ms17'
               and a.l_month_id = :L_MONTH_ID),
           0) as f_value
  from dual;

select * from dim_fi_subject t where t.c_subj_code like '601101%';

select * from dim_pb_department t where t.c_dept_code_l1 = '0_ms17';
