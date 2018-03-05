--情况1，生效日期重复
select a.c_prod_code,
       max(a.l_prod_id) as l_max_id,
       min(a.l_prod_id) as l_min_id,
       a.l_effective_date
  from dataedw.dim_pb_product a
 group by a.c_prod_code, a.l_effective_date
having count(*) > 1;

create  table dim_pb_product_20180223 as select * from dim_pb_product;

truncate table temp_prod_repeat_20180223;
drop table temp_prod_repeat_20180223;

create table temp_prod_repeat_20180223 as 
select t.c_prod_code,
       t.l_effective_date,
       min(t.l_prod_id) as l_min_prod_id,
       max(t.l_prod_id) as l_max_prod_id,
       min(t.l_expiration_date) as l_min_expiration_id,
       max(t.l_expiration_date) as l_max_expiration_id
  from dim_pb_product t
 group by t.c_prod_code, t.l_effective_date
having count(*) = 2;

update dim_pb_product t
   set t.l_effective_date =
       (select t1.l_min_expiration_id
          from temp_prod_repeat_20180223 t1
         where t.l_prod_id = t1.l_max_prod_id)
 where t.l_prod_id in
       (select t2.l_max_prod_id from temp_prod_repeat_20180223 t2);

--情况2，失效日期重复
select a.c_prod_code,
       a.l_expiration_date,
       max(a.l_prod_id) as l_max_id,
       min(a.l_prod_id) as l_min_id
  from dataedw.dim_pb_product a
 group by a.c_prod_code, a.l_expiration_date
having count(*) > 1;

--情况3：产品生效日期大于失效日期
select *
  from dataedw.dim_pb_product a
 where a.l_effective_date >= a.l_expiration_date;

--情况5：产品生效日期小于项目生效日期或者失效日期大于项目失效日期
select a.l_prod_id,
       a.c_prod_code,
       a.c_prod_name,
       a.l_effective_date,
       a.l_expiration_date,
       a.l_effective_flag,
       a.l_proj_id,
       b.l_effective_date,
       b.l_expiration_date
  from dataedw.dim_pb_product a, dataedw.dim_pb_project_basic b
 where a.l_proj_id = b.l_proj_id
   and (a.l_effective_date < b.l_effective_date or
       a.l_expiration_date > b.l_expiration_date);
       
--情况6：产品生效日期虽然不重复，但实际上未触发缓慢变化维
truncate table temp_prod_repeat_20180223;
drop table temp_prod_repeat_20180223;
create table temp_prod_repeat_20180223 as 
with temp_effective as
 (select a.c_prod_code, a.l_prod_id, a.l_effective_date, a.l_expiration_date
    from dim_pb_product a
   where a.l_effective_flag = 1),
temp_uneffective as
 (select a.c_prod_code,
         max(a.l_prod_id) as l_prod_id,
         max(a.l_effective_date) as l_effective_date,
         max(a.l_expiration_date) as l_expiration_date
    from dim_pb_product a
   where a.l_effective_flag = 0
   group by a.c_prod_code)
select tp1.l_prod_id,tp2.l_expiration_date
  from temp_effective tp1, temp_uneffective tp2
 where tp1.c_prod_code = tp2.c_prod_code
   and tp1.l_effective_date < tp2.l_expiration_date;
   
update dim_pb_product t
   set t.l_effective_date = (select t1.l_expiration_date
                               from temp_prod_repeat_20180223 t1
                              where t.l_prod_id = t1.l_prod_id)
where t.l_prod_id in (select t2.l_prod_id from temp_prod_repeat_20180223 t2);
