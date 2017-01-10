-----------------------------------------------------------------存续项目----------------------------------------------------------
--存续规模合计
--基于SR主题
select sum(a.f_balance_eot)/100000000 
from tt_sr_scale_proj_m a ,dim_pb_project_biz b ,dim_pb_project_basic c
where a.l_proj_id = b.l_proj_id and b.l_proj_id = c.l_proj_id
and a.l_month_id >= substr(c.l_effective_date,1,6)
and a.l_month_id < substr(c.l_expiration_date, 1,6)
and a.l_month_id = 201606 
and nvl(c.l_expiry_date,'20991231') > 20160630;

--项目规模
select d.c_dept_name,
       e.c_emp_name,
       c.c_proj_code,
       c.c_proj_name,
       c.l_setup_date,
       c.l_expiry_date,
       round(a.f_balance_eot / 100000000, 4) as 规模
  from tt_sr_scale_proj_m   a,
       dim_pb_project_biz   b,
       dim_pb_project_basic c,
       dim_pb_department    d,
       dim_pb_employee      e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and c.l_dept_id = d.l_dept_id
   and c.l_tstmgr_id = e.l_emp_id
   and a.l_month_id >= substr(c.l_effective_date, 1, 6)
   and a.l_month_id < substr(c.l_expiration_date, 1, 6)
   and a.l_month_id = 201608
   and nvl(c.l_expiry_date, '20991231') > 20160831
 order by d.c_dept_name, e.c_emp_name, c.c_proj_code, c.c_proj_name;

--存续规模核对	
select s.c_proj_code,round(sum(t.f_balance_eot)/10000,2) from tt_sr_scale_proj_d t,dim_pb_project_basic s 
where t.l_proj_id = s.l_proj_id and  t.l_day_id = 20161009 group by s.c_proj_code;

--存续项目个数，按项目类型，功能分类，事务性质
select b.c_proj_type,
       b.c_proj_type_n,
       b.c_func_type,
       b.c_func_type_n,
       b.c_affair_props,
       b.c_affair_props_n,
       count(*)
  from tt_sr_scale_proj_d   a,
       dim_pb_project_biz   b,
       dim_sr_project_junk  c,
       dim_pb_project_basic d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_proj_id
   and a.L_PROJ_JUNK_ID = c.L_PROJ_JUNK_ID
   and a.l_day_id = 20160831
   and c.l_exist_flag = 1
 group by b.c_proj_type,
          b.c_proj_type_n,
          b.c_func_type,
          b.c_func_type_n,
          b.c_affair_props,
          b.c_affair_props_n
 order by b.c_proj_type, b.c_func_type, b.c_affair_props;

--存续项目规模，按项目类型，功能分类事务性质
select b.c_proj_type,
       b.c_proj_type_n,
       b.c_func_type,
       b.c_func_type_n,
       b.c_affair_props,
       b.c_affair_props_n,
       sum(a.f_balance_eot) / 100000000
  from tt_sr_scale_proj_m a, dim_pb_project_biz b, dim_pb_project_basic c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_month_id = 201608
   and nvl(c.l_expiry_date, '20991231') > 20160831
   and a.l_month_id >= substr(c.l_effective_date, 1, 6)
   and a.l_month_id < substr(c.l_expiration_date, 1, 6)
 group by b.c_proj_type,
          b.c_proj_type_n,
          b.c_func_type,
          b.c_func_type_n,
          b.c_affair_props,
          b.c_affair_props_n
 order by b.c_proj_type, b.c_func_type, b.c_affair_props;

--项目事物性质明细
select b.l_proj_id,
       b.l_effective_flag,
       b.l_effective_date,
       b.c_proj_code,
       b.c_proj_name,
       b.l_setup_date,
       b.l_expiry_date,
       a.c_proj_type_n,
       a.c_func_type_n,
       a.c_affair_props,
       a.c_affair_props_n
  from dim_pb_project_biz a, dim_pb_project_basic b
 where a.l_Proj_id = b.l_proj_id
   and b.l_effective_flag = 1
 order by b.c_proj_code, a.l_proj_id;

--存续项目资金运用方式明细-行
select c.c_proj_type_n,
       d.c_proj_code,
       d.c_proj_name,
       b.c_scatype_name,
       sum(f_incurred_agg) as f_scale
  from tt_sr_scale_type_m   a,
       dim_sr_scale_type    b,
       dim_pb_project_biz   c,
       dim_pb_project_basic d
 where a.l_proj_id = c.l_proj_id
   and c.l_proj_id = d.l_proj_id
   and a.l_scatype_id = b.l_scatype_id
   and b.c_scatype_class = 'ZJYYFS'
   and nvl(d.l_expiry_date, 20991231) > 20160630
   and a.l_month_id = 201606
 group by c.c_proj_type_n, d.c_proj_code, d.c_proj_name, b.c_scatype_name
