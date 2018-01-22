--人力
select t1.c_emp_code,
       t1.c_emp_name,
       t1.c_name_abbr,
       t1.c_emp_type_n,
       t4.c_duty_name,
       t4.c_duty_cate_n,
       t2.c_dept_code,
       t2.c_dept_name,
       t2.c_dept_cate_n,
       t3.c_indiv_name,
       t3.c_sex_type_n,
       t3.l_age,
       t3.c_ethnic_n,
       t3.c_politics_status_n,
       t3.c_marital_status_n,
       t3.l_working_years,
       t3.c_education_n
  from tde_employee t1, tde_department t2, tde_individual t3,thr_duty t4
 where t1.c_dept_code = t2.c_dept_code
   and t1.c_unique_code = t3.c_indiv_code
   and t1.c_duty_code = t4.c_duty_code(+)
   and t3.c_indiv_cate = 'YG' and t1.c_emp_name = '王立宏';