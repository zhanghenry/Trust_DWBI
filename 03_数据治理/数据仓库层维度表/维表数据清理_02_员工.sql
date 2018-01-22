--情况1，生效日期重复
select a.c_emp_code,
       max(a.l_emp_id) as l_max_id,
       min(a.l_emp_id) as l_min_id,
       a.l_effective_date
  from dataedw.dim_pb_employee a
 group by a.c_emp_code, a.l_effective_date
having count(*) > 1;

--情况2，失效日期重复
select a.c_emp_code,
       a.l_expiration_date,
       max(a.l_emp_id) as l_max_id,
       min(a.l_emp_id) as l_min_id
  from dataedw.dim_pb_employee a
 group by a.c_emp_code, a.l_expiration_date
having count(*) > 1;

--情况3：部门生效日期大于失效日期
select a.l_emp_id,
       a.c_emp_code,
       a.c_emp_name,
       a.l_effective_date,
       a.l_expiration_date,
       a.l_effective_flag
  from dataedw.dim_pb_employee a
 where a.l_effective_date >= a.l_expiration_date;
 
--情况4：对于存在多条记录的，失效日期与生效日期之间存在断层


--情况5：员工生效日期小于部门生效日期或者员工失效日期大于部门失效日期
select a.l_emp_id,
       a.c_emp_code,
       a.c_emp_name,
       a.l_effective_date,
       a.l_expiration_date,
       a.l_effective_flag,
       a.l_dept_id,
       b.l_effective_date,
       b.l_expiration_date
  from dataedw.dim_pb_employee a, dataedw.dim_pb_department b
 where a.l_dept_id = b.l_dept_id
   and (a.l_effective_date < b.l_effective_date or
       a.l_expiration_date > b.l_expiration_date);
