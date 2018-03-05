--自定义报告利润简表
--经营指标
select a.c_indic_code,
       a.c_indic_name,
       b.f_indic_actual as 实际值,
       b.f_indic_budget as 预算值,
       b.f_indic_change as 变化值
  from dim_op_indicator a, tt_op_indicator_m b
 where a.l_indic_id = b.l_indic_id
   and b.l_month_id = 201612;

--项目个数
select count(*) as f_value
  from dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and d.l_object_id = e.l_proj_id
   and d.l_month_id = 201612
   and substr(e.l_effective_date, 1, 6) <= d.l_month_id
   and substr(e.l_expiration_date, 1, 6) > d.l_month_id;
   
--创新项目个数
select count(*) as f_value
  from dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e,
       dim_pb_project_biz    f
 where d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and d.l_object_id = e.l_proj_id
   and e.l_proj_id = f.l_proj_id
   and nvl(f.c_special_type,'1') <> '99'
   and d.l_month_id = 201612
   and substr(e.l_effective_date, 1, 6) <= d.l_month_id
   and substr(e.l_expiration_date, 1, 6) > d.l_month_id;

--存续规模
select e.c_proj_code,sum(a.f_balance_agg) as f_value
  from tt_to_operating_book_m a,
       dim_pb_project_biz     b,
       dim_pb_object_status   c,
       tt_pb_object_status_m  d,
       dim_pb_project_basic   e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date, 1, 6) <= a.l_month_id
   and substr(e.l_expiration_date, 1, 6) > a.l_month_id
   group by e.c_proj_code;
   
--时点信托资产
select sum(a.f_balance_agg) as f_value
  from tt_to_accounting_subj_m a, dim_to_subject b
 where a.l_book_id = b.l_book_id
   and a.l_subj_id = b.l_subj_id
   and b.c_subj_type = '1'
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id;
   
--存续项目个数规模，按项目类型
select b.c_proj_type_n,
       count(*),
       sum(a.f_balance_eot)/100000000
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

select b.c_proj_code,/*c.c_proj_type_n, count(*), */sum(a.f_balance_agg) / 100000000
  from tt_to_operating_book_m a,
       dim_pb_project_basic   b,
       dim_pb_project_biz     c,
       dim_pb_object_status   d,
       tt_pb_object_status_m  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
   and e.c_object_type = 'XM'
   and e.l_objstatus_id = d.l_objstatus_id
   and e.l_month_id = a.l_month_id
   and e.l_object_id = a.l_proj_id
   and d.l_exist_tm_flag = 1
   and a.l_month_id = 201612
 group by b.c_proj_code,c.c_proj_type_n
 order by b.c_proj_code,c.c_proj_type_n;
   

--存续项目个数规模，按功能分类
select b.c_func_type_n,
       count(*),
       sum(a.f_balance_eot)/100000000
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

--信托收入
select sum(a.f_actual_eot) as f_value
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201612;

--信托业务收入按业务范围
select c.c_busi_scope_n, round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201612
 group by c.c_busi_scope_n
having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_busi_scope_n;
 
--信托业务收入按业务范围、项目类型、功能分类、事务性质
select c.c_proj_type_n,
       round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201612
 group by c.c_proj_type_n
having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_proj_type_n;
 
--信托业务收入按业务范围、项目类型、功能分类、事务性质
select c.c_func_type_n,
       round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201612
 group by  c.c_func_type_n
having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_func_type_n;

--项目资产余额
select d.c_proj_code,sum(a.f_balance_agg)
  from tt_to_accounting_subj_m a, dim_to_subject b, dim_pb_project_basic d
 where a.l_subj_id = b.l_subj_id
   and a.l_book_id = b.l_book_id
   and a.l_proj_id = d.l_proj_id
   and substr(d.l_effective_date, 1, 6) <= a.l_month_id
   and substr(d.l_expiration_date, 1, 6) > a.l_month_id
   and b.c_subj_type = '1'
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
   group by d.c_proj_code order by d.c_proj_code;

--估值资金投向行业
select d.c_proj_code,sum(decode(b.c_invest_indus, 'HYTX_JCCY', a.f_balance_agg, 0))/100000000 as 基础产业,
       sum(decode(b.c_invest_indus, 'HYTX_FDC', a.f_balance_agg, 0))/100000000 as 房地产,
       sum(decode(b.c_invest_indus, 'HYTX_ZQ', a.f_balance_agg, 0))/100000000 as 证券,
       sum(decode(b.c_invest_indus, 'HYTX_JRJG', a.f_balance_agg, 0))/100000000 as 金融机构,
       sum(decode(b.c_invest_indus, 'HYTX_GSQY', a.f_balance_agg, 0))/100000000 as 工商企业,
       sum(decode(b.c_invest_indus, 'HYTX_QT', a.f_balance_agg, 0))/100000000 as 其他
  from tt_to_accounting_subj_m a, dim_to_subject b, dim_pb_project_basic d
 where a.l_subj_id = b.l_subj_id
   and a.l_book_id = b.l_book_id
   and a.l_proj_id = d.l_proj_id
   and substr(d.l_effective_date, 1, 6) <= a.l_month_id
   and substr(d.l_expiration_date, 1, 6) > a.l_month_id
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
   group by d.c_proj_code order by d.c_proj_code;