having sum(f_incurred_agg) > 0
 order by c.c_proj_type_n, d.c_proj_code, d.c_proj_name, b.c_scatype_name;
 
--存续项目资金运用方式明细-列
select c.c_proj_type_n, d.c_proj_code, d.c_proj_name,
round(sum(decode(b.c_scatype_code,'DK',a.f_incurred_agg,0))/10000,2) as f_dk,
round(sum(decode(b.c_scatype_code,'JYXJRZC',a.f_incurred_agg,0))/10000,2) as f_JYXJRZC,
round(sum(decode(b.c_scatype_code,'KGCS',a.f_incurred_agg,0))/10000,2) as f_KGCS,
round(sum(decode(b.c_scatype_code,'CQGQTZ',a.f_incurred_agg,0))/10000,2) as f_CQGQTZ,
round(sum(decode(b.c_scatype_code,'ZL',a.f_incurred_agg,0))/10000,2) as f_ZL,
round(sum(decode(b.c_scatype_code,'MRFS',a.f_incurred_agg,0))/10000,2) as f_MRFS,
round(sum(decode(b.c_scatype_code,'CC',a.f_incurred_agg,0))/10000,2) as f_CC,
round(sum(decode(b.c_scatype_code,'CFTY',a.f_incurred_agg,0))/10000,2) as f_CFTY,
round(sum(decode(b.c_scatype_code,'QTZJYYFS',a.f_incurred_agg,0))/10000,2) as f_QTZJYYFS
  from tt_sr_scale_type_m   a,
       dim_sr_scale_type    b,
       dim_pb_project_biz   c,
       dim_pb_project_basic d
 where a.l_proj_id = c.l_proj_id
   and c.l_proj_id = d.l_proj_id
   and a.l_scatype_id = b.l_scatype_id
   and b.c_scatype_class = 'ZJYYFS'
   and nvl(d.l_expiry_date, 20991231) > 20160831
   and a.l_month_id = 201608
 group by c.c_proj_type_n, d.c_proj_code, d.c_proj_name
 order by c.c_proj_type_n, d.c_proj_code, d.c_proj_name;
 
--存续项目投向行业明细
select c.c_proj_type_n,
       d.c_proj_code,
       d.c_proj_name,
       b.c_scatype_name,
       sum(f_incurred_agg) as f_scale
  from tt_sr_scale_type_m   a,
       dim_sr_scale_type    b,
       dim_pb_project_biz   c,
       dim_pb_project_basic d
 where a.l_proj_id = c.l_proj_id
   and c.l_proj_id = d.l_proj_id
   and a.l_scatype_id = b.l_scatype_id
   and b.c_scatype_class = 'TXHY'
   and nvl(d.l_expiry_date, 20991231) > 20160630
   and a.l_month_id = 201606
 group by c.c_proj_type_n, d.c_proj_code, d.c_proj_name, b.c_scatype_name
having sum(f_incurred_agg) > 0
 order by c.c_proj_type_n, d.c_proj_code, d.c_proj_name, b.c_scatype_name;

--房地产
select b.c_proj_code,
       b.c_proj_name,
       e.c_invest_indus_n,
       c.c_scatype_name,
       a.f_incurred_agg
  from tt_sr_scale_type_m   a,
       dim_pb_project_basic b,
       dim_sr_scale_type    c,
       dim_pb_project_biz   e
 where a.l_proj_id = b.l_proj_id
   and a.l_scatype_id = c.l_scatype_id
   and c.c_scatype_class = 'TXHY'
   and b.l_proj_id = e.l_proj_id
   and nvl(b.l_expiry_date, 20991231) >= 20160630
   and a.l_month_id = 201606
   and a.f_incurred_agg > 0
   and exists (select 1
          from tt_sr_scale_type_m t
         where a.l_proj_id = t.l_proj_id
           and a.l_month_id = t.l_month_id
           and t.l_scatype_id = 1011
           and t.f_incurred_agg > 0)
 order by b.c_proj_code,
          b.c_proj_name,
          e.c_invest_indus_n,
          a.f_incurred_agg desc;
		  
--部门存续规模
select t4.c_dept_code,
       t4.c_dept_name,
       round(sum(t1.f_scale_agg) / 100000000, 2) as 本年存续规模
  from tt_pe_scale_type_m   t1,
       dim_pb_project_basic t2,
       dim_pb_project_biz   t3,
       dim_pb_department    t4,
       dim_sr_scale_type    t5
 where t1.l_proj_id = t2.l_proj_id
   and t2.l_proj_id = t3.l_proj_id
   and t1.l_object_id = t4.l_dept_id
   and t1.l_scatype_id = t5.l_scatype_id
   and t5.c_scatype_class = 'XTHTGM'
   and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
   and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
   and T1.L_MONTH_ID = 201610
 group by t4.c_dept_code, t4.c_dept_name
 order by t4.c_dept_code;
