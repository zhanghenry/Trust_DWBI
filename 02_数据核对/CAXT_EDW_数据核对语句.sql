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

--存续规模
select count(*),
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
   and substr(e.l_expiration_date,1,6)>a.l_month_id;  
   
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

--估值资金投向行业
select sum(decode(b.c_invest_indus, 'HYTX_JCCY', a.f_balance_agg, 0))/100000000 as 基础产业,
       sum(decode(b.c_invest_indus, 'HYTX_FDC', a.f_balance_agg, 0))/100000000 as 房地产,
       sum(decode(b.c_invest_indus, 'HYTX_ZQ', a.f_balance_agg, 0))/100000000 as 证券,
       sum(decode(b.c_invest_indus, 'HYTX_JRJG', a.f_balance_agg, 0))/100000000 as 金融机构,
       sum(decode(b.c_invest_indus, 'HYTX_GSQY', a.f_balance_agg, 0))/100000000 as 工商企业,
       sum(decode(b.c_invest_indus, 'HYTX_QT', a.f_balance_agg, 0))/100000000 as 其他
  from tt_to_accounting_subj_m a, dim_to_subject b, dim_pb_project_basic d
 where a.l_subj_id = b.l_subj_id
   and a.l_book_id = b.l_book_id
   and a.l_proj_id = d.l_proj_id
   and d.l_effective_flag = 1
   and a.l_month_id = 201612
   and substr(d.l_effective_date, 1, 6) <= a.l_month_id
   and substr(d.l_expiration_date, 1, 6) > a.l_month_id;

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
   and d.l_effective_flag = 1
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