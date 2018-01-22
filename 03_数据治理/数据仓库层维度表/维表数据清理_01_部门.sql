--情况1，生效日期重复
select a.c_dept_code,
       max(a.l_dept_id) as l_max_id,
       min(a.l_dept_id) as l_min_id,
       a.l_effective_date
  from dataedw.dim_Pb_department a
 group by a.c_dept_code, a.l_effective_date
having count(*) > 1;

--情况2，失效日期重复
select a.c_dept_code,
       a.l_expiration_date,
       max(a.l_dept_id) as l_max_id,
       min(a.l_dept_id) as l_min_id
  from dataedw.dim_Pb_department a
 group by a.c_dept_code, a.l_expiration_date
having count(*) > 1;

--情况3：部门生效日期大于失效日期
select *
  from dataedw.dim_pb_department a
 where a.l_effective_date >= a.l_expiration_date;

--情况4：对于存在多条记录的，失效日期与生效日期之间存在断层


select * from dataedw.dim_pb_department t where t.l_dept_id in (34,74)