select t.l_effective_flag,count(*) from dim_to_subject t group by t.l_effective_flag;

--估值资金运用方式
select sum(decode(b.c_fduse_way, 'YYFS_DK', a.f_balance_agg, 0))/100000000 as 贷款,
       sum(decode(b.c_fduse_way, 'YYFS_JYXJRZC', a.f_balance_agg, 0))/100000000 as 交易性金融资产,
       sum(decode(b.c_fduse_way, 'YYFS_KGCSJCYZDQ', a.f_balance_agg, 0))/100000000 as 可供出售及持有至到期,
       sum(decode(b.c_fduse_way, 'YYFS_GQTZ', a.f_balance_agg, 0))/100000000 as 股权投资,
       sum(decode(b.c_fduse_way, 'YYFS_ZL', a.f_balance_agg, 0))/100000000 as 租赁,
       sum(decode(b.c_fduse_way, 'YYFS_MRFS', a.f_balance_agg, 0))/100000000 as 买入返售,
       sum(decode(b.c_fduse_way, 'YYFS_CC', a.f_balance_agg, 0))/100000000 as 拆出,
       sum(decode(b.c_fduse_way, 'YYFS_CFTY', a.f_balance_agg, 0))/100000000 as 存放同业,
       sum(decode(b.c_fduse_way, 'YYFS_QT', a.f_balance_agg, 0))/100000000 as 其他
  from tt_to_accounting_subj_m a, dim_to_subject b, dim_pb_project_basic d
 where a.l_subj_id = b.l_subj_id
   and a.l_book_id = b.l_book_id
   and a.l_proj_id = d.l_proj_id
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
   and a.l_month_id = 201612
   and substr(d.l_effective_date, 1, 6) <= a.l_month_id
   and substr(d.l_expiration_date, 1, 6) > a.l_month_id;

--新增个数规模
select count(*),
       sum(a.f_increase_eot)/100000000
  from tt_sr_scale_proj_m    a,
       dim_pb_project_biz    b,
       dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and c.l_setup_ty_flag = 1
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date,1,6) <= a.l_month_id
   and substr(e.l_expiration_date,1,6)>a.l_month_id;  
   
--新增项目个数规模，按项目类型
select b.c_proj_type_n,
       count(*),
       sum(a.f_increase_eot)/100000000
  from tt_sr_scale_proj_m    a,
       dim_pb_project_biz    b,
       dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and c.l_setup_ty_flag = 1
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date,1,6) <= a.l_month_id
   and substr(e.l_expiration_date,1,6)>a.l_month_id
 group by b.c_proj_type_n
 order by b.c_proj_type_n;

--新增项目个数规模，按功能分类
select b.c_func_type_n,
       count(*),
       sum(a.f_increase_eot)/100000000
  from tt_sr_scale_proj_m    a,
       dim_pb_project_biz    b,
       dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and c.l_setup_ty_flag = 1
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date,1,6) <= a.l_month_id
   and substr(e.l_expiration_date,1,6)>a.l_month_id
 group by b.c_func_type_n
 order by b.c_func_type_n;
 
--新增信托业务收入按业务范围
select c.c_busi_scope_n,
       round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m  a,
       dim_pb_project_basic b,
       dim_pb_project_biz   c,
       dim_pb_ie_status     d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_revstatus_id = d.l_iestatus_id
   and d.c_iestatus_code = 'NEW'
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201612
 group by c.c_busi_scope_n
having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_busi_scope_n;
 
--新增信托业务收入按项目类型
select c.c_proj_type_n,
	   round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m  a,
       dim_pb_project_basic b,
       dim_pb_project_biz   c,
       dim_pb_ie_status     d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_revstatus_id = d.l_iestatus_id
   and d.c_iestatus_code = 'NEW'
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201612
 group by c.c_proj_type_n
having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_proj_type_n;
 
--新增信托业务收入按功能分类
select c.c_func_type_n,
       round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m  a,
       dim_pb_project_basic b,
       dim_pb_project_biz   c,
       dim_pb_ie_status     d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_revstatus_id = d.l_iestatus_id
   and d.c_iestatus_code = 'NEW'
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201612
 group by c.c_func_type_n
