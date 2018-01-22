create or replace view v_dept_cost as
select
   sub1.l_month_id,
   sub1.l_dept_id,
   sub1.c_subj_code,
   sub1.c_subj_name,
   sub1.f_amount_eot
   from (
select dd1.l_month_id,
       dd1.l_dept_id,
       dd1.c_subj_code,
       (case when dd1.l_subj_level = 5 then '        '|| dd1.c_subj_name
             when dd1.l_subj_level = 4 then '      '|| dd1.c_subj_name
             when dd1.l_subj_level = 3 then '    '|| dd1.c_subj_name
             else null end) c_subj_name,
       nvl(tt1.f_amount_eot,0) as f_amount_eot
  from TT_FI_ACCOUNTING_DEPT_M tt1,
       (select c.month_id as l_month_id,a.l_subj_id,a.c_subj_code,a.c_subj_name,a.l_subj_level,b.l_dept_id
       from dim_fi_subject a,dim_pb_department b,dim_month c
       where (a.c_subj_code_l2 = '660102' or a.c_subj_code_l3 in( '66010301','66010302'))
       and a.l_leaf_flag = 1
       and c.year_id between 2015 and 2020) dd1
 where tt1.l_month_id(+) = dd1.l_month_id
   and tt1.l_dept_id(+) = dd1.l_dept_id
   and tt1.l_subj_id(+) = dd1.l_subj_id
union all
select tt1.l_month_id,
       tt1.l_dept_id,
       '660102' c_subj_code,
       '  业务拓展费用' c_subj_name,
       sum(tt1.f_amount_eot) f_amount_eot
  from TT_FI_ACCOUNTING_DEPT_M tt1,
       dim_fi_subject          dd1
 where tt1.l_subj_id = dd1.l_subj_id
   and dd1.c_subj_code_l2 = '660102'
 group by tt1.l_month_id,
          tt1.l_dept_id
union all
 select tt1.l_month_id,
        tt1.l_dept_id,
        '660103' c_subj_code,
        '  公杂费' c_subj_name,
        sum(tt1.f_amount_eot) f_amount_eot
   from TT_FI_ACCOUNTING_DEPT_M tt1,
        dim_fi_subject          dd1
  where tt1.l_subj_id = dd1.l_subj_id
    and dd1.c_subj_code_l3 in( '66010301','66010302')
  group by tt1.l_month_id,
           tt1.l_dept_id
union all
 select tt1.l_month_id,
        tt1.l_dept_id,
        '6601' c_subj_code,
        '弹性费用' c_subj_name,
        sum(tt1.f_amount_eot) f_amount_eot
   from TT_FI_ACCOUNTING_DEPT_M tt1,
        dim_fi_subject          dd1
  where tt1.l_subj_id = dd1.l_subj_id
    and (dd1.c_subj_code_l3 in( '66010301','66010302') or dd1.c_subj_code_l2 = '660102')
  group by tt1.l_month_id,
           tt1.l_dept_id
) sub1,dim_pb_department sub2 where sub1.l_dept_id = sub2.l_dept_id and substr(sub2.l_effective_date,1,6) <= sub1.l_month_id and substr(sub2.l_expiration_date,1,6) > sub1.l_month_id;
