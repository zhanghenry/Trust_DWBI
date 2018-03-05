--情况1，生效日期重复
select a.c_proj_code,
       max(a.l_proj_id) as l_max_id,
       min(a.l_proj_id) as l_min_id,
       a.l_effective_date
  from dataedw.dim_pb_project_basic a
 group by a.c_proj_code, a.l_effective_date
having count(*) > 1;

create  table dim_pb_project_basic_20180223 as select * from dim_pb_project_basic;

truncate table temp_proj_repeat_20180223;
drop table temp_proj_repeat_20180223;

create table temp_proj_repeat_20180223 as 
select t.c_proj_code,
       t.l_effective_date,
       min(t.l_proj_id) as l_min_proj_id,
       max(t.l_proj_id) as l_max_proj_id,
       min(t.l_expiration_date) as l_min_expiration_id,
       max(t.l_expiration_date) as l_max_expiration_id
  from dim_pb_project_basic t
 group by t.c_proj_code, t.l_effective_date
having count(*) = 2;

update dim_pb_project_basic t
   set t.l_effective_date =
       (select t1.l_min_expiration_id
          from temp_proj_repeat_20180223 t1
         where t.l_proj_id = t1.l_max_proj_id)
 where t.l_proj_id in
       (select t2.l_max_proj_id from temp_proj_repeat_20180223 t2);

--情况2，失效日期重复
select a.c_proj_code,
       a.l_expiration_date,
       max(a.l_proj_id) as l_max_id,
       min(a.l_proj_id) as l_min_id
  from dataedw.dim_pb_project_basic a
 group by a.c_proj_code, a.l_expiration_date
having count(*) > 1;

--情况3：项目生效日期大于失效日期
select a.l_proj_id,
       a.c_proj_code,
       a.c_proj_name,
       a.l_effective_date,
       a.l_expiration_date,
       a.l_effective_flag
  from dataedw.dim_pb_project_basic a
 where a.l_effective_date >= a.l_expiration_date;
 

--情况5：项目生效日期小于部门生效日期或者失效日期大于部门失效日期
select a.l_proj_id,
       a.c_proj_code,
       a.c_proj_name,
       a.l_effective_date,
       a.l_expiration_date,
       a.l_effective_flag,
       a.l_dept_id,
       b.l_effective_date,
       b.l_expiration_date
  from dataedw.dim_pb_project_basic a, dataedw.dim_pb_department b
 where a.l_dept_id = b.l_dept_id
   and (a.l_effective_date < b.l_effective_date or
       a.l_expiration_date > b.l_expiration_date);
