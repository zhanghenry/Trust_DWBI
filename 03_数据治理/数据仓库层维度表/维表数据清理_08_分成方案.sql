--分成表异常数据清理
create table temp_bm_sxrqcf as 
select a.c_scheme_code,
       b.c_stage_code,
       c.c_dept_code,
       c.c_dept_name,
       a.l_begdiv_date,
       a.l_effective_date,
       max(a.l_scheme_id) as l_max_scheme_id,
       min(a.l_scheme_id) as l_min_scheme_id,
       max(a.l_effective_date) as l_max_effecttive_date,
       min(a.l_effective_date) as l_min_effecttive_date,
       max(a.l_expiration_date) as l_max_expiration_date,
       min(a.l_expiration_date) as l_min_expiration_date
  from dim_pe_divide_scheme a, dim_sr_stage b, dim_pb_department c
 where a.l_divide_id = b.l_stage_id
   and a.l_object_id = c.l_dept_id
   and a.c_object_type = 'BM'
   and a.c_scheme_type = 'QC'
 group by a.c_scheme_code,
          b.c_stage_code,
          c.c_dept_code,
          c.c_dept_name,
          a.l_begdiv_date,
          a.l_effective_date
having count(*) = 2;

create table temp_bm_xm_sxrqcf as 
select a.c_scheme_code,
       b.c_proj_code,
       c.c_dept_code,
       c.c_dept_name,
       a.l_begdiv_date,
       a.l_effective_date,
       max(a.l_scheme_id) as l_max_scheme_id,
       min(a.l_scheme_id) as l_min_scheme_id,
       max(a.l_effective_date) as l_max_effecttive_date,
       min(a.l_effective_date) as l_min_effecttive_date,
       max(a.l_expiration_date) as l_max_expiration_date,
       min(a.l_expiration_date) as l_min_expiration_date
  from dim_pe_divide_scheme a, dim_pb_project_basic b, dim_pb_department c
 where a.l_divide_id = b.l_proj_id
   and a.l_object_id = c.l_dept_id
   and a.c_object_type = 'BM'
   and a.c_scheme_type = 'XM'
 group by a.c_scheme_code,
          b.c_proj_code,
          c.c_dept_code,
          c.c_dept_name,
          a.l_begdiv_date,
          a.l_effective_date
having count(*) = 2;

drop table temp_yg_sxrqcf;
create table temp_yg_sxrqcf as 
select a.c_scheme_code,
       b.c_stage_code,
       c.c_emp_code,
       c.c_emp_name,
       a.l_begdiv_date,
       a.l_effective_date,
       max(a.l_scheme_id) as l_max_scheme_id,
       min(a.l_scheme_id) as l_min_scheme_id,
       max(a.l_effective_date) as l_max_effecttive_date,
       min(a.l_effective_date) as l_min_effecttive_date,
       max(a.l_expiration_date) as l_max_expiration_date,
       min(a.l_expiration_date) as l_min_expiration_date
  from dim_pe_divide_scheme a, dim_sr_stage b, dim_pb_employee c
 where a.l_divide_id = b.l_stage_id
   and a.l_object_id = c.l_emp_id
   and a.c_object_type = 'YG'
   and a.c_scheme_type = 'QC'
 group by a.c_scheme_code,
          b.c_stage_code,
          c.c_emp_code,
          c.c_emp_name,
          a.l_begdiv_date,
          a.l_effective_date
having count(*) = 2;

drop table temp_yg_xm_sxrqcf;
create table temp_yg_xm_sxrqcf as 
select a.c_scheme_code,
       b.c_proj_code,
       c.c_emp_code,
       c.c_emp_name,
       a.l_begdiv_date,
       a.l_effective_date,
       max(a.l_scheme_id) as l_max_scheme_id,
       min(a.l_scheme_id) as l_min_scheme_id,
       max(a.l_effective_date) as l_max_effecttive_date,
       min(a.l_effective_date) as l_min_effecttive_date,
       max(a.l_expiration_date) as l_max_expiration_date,
       min(a.l_expiration_date) as l_min_expiration_date
  from dim_pe_divide_scheme a, dim_pb_project_basic b, dim_pb_employee c
 where a.l_divide_id = b.l_proj_id
   and a.l_object_id = c.l_emp_id
   and a.c_object_type = 'YG'
   and a.c_scheme_type = 'XM'
 group by a.c_scheme_code,
          b.c_proj_code,
          c.c_emp_code,
          c.c_emp_name,
          a.l_begdiv_date,
          a.l_effective_date
having count(*) = 2;

--部门生效日期重复处理
update dim_pe_divide_scheme t
   set t.l_effective_date =
       (select t1.l_min_expiration_date
          from temp_bm_sxrqcf t1
         where t.l_scheme_id = t1.l_max_scheme_id)
 where t.l_scheme_id in (select t2.l_max_scheme_id
                           from temp_bm_sxrqcf t2);

--部门生效日期重复处理
update dim_pe_divide_scheme t
   set t.l_effective_date =
       (select t1.l_min_expiration_date
          from temp_bm_xm_sxrqcf t1
         where t.l_scheme_id = t1.l_max_scheme_id)
 where t.l_scheme_id in (select t2.l_max_scheme_id
                           from temp_bm_xm_sxrqcf t2);

--员工生效日期重复处理
update dim_pe_divide_scheme t
   set t.l_effective_date =
       (select t1.l_min_expiration_date
          from temp_yg_sxrqcf t1
         where t.l_scheme_id = t1.l_max_scheme_id)
 where t.l_scheme_id in (select t2.l_max_scheme_id
                           from temp_yg_sxrqcf t2);

--员工生效日期重复处理
update dim_pe_divide_scheme t
   set t.l_effective_date =
       (select t1.l_min_expiration_date
          from temp_yg_xm_sxrqcf t1
         where t.l_scheme_id = t1.l_max_scheme_id)
 where t.l_scheme_id in (select t2.l_max_scheme_id
                           from temp_yg_xm_sxrqcf t2);
drop table temp_bm_sxrqcf;
drop table temp_bm_xm_sxrqcf;
drop table temp_yg_sxrqcf;
drop table temp_yg_xm_sxrqcf;
