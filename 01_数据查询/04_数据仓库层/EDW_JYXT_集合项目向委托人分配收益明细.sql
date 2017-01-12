--信托合同信息
select distinct T.L_SETTLER_ID
  from dim_tc_contract t
 where t.l_proj_id = 2646;

--委托人信息
select * from dim_ca_customer t where t.l_cust_id in (6225, 9444);

--集合项目及委托人明细
drop table temp_20170112_1;
create table temp_20170112_1 as
select a.l_proj_id,
       a.c_proj_code,
       a.c_proj_name,
       b.c_proj_type_n,
       d.c_cust_name,
       d.c_cust_type,
       d.c_cust_tytpe_n
  from dim_pb_project_basic a,
       dim_pb_project_biz   b,
       dim_tc_contract      c,
       dim_ca_customer      d
 where a.l_proj_id = b.l_proj_id
   and a.l_effective_flag = 1
   and a.l_proj_id = c.l_proj_Id
   and c.L_settler_id = d.l_cust_id --and a.l_proj_id = 468
   and b.c_proj_type_n = '集合';

--集合项目及应付收益明细
drop table temp_20170112_2;
create table temp_20170112_2 as
select c.c_book_code,
       c.l_proj_id,
       d.c_subj_code,
       d.c_subj_name,
       substr(e.l_busi_date, 1, 4) as c_year,
       sum(e.f_credit) as f_amount
  from dim_to_book             c,
       dim_to_subject          d,
       tt_to_accounting_flow_d e,
       dim_pb_project_basic    a,
       dim_pb_project_biz      b
 where c.l_book_id = e.l_book_id
   and a.l_proj_id = c.l_proj_id
   and a.l_proj_id = b.l_proj_id
   and a.l_effective_flag = 1
   and b.c_proj_type_n = '集合'
   and d.l_subj_id = e.l_subj_id
   and d.c_subj_code like '2205%' --and c.l_proj_id = 55
 group by c.c_book_code,
          c.l_proj_id,
          d.c_subj_code,
          d.c_subj_name,
          substr(e.l_busi_date, 1, 4);

--估值有收益但无法关联到委托人
select *
  from temp_20170112_1 a
  full outer join temp_20170112_2 b
    on a.l_proj_id = b.l_proj_id
   and trim(a.c_cust_name) = trim(b.c_subj_name)
 where a.c_cust_name is null;

--按项目按委托人类型按年统计应付收益
select a.c_proj_code,
       a.c_proj_name,
       a.c_cust_tytpe_n,
       b.c_year,
       sum(b.f_amount)
  from temp_20170112_1 a
  full outer join temp_20170112_2 b
    on a.l_proj_id = b.l_proj_id
   and trim(a.c_cust_name) = trim(b.c_subj_name)
 group by a.c_proj_code, a.c_proj_name, a.c_cust_tytpe_n, b.c_year
 order by a.c_proj_code, a.c_proj_name, a.c_cust_tytpe_n, b.c_year;
