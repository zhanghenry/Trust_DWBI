-----------------------------------------------------------------存续项目----------------------------------------------------------
--存续规模
select round(sum(t.f_balance_eot) / 10000, 2)
  from tt_sr_scale_proj_m t, dim_pb_project_basic s
 where t.l_proj_id = s.l_proj_id
   and substr(s.l_effective_date, 1, 6) <= t.l_month_id
   and substr(s.l_expiration_date, 1, 6) > t.l_month_id
   and t.l_month_id = 201612;   
   
--存续项目规模
select sum(a.f_balance_eot) / 100000000
  from tt_sr_scale_proj_m a, dim_pb_project_biz b, dim_pb_project_basic c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_month_id >= substr(c.l_effective_date, 1, 6)
   and a.l_month_id < substr(c.l_expiration_date, 1, 6)
   and a.l_month_id = 201612
   and nvl(c.l_expiry_date, '20991231') > 20161231;
    
--存续项目个数/规模，按项目类型
select b.c_proj_type_n,
       count(*),
       sum(a.f_balance_eot)
  from tt_sr_scale_proj_m    a,
       dim_pb_project_biz    b,
       dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and c.l_exist_tm_flag = 1
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date,1,6) <= a.l_month_id
   and substr(e.l_expiration_date,1,6)>a.l_month_id
 group by b.c_proj_type_n
 order by b.c_proj_type_n;

--存续项目个数/规模，按功能分类
select b.c_func_type_n,
       count(*),
       sum(a.f_balance_eot)
  from tt_sr_scale_proj_m    a,
       dim_pb_project_biz    b,
       dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and c.l_exist_tm_flag = 1
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date,1,6) <= a.l_month_id
   and substr(e.l_expiration_date,1,6)>a.l_month_id
 group by b.c_func_type_n
 order by b.c_func_type_n;

 
 
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

--部门项目规模
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
        round(sum(decode(b.c_scatype_code,'JCCY',a.f_incurred_agg,0))/10000,2) as f_jccy,
        round(sum(decode(b.c_scatype_code,'FDC',a.f_incurred_agg,0))/10000,2) as f_fdc,
        round(sum(decode(b.c_scatype_code,'ZQ',a.f_incurred_agg,0))/10000,2) as f_zq,
        round(sum(decode(b.c_scatype_code,'JRJG',a.f_incurred_agg,0))/10000,2) as f_jrjg,
        round(sum(decode(b.c_scatype_code,'GSQY',a.f_incurred_agg,0))/10000,2) as f_gsqy,
        round(sum(decode(b.c_scatype_code,'QTTXHY',a.f_incurred_agg,0))/10000,2) as f_qt  
  from tt_sr_scale_type_m   a,
       dim_sr_scale_type    b,
       dim_pb_project_biz   c,
       dim_pb_project_basic d
 where a.l_proj_id = c.l_proj_id
   and c.l_proj_id = d.l_proj_id
   and a.l_scatype_id = b.l_scatype_id
   and b.c_scatype_class = 'TXHY'
   and nvl(d.l_expiry_date, 20991231) > 20170731
   and a.l_month_id = 201707
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
