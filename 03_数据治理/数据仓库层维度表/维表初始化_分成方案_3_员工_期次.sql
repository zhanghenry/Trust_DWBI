--删除临时表
drop table temp_fcfacsh_yg_qc_01;
drop table temp_fcfacsh_yg_qc_02;
drop table temp_fcfacsh_yg_qc_03;
drop table temp_fcfacsh_yg_qc_04;

--员工期次分成初始化
--step1
--Dock层分成方案表与EDW层期次维度表关联
create table temp_fcfacsh_yg_qc_01 as 
select 0 as l_scheme_id,
       a.c_scheme_code,
       b.l_proj_id,
       a.c_scheme_type,
       a.c_scheme_type_n,
       b.l_stage_id as l_divide_id,
       a.c_divide_way,
       a.c_divide_way_n,
       a.c_object_type,
       a.c_object_type_n,
       a.c_object_code,
       a.c_object_name,
       a.f_divide_rate,
       to_number(to_char(a.d_effective, 'yyyymmdd')) l_begdiv_date,
       nvl(to_number(to_char(a.d_expiration, 'yyyymmdd')), 20991231) l_enddiv_date,
       to_number(to_char(a.d_effective, 'yyyymm')) l_begdiv_month,
       nvl(to_number(to_char(a.d_effective, 'yyyymm')), 209912) l_enddiv_month,
       b.l_effective_date as l_effective_date,
       b.l_expiration_date,
       b.l_effective_flag
  from datadock.tde_divide_scheme a,
       dataedw.dim_sr_stage       b
 where a.c_divide_code = b.c_stage_code
   and a.c_scheme_type = 'QC'
   and a.c_object_type = 'YG'
/*   and a.c_divide_code = 'G512-1'
   and a.c_object_name like '%尹卓%'*/;
   
--step2
--EDW层员工表由于生效和失效日期存在特殊性，需要特别处理
create table temp_fcfacsh_yg_qc_02 as 
with temp_yg as
 (select t.c_emp_code,
         max(t.l_emp_id) as l_max_id,
         min(t.l_emp_id) as l_min_id,
         max(t.l_effective_date) as l_max_effective_date,
         min(t.l_effective_date) as l_min_effective_date,
         max(t.l_expiration_date) as l_max_expiration_date,
         min(t.l_expiration_date) as l_min_expiration_date
    from dataedw.dim_pb_employee t
  /* where t.c_emp_name = '尹卓'*/
   group by t.c_emp_code)
select a.l_emp_id,
       a.c_emp_code,
       a.c_emp_name,
       case
         when a.l_emp_id = b.l_min_id then
          20100101
         else
          a.l_effective_date
       end as l_effective_date,
       case
         when a.l_emp_id = b.l_max_id then
          20991231
         else
          a.l_expiration_date
       end as l_expiration_date,
       a.l_effective_flag
  from dataedw.dim_pb_employee a, temp_yg b
 where a.c_emp_code = b.c_emp_code;

--step3
--将上一步的结果与EDW层的部门维度表关联
create table  temp_fcfacsh_yg_qc_03 as 
select t.* from (
  select  '3'||lpad(row_number()over(order by a.c_scheme_code,greatest(a.l_effective_date,b.l_effective_date)),5,0) as l_scheme_id,
         a.c_scheme_code,
         a.l_proj_id,
         a.c_scheme_type,
         a.c_scheme_type_n,
         a.l_divide_id,
         a.c_divide_way,
         a.c_divide_way_n,
         a.c_object_type,
         a.c_object_type_n,
         b.l_emp_id         as l_object_id,
         a.c_object_name,
         a.f_divide_rate,
         a.l_begdiv_date,
         a.l_enddiv_date,
         a.l_begdiv_month,
         a.l_enddiv_month,
         greatest(a.l_effective_date,b.l_effective_date) as l_effective_date,
         least(a.l_expiration_date,b.l_expiration_date) as l_expiration_date,
         case when b.l_expiration_date < a.l_expiration_date then b.l_effective_flag else  a.l_effective_flag  end as l_effective_flag,
         20180118            as l_data_date
    from temp_fcfacsh_yg_qc_01 a, temp_fcfacsh_yg_qc_02 b
   where a.c_object_code = b.c_emp_code
     and b.l_expiration_date > a.l_effective_date
     and b.l_effective_date < a.l_expiration_date) t;

create table temp_fcfacsh_yg_qc_04 as
select t.c_scheme_code,
       max(t.l_scheme_id) as l_max_id,
       min(t.l_scheme_id) as l_min_id,
       max(t.l_effective_date) as l_max_effective_date,
       min(t.l_effective_date) as l_min_effective_date,
       max(t.l_expiration_date) as l_max_expiration_date,
       min(t.l_expiration_date) as l_min_expiration_date
  from temp_fcfacsh_yg_qc_03 t
 group by t.c_scheme_code;
  
update temp_fcfacsh_yg_qc_03 t
   set t.l_effective_date = t.l_begdiv_date
 where t.l_scheme_id in (select t1.l_min_id from temp_fcfacsh_yg_qc_04 t1);

commit;

select * from temp_fcfacsh_yg_qc_03 t where t.c_object_name = '尹卓' and t.l_divide_id in (207,1720);
select * from dataedw.dim_pb_employee t where t.c_emp_name = '尹卓';
select * from dataedw.dim_sr_stage t where/* t.l_stage_id = 1028 */t.c_stage_code = 'G598-1';