having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_func_type_n;

--清算项目个数规模，按项目类型
select b.c_proj_type_n,
       count(*),
       sum(a.f_decrease_eot)/100000000
  from tt_sr_scale_proj_m    a,
       dim_pb_project_biz    b,
       dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and c.l_expiry_ty_flag = 1
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date,1,6) <= a.l_month_id
   and substr(e.l_expiration_date,1,6)>a.l_month_id
 group by b.c_proj_type_n
 order by b.c_proj_type_n;

--清算项目个数规模，按功能分类
select b.c_func_type_n,
       count(*),
       sum(a.f_decrease_eot)/100000000
  from tt_sr_scale_proj_m    a,
       dim_pb_project_biz    b,
       dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and c.l_expiry_ty_flag = 1
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date,1,6) <= a.l_month_id
   and substr(e.l_expiration_date,1,6)>a.l_month_id
 group by b.c_func_type_n
 order by b.c_func_type_n; 
 
--创新项目个数规模
select b.c_special_type_n,
       count(*),
       sum(a.f_balance_eot)/100000000
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
   and nvl(b.c_special_type_n,'其他) <> '其他
 group by b.c_special_type_n
 order by b.c_special_type_n;

--本年员工变动人数
select b.c_chgtype_name, sum(a.f_count_eot)
  from tt_hr_change_type_m a, dim_hr_change_type b
 where a.l_chgtype_id = b.l_chgtype_id
   and a.l_month_id = 201612
 group by b.c_chgtype_name
having sum(a.f_count_eot) <> 0;

--自定义报告固定费用执行情况
--长安在用
select a.c_item_code, a.c_item_name, c.f_value1 as 实际, c.f_value2 as 预计
  from dim_op_report_item a, dim_op_report b, tt_op_report_m c
 where a.l_report_id = b.l_report_id
   and a.l_item_id = c.l_item_id
   and b.c_report_code = 'GDFYZXQK'
   and c.l_month_id = 201612;


--客户，个人机构
--当前
select a.c_cust_type_n, count(*)
  from dim_ca_customer a
 where a.l_effective_flag = 1
 group by a.c_cust_type_n;


--客户，潜在事实
select a.c_cust_cate_n, count(*)
  from dim_ca_customer a
 where a.l_effective_flag = 1
 group by a.c_cust_cate_n;

 
--客户，会员非会员
select a.l_mbr_flag, count(*)
  from dim_ca_customer a
 where a.l_effective_flag = 1
 group by a.l_mbr_flag;
--时点
select c.l_mbr_flag, sum(a.f_count_agg)
  from tt_ca_count_cust_m a, dim_ca_behavior b, dim_ca_customer c
 where a.l_beha_id = b.l_beha_id
   and a.l_cust_id = c.l_cust_id
   and b.c_beha_code = 'KH_XX_SS_CJ'
   and a.l_month_id = 201612
 group by c.l_mbr_flag;
 
--客户，网上信托
select a.l_online_flag, count(*)
  from dim_ca_customer a
 where a.l_effective_flag = 1
 group by a.l_online_flag;
--时点
select c.l_online_flag, sum(a.f_count_agg)
  from tt_ca_count_cust_m a, dim_ca_behavior b, dim_ca_customer c
 where a.l_beha_id = b.l_beha_id
   and a.l_cust_id = c.l_cust_id
   and b.c_beha_code = 'KH_XX_SS_CJ'
   and a.l_month_id = 201612
 group by c.l_online_flag;

--客户经理申购/赎回
select c.c_broker_name, d.c_beha_name, sum(a.f_share_eot)
  from tt_ca_share_cust_m a,
       dim_ca_broker_cust b,
       dim_ca_broker      c,
       dim_ca_behavior    d
 where a.l_cust_id = b.l_cust_id
   and b.l_broker_id = c.l_broker_id
   and b.l_primary_flag = 1
   and a.l_beha_id = d.l_beha_id
   and a.l_month_id = 201612
   and d.c_beha_code in ('KH_JY_RG','KH_JY_SG','KH_JY_SH')
 group by c.c_broker_name, d.c_beha_name
 order by c.c_broker_name, d.c_beha_name;
 
--部门申购/赎回
select e.c_team_name, d.c_beha_name, sum(a.f_share_eot)
  from tt_ca_share_cust_m a,
       dim_ca_broker_cust b,
       dim_ca_broker      c,
       dim_ca_behavior    d,
       dim_ca_broker_team e
 where a.l_cust_id = b.l_cust_id
   and b.l_broker_id = c.l_broker_id
   and b.l_primary_flag = 1
   and a.l_beha_id = d.l_beha_id
   and c.l_team_id = e.l_team_id
   and a.l_month_id = 201612
   and d.c_beha_code in ('KH_JY_RG','KH_JY_SG','KH_JY_SH')
 group by e.c_team_name, d.c_beha_name
 order by e.c_team_name, d.c_beha_name;

--客户持仓
select c.c_cust_cate_n, sum(a.f_share_agg)/100000000
  from tt_ca_share_cust_m a, dim_ca_behavior b, dim_ca_customer c
 where a.l_beha_id = b.l_beha_id
   and a.l_cust_id = c.l_cust_id
   and b.c_beha_code = 'KH_JY_CC'
   and a.l_month_id = 201612
 group by c.c_cust_cate_n;

--客户持仓--机构个人
select c.c_cust_type_n, sum(a.f_share_agg)/100000000
  from tt_ca_share_cust_m a, dim_ca_behavior b, dim_ca_customer c
 where a.l_beha_id = b.l_beha_id
   and a.l_cust_id = c.l_cust_id
   and b.c_beha_code = 'KH_JY_CC'
   and a.l_month_id = 201612
 group by c.c_cust_type_n;
 
--客户持仓--会员
select c.l_Mbr_Flag, sum(a.f_share_agg)/100000000
  from tt_ca_share_cust_m a, dim_ca_behavior b, dim_ca_customer c
 where a.l_beha_id = b.l_beha_id
   and a.l_cust_id = c.l_cust_id
   and b.c_beha_code = 'KH_JY_CC'
   and a.l_month_id = 201612
 group by c.l_Mbr_Flag;

select * from dim_ca_behavior;

select *from tt_ca_share_cust_m t where t.l_beha_id = 6 and t.l_month_id = 201612;

--个人客户所属区域
select c.c_prov_name,count(*)
  from dim_ca_customer a, dim_pb_individual b, dim_pb_area c
 where a.l_unique_id = b.l_indiv_id
   and b.l_native_area = c.l_area_id(+)
   and a.c_cust_type = '1'
   and a.l_effective_flag = 1
   group by c.c_prov_name;

select count(*) from dim_pb_individual t where t.l_native_area is not null and t.l_effective_flag = 1 and t.l_native_area <> 0;

--机构客户所属区域
select c.c_prov_name, count(*)
  from dim_ca_customer a, dim_pb_organization b, dim_pb_area c
 where a.l_unique_id = b.l_organ_id
   and b.l_area_id = c.l_area_id(+)
   and a.c_cust_type = '0'
   and a.l_effective_flag = 1
 group by c.c_prov_name;

select * from dim_ca_behavior;
select * from dim_ca_customer t where t.c_risk_degree is not null;

--TA规模
select sum(a.f_balance_agg)
  from tt_tc_scale_cont_m   a,
       dim_tc_contract      d,
       dim_pb_project_basic b,
       dim_pb_project_biz   c
 where a.l_proj_id = b.l_proj_id
   and a.l_cont_id = d.l_cont_id
   and b.l_proj_id = c.l_proj_id
   and substr(d.l_effective_date, 1, 6) <= a.l_month_id
   and substr(d.l_expiration_date, 1, 6) > a.l_month_id
   and a.l_month_id = 201612;

--AM信托收入
select sum(a.f_actual_eot) as f_value
  from tt_ic_ie_prod_m a, dim_pb_ie_type b, dim_pb_product c
 where a.l_ietype_id = b.l_ietype_id
   and a.l_prod_id = c.l_prod_id
   and b.c_ietype_code_l1 = 'XTSR'
   and substr(c.l_effective_date, 1, 6) <= a.l_month_id
   and substr(c.l_expiration_date, 1, 6) > a.l_month_id
   and a.l_month_id = 201612;


--存续资产
select d.c_book_code, sum(a.f_balance_agg) as f_value
  from tt_to_accounting_subj_m a, dim_to_subject b, dim_pb_project_basic c,dim_to_book d
 where a.l_subj_id = b.l_subj_id
   and a.l_proj_id = c.l_proj_id
   and b.c_subj_type = '1'
   and a.l_month_id = 201612
   and a.l_book_id = d.l_book_id
   and substr(c.l_effective_date, 1, 6) <= 201612
   and substr(c.l_expiration_date, 1, 6) > 201612
   and substr(b.l_effective_date, 1, 6) <= 201612
   and substr(b.l_expiration_date, 1, 6) > 201612
--and c.l_proj_id = 1853
 group by d.c_book_code
having sum(a.f_balance_agg) <> 0
 order by d.c_book_code;
