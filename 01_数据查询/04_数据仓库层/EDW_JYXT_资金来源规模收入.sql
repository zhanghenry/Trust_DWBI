with temp_zjly as 
(select s.c_proj_code,
       s.c_proj_name,
       r.c_proj_type_n,
       r.c_func_type_n,
       decode(d.c_inst_name,'交通银行','是','否') as l_jtyh_flag,
       c.c_fdsrc_name,
       d.c_inst_name,
       round(sum(t.f_scale) / 100000000, 2) as f_scale  
 from tt_tc_scale_flow_d   t,
       dim_tc_contract      b,
       dim_pb_project_basic s,
       dim_pb_project_biz   r, 
       dim_tc_fund_source   c,
       dim_pb_institution   d
 where t.l_cont_id = b.l_cont_id
   and b.l_proj_id = s.l_proj_id
   and s.l_proj_id = r.l_proj_id
   and nvl(b.l_fdsrc_Id, 0) = c.l_fdsrc_id(+)
   and nvl(b.l_fdsrc_inst_id, 0) = d.l_inst_id(+)
   --and r.c_func_type = '3'
   and t.l_change_date <= 20170630
   and s.l_setup_date <= 20170630
 group by s.c_proj_code,s.c_proj_name, r.c_proj_type_n,r.c_func_type_n,c.c_fdsrc_name,d.c_inst_name having sum(t.f_scale) <> 0
 order by s.c_proj_code)
select v.c_proj_code,v.c_Proj_name,v.c_proj_type_N,v.c_func_type_n,v.l_jtyh_flag,case
         when instr(v.c_fdsrc_name, '银行') > 0 then '银行'
         when instr(v.c_fdsrc_name, '保险') > 0 then '保险'
         when instr(v.c_fdsrc_name, '证券') > 0 then '券商'
         when instr(v.c_fdsrc_name, '资管') > 0 then '资管'
         when instr(v.c_fdsrc_name, '基金') > 0 then '基金'
         when instr(v.c_fdsrc_name, '企业自有') > 0 then '企业自有'
         else '其他'
       end as c_type,v.c_fdsrc_name,v.c_inst_name,v.f_scale, sum(v.f_scale) over(partition by v.c_proj_code) as f_total 
from temp_zjly v;
       
with temp_income as
 (select b.c_proj_code,sum(a.f_actual_eot)/10000 as f_income
    from tt_sr_tstrev_proj_m a, dim_pb_project_basic b,dim_pb_project_biz c
   where a.l_proj_id = b.l_proj_id and b.l_proj_id = c.l_proj_id
     and a.l_month_id = 201706 and c.c_func_type = '3'
     and b.l_effective_flag = 1
     --and b.l_setup_date <= 20170630
   group by b.c_proj_code having sum(a.f_actual_tot) <> 0),
temp_scale as (
select v.c_proj_code,
       v.c_fdsrc_name,
       v.f_scale,
       case
         when instr(v.c_fdsrc_name, '银行') > 0 then '银行'
         when instr(v.c_fdsrc_name, '保险') > 0 then '保险'
         when instr(v.c_fdsrc_name, '证券') > 0 then '券商'
         when instr(v.c_fdsrc_name, '企业自有') > 0 then '其他-企业自有'
         when instr(v.c_fdsrc_name, '资管资金(非交银)') > 0 then '其他-资管非交银'
         when instr(v.c_fdsrc_name, '基金') > 0 then '其他-基金'
         else '其他'
       end as c_type,
       sum(v.f_scale) over(partition by v.c_proj_code) as f_total
  from v_temp_zjly_20170630 v
 where  v.l_jtyh_flag = 0 and v.f_scale <> 0)
 select tp1.c_proj_code,tp1.c_fdsrc_name,tp1.c_type,tp1.f_scale,tp1.f_total,decode(tp1.f_total,0,0,tp1.f_scale/tp1.f_total),nvl(tp2.f_income,0) from temp_scale tp1,temp_income tp2 where tp1.c_proj_code = tp2.c_proj_code(+);

