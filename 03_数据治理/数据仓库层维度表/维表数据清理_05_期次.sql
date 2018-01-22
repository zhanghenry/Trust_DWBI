--情况1，生效日期重复
select a.c_stage_code,
       max(a.l_stage_id) as l_max_id,
       min(a.l_stage_id) as l_min_id,
       a.l_effective_date
  from dataedw.dim_sr_stage a
 group by a.c_stage_code, a.l_effective_date
having count(*) > 1;

--情况2，失效日期重复
select a.c_stage_code,
       a.l_expiration_date,
       max(a.l_stage_id) as l_max_id,
       min(a.l_stage_id) as l_min_id
  from dataedw.dim_sr_stage a
 group by a.c_stage_code, a.l_expiration_date
having count(*) > 1;

--情况3：部门生效日期大于失效日期
select *
  from dataedw.dim_sr_stage a
 where a.l_effective_date >= a.l_expiration_date;
 

--情况5：期次生效日期小于项目生效日期或者失效日期大于项目失效日期
select a.l_stage_id,
       a.c_stage_code,
       a.c_stage_name,
       a.l_effective_date,
       a.l_expiration_date,
       a.l_effective_flag,
       a.l_proj_id,
       b.l_effective_date,
       b.l_expiration_date
  from dataedw.dim_sr_stage a, dataedw.dim_pb_project_basic b
 where a.l_proj_id = b.l_proj_id
   and (a.l_effective_date < b.l_effective_date or
       a.l_expiration_date > b.l_expiration_date);
