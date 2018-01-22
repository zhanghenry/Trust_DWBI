--情况1，生效日期重复
select a.c_cont_code,
       a.l_effective_date,
       max(a.l_cont_id) as l_max_id,
       min(a.l_cont_id) as l_min_id
  from dim_ic_contract a
 group by a.c_cont_code, a.l_effective_date
having count(*) > 1;

--情况2，失效日期重复
select a.c_cont_code,
       a.l_expiration_date,
       max(a.l_cont_id) as l_max_id,
       min(a.l_cont_id) as l_min_id
  from dim_ic_contract a
 group by a.c_cont_code, a.l_expiration_date
having count(*) > 1;

--情况3：部门生效日期大于失效日期
select *
  from dataedw.dim_ic_contract a
 where a.l_effective_date >= a.l_expiration_date;

--情况5：产品生效日期小于项目生效日期或者失效日期大于项目失效日期
select a.l_cont_id,
       a.c_cont_code,
       a.c_cont_name,
       a.l_effective_date,
       a.l_expiration_date,
       a.l_effective_flag,
       a.l_proj_id,
       b.l_effective_date,
       b.l_expiration_date
  from dataedw.dim_ic_contract a, dataedw.dim_pb_project_basic b
 where a.l_proj_id = b.l_proj_id
   and (a.l_effective_date < b.l_effective_date or
       a.l_expiration_date > b.l_expiration_date);

--清理重复记录
truncate table ttemp_invest_contract_0723;
drop table ttemp_invest_contract_0723;

create table ttemp_invest_contract_0723 as
select max(t.l_cont_id) as l_max_cont_id,min(t.l_cont_id) as l_min_cont_id,t.c_cont_code, t.l_effective_date
  from dim_ic_contract t --where (t.c_cont_code like 'CWTZ%' or t.c_cont_code like 'DK%')
 group by t.c_cont_code, t.l_effective_date
having count(*) = 2;

update dim_ic_contract t set t.l_expiration_date = 20991231,t.l_effective_flag = 1 where t.l_cont_id in (select s.l_min_cont_id from ttemp_invest_contract_0723 s);
delete from dim_ic_contract t where t.l_cont_id in (select s.l_max_cont_id from ttemp_invest_contract_0723 s);
delete from tt_ic_invest_cont_d t where t.l_cont_id in (select s.l_max_cont_id from ttemp_invest_contract_0723 s);
delete from tt_ic_invest_cont_m t where  t.l_cont_id in (select s.l_max_cont_id from ttemp_invest_contract_0723 s);

--清理失效日期重复的记录
create table ttemp_invest_contract_20991231 as
select a.c_cont_code,max(a.l_cont_id) as l_max_cont_id,min(a.l_cont_id) as l_min_cont_id
  from dim_ic_contract a
 where a.l_expiration_date = 20991231
 group by a.c_cont_code
having count(*) > 1;

delete from dim_ic_contract t where t.l_cont_id in (select t1.l_min_cont_id from ttemp_invest_contract_20991231 t1);
delete from tt_ic_invest_cont_d t where t.l_cont_id in (select t1.l_min_cont_id from ttemp_invest_contract_20991231 t1);
delete from tt_ic_invest_cont_m t where t.l_cont_id in (select t1.l_min_cont_id from ttemp_invest_contract_20991231 t1);

--清楚生效阶段重叠的
create table ttemp_invest_contract_conflict as 
select a.l_cont_id         as l_new_cont_id,
       a.c_cont_code,
       a.l_effective_date  as l_new_effective_date,
       a.l_expiration_date as l_new_expiration_date,
       b.l_cont_id         as l_old_cont_id,
       b.l_effective_date  as l_old_effective_date,
       b.l_expiration_date as l_old_expiration_date
  from dim_ic_contract a, dim_ic_contract b
 where a.c_cont_code = b.c_cont_code
   and a.l_effective_date < b.l_expiration_date
   and a.l_effective_flag = 1
   and b.l_effective_flag = 0;

delete from dim_ic_contract t where t.l_cont_id in (select t1.l_old_cont_id from ttemp_invest_contract_conflict t1);
delete from tt_ic_invest_cont_d t where t.l_cont_id in (select t1.l_old_cont_id from ttemp_invest_contract_conflict t1);
delete from tt_ic_invest_cont_m t where t.l_cont_id in (select t1.l_old_cont_id from ttemp_invest_contract_conflict t1);
