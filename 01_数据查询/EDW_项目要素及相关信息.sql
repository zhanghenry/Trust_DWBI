--项目关键要素
select b.c_proj_code, --项目编码
       b.c_proj_name, --项目名称
       b.l_setup_date, --成立日期
       b.l_expiry_date, --终止日期
       a.c_proj_type, --项目类型
       a.c_proj_type_n, --项目类型说明
       a.c_func_type, --功能分类
       a.c_func_type_n, --功能分类说明
       a.c_affair_props, --事务性质
       a.c_affair_props_n, --事务性质说明
       c.c_inst_name --推荐分行
  from dim_pb_project_biz a, dim_pb_project_basic b, dim_pb_institution c
 where a.l_Proj_id = b.l_proj_id
   and a.l_bankrec_sub = c.l_inst_id(+)
   and b.l_effective_flag = 1
   and nvl(b.l_expiry_date, '20991231') > 20151231
 order by b.c_proj_code, a.l_proj_id;

--项目推荐分行
select c.c_proj_code, c.c_proj_name, b.c_inst_name
  from dim_pb_project_basic c, dim_pb_project_biz a, dim_pb_institution b
 where a.l_proj_id = c.l_proj_id
   and a.l_bankrec_sub = l_inst_Id
   and nvl(C.L_EXPIRY_DATE, '20991231') < 20160601
   and a.l_effective_flag = 1;

--查看具体项目的存续规模对应的委托人
select c.c_cust_name, b.l_proj_id, c.c_cust_tytpe_n, sum(a.f_scale)
  from tt_tc_scale_flow_d   a,
       dim_tc_contract      b,
       dim_ca_customer      c,
       dim_pb_project_basic d
 where a.l_cont_id = b.l_cont_id
   and b.l_settler_id = c.l_cust_id
   and b.l_proj_id = d.l_proj_Id
   and d.l_effective_flag = 1
   and d.c_proj_name like '%稳健1167号%'
 group by c.c_cust_name, b.l_proj_id, c.c_cust_tytpe_n
having sum(a.f_scale) <> 0
 order by c.c_cust_tytpe_n;
 
--存续项目个数
select b.c_proj_type_n, count(*)
  from dim_pb_project_basic a, dim_pb_project_biz b
 where a.l_effective_flag = 1
   and a.l_proj_id = b.l_proj_id
   and a.c_proj_phase >= '35'
   and nvl(a.l_expiry_date, 20991231) > 20160930
   and a.l_setup_date <= 20160930
 group by b.c_proj_type_n;
 
select t.c_object_code
  from tt_pb_object_status_m t, dim_pb_object_status s
 where t.l_month_id = 201609
   and t.l_objstatus_id = s.l_objstatus_id and t.c_object_type = 'XM'
   and s.l_exist_tm_flag = 1;

--存续项目规模
select c.c_proj_type_n, round(sum(a.f_balance_agg) / 100000000, 2)
  from tt_tc_scale_cont_m   a,
       dim_tc_contract      d,
       dim_pb_project_basic b,
       dim_pb_project_biz   c
 where a.l_proj_id = b.l_proj_id
   and a.l_cont_id = d.l_cont_id
   and b.l_proj_id = c.l_proj_id
   /*and substr(d.l_effective_date, 1, 6) <= 201609
   and substr(d.l_expiration_date, 1, 6) > 201609*/
      --and nvl(b.l_expiry_date, 20991231) > 20160930
   and a.l_month_id = 201609
 group by c.c_proj_type_n;

--类资金池项目
select c.c_dept_name,a.l_proj_id,a.c_proj_code,a.c_proj_name
  from dim_pb_project_basic a, dim_pb_project_biz b, dim_pb_department c
 where a.l_proj_id = b.l_proj_id
   and a.l_dept_id = c.l_dept_id
   and b.l_pool_flag = 1
   and a.l_effective_flag = 1;

select * from tt_tc_scale_cont_m t where t.l_month_id = 201609 and t.l_proj_id = 1499;

--资管项目个数
select distinct a.c_proj_code,a.c_proj_name,c.c_invest_type_n
  from dim_pb_project_basic a, dim_pb_department b, dim_to_book c
 where a.l_dept_id = b.l_dept_id
   and a.l_proj_id = c.l_proj_id
   and c.l_effective_flag = 1
   and b.c_dept_name like '%资产管理%';

--新增项目个数
select b.c_proj_type_n, count(*)
  from dim_pb_project_basic a, dim_pb_project_biz b
 where a.l_effective_flag = 1
   and a.l_proj_id = b.l_proj_id
   and a.c_proj_phase >= '35'
   and nvl(a.l_setup_date, 20991231) between 20160901 and 20160930
 group by b.c_proj_type_n;
 
select t.c_object_code
  from tt_pb_object_status_m t, dim_pb_object_status s
 where t.l_month_id = 201609
   and t.l_objstatus_id = s.l_objstatus_id and t.c_object_type = 'XM'
   and s.l_setup_tm_flag = 1;
 
--新增项目规模，排除类资金池项目
select c.c_proj_type_n, round(sum(a.f_increase_tot) / 100000000, 2)
  from tt_tc_scale_cont_m   a,
       dim_tc_contract      d,
       dim_pb_product       e,
       dim_pb_project_basic b,
       dim_pb_project_biz   c
 where a.l_proj_id = b.l_proj_id
   and a.l_cont_id = d.l_cont_id
   and a.l_prod_id = e.l_prod_id
   and b.l_proj_id = c.l_proj_id
   and substr(d.l_effective_date, 1, 6) <= 201609
   and substr(d.l_expiration_date, 1, 6) > 201609
   and e.l_setup_date between 20160101 and 20160930
   and c.l_pool_flag = 0
 --and nvl(b.l_expiry_date, 20991231) > 20160930
   and a.l_month_id = 201609
 group by c.c_proj_type_n;

--清算项目个数
select b.c_proj_type_n, count(*)
  from dim_pb_project_basic a, dim_pb_project_biz b
 where a.l_effective_flag = 1
   and a.l_proj_id = b.l_proj_id
   and nvl(a.l_expiry_date, 20991231) between 20160901 and 20160930
 group by b.c_proj_type_n;
 
select t.c_object_code
  from tt_pb_object_status_m t, dim_pb_object_status s
 where t.l_month_id = 201609
   and t.l_objstatus_id = s.l_objstatus_id and t.c_object_type = 'XM'
   and s.l_expiry_tm_flag = 1;

--清算项目规模
select c.c_proj_type_n, round(sum(a.f_decrease_tot) / 100000000, 2)
  from tt_tc_scale_cont_m   a,
       dim_tc_contract      d,
       dim_pb_product       e,
       dim_pb_project_basic b,
       dim_pb_project_biz   c
 where a.l_proj_id = b.l_proj_id
   and a.l_cont_id = d.l_cont_id
   and a.l_prod_id = e.l_prod_id
   and b.l_proj_id = c.l_proj_id
   and substr(d.l_effective_date, 1, 6) <= 201609
   and substr(d.l_expiration_date, 1, 6) > 201609
   and nvl(b.l_expiry_date, 20991231) between 20160901 and 20160930
 --and nvl(b.l_expiry_date, 20991231) > 20160930
   and a.l_month_id = 201609
 group by c.c_proj_type_n;
 
 
--合同收入
select c.c_proj_type_n,
       round(sum(a.f_planned_agg) / 100000000, 2) as 合同收入,
       round(sum(a.f_planned_agg - a.f_actual_agg) / 100000000, 2) as 未计提,
       round(sum(a.f_actual_eot) / 100000000, 2) as 本年实收
  from tt_ic_ie_prod_m a, dim_pb_project_basic b, dim_pb_project_biz c,dim_pb_ie_type d ,dim_pb_ie_status e
 where a.l_month_id = 201609
   and a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_ietype_id = d.l_ietype_id
   and d.c_ietype_code_l1 = 'XTSR'
   and a.l_iestatus_id = e.l_iestatus_id and e.c_iestatus_code = 'NEW'
   and substr(b.l_effective_date, 1, 6) <= 201609
   and substr(b.l_expiration_date, 1, 6) > 201609
 group by c.c_proj_type_n;

--未计提合同收入
select f.c_proj_type_n,
       round(sum(c.f_planned_agg +
                 decode(e.c_ietype_code_l2, 'XTCGF', c.f_actual_agg, 0)) /
             100000000,
             2) as 合同收入
/*round(sum(decode(e.c_ietype_code_l2, 'XTCGF', c.f_actual_agg, 0)) /
10000,
2) as 合同财顾费*/
  from tt_ic_ie_party_m     c,
       dim_pb_project_basic d,
       dim_pb_ie_type       e,
       dim_pb_project_biz   f
 where c.l_proj_id = d.l_proj_id
   and c.l_month_id = 201609
   and c.l_ietype_id = e.l_ietype_id
   and e.c_ietype_code_l1 = 'XTSR'
   and c.l_proj_id = d.l_proj_id
   and d.l_proj_id = f.l_proj_id
   and substr(d.l_effective_date, 1, 6) <= 201609
   and substr(d.l_expiration_date, 1, 6) > 201609
   and nvl(d.l_expiry_date, 20991231) > 20160930
 group by f.c_proj_type_n;

/********************************************************************************************************************************************/
--资金来源明细底表
with temp_prod_scale as
 (select t.l_prod_id,
         sum(t.f_balance_agg) as f_balance_agg,
         sum(t.f_decrease_agg) as f_decrease_agg
    from tt_tc_scale_cont_m t, dim_pb_product t1
   where t.l_month_id = 201610
     and t.l_prod_id = t1.l_prod_id --and t1.l_prod_id = 1102
     and substr(t1.l_effective_date, 1, 6) <= t.l_month_id
     and substr(t1.l_expiration_date, 1, 6) > t.l_month_id
     --and t1.c_prod_code = 'ZH08NN'
   group by t.l_prod_id),
temp_prod_revenue as
 (select t.l_prod_id,
         nvl(sum(decode(t1.c_ietype_code_l2, 'XTBC', t.f_actual_agg, 0)), 0) as f_actual_xtbc, --累计已支付信托报酬
         nvl(sum(decode(t1.c_ietype_code_l2, 'XTCGF', t.f_actual_eot, 0)), 0) as f_actual_xtcgf, --本年已支付信托财顾费
         nvl(sum(decode(t1.c_ietype_code_l2, 'XTBC', t.f_planned_agg, 0)), 0) as f_planned_xtbc, --累计计划信托报酬
         nvl(sum(decode(t1.c_ietype_code_l2, 'XTCGF', t.f_planned_agg, 0)),
             0) as f_planned_xtcgf --累计计划财顾费
    from tt_ic_ie_prod_m t, dim_pb_ie_type t1
   where t.l_month_id = 201610
     and t.l_ietype_id = t1.l_ietype_id
   group by t.l_prod_id),
temp_benefical_right as
 (select t.l_prod_id,
         min(t.f_expect_field) as f_min_field,
         max(t.f_expect_field) as f_max_field
    from dim_tc_beneficial_right t
   group by t.l_prod_id),
temp_sale_way as
 (select t.l_prod_id, wmsys.wm_concat(distinct t.c_sale_way_n) as c_sale_way
    from dim_tc_contract t
   where substr(t.l_effective_date, 1, 6) <= 201610
     and substr(t.l_expiration_date, 1, 6) > 201610
   group by t.l_prod_id),
temp_ic_rate as
 (select t.l_prod_id,
         min(t.f_rate) as f_min_rate,
         max(t.f_rate) as f_max_rate
    from dim_ic_rate t
   group by t.l_prod_id)
select l.c_book_code as 帐套编号,
       b.c_proj_code as 项目编号,
       b.c_proj_name as 项目名称,
       a.c_prod_code as 产品编码,
       d.c_dept_name as 业务部门,
       c.c_manage_type_n as 管理类型,
       c.c_proj_type_n as 项目类型,
       c.c_func_type_n as 功能分类,
       nvl(e.f_balance_agg, 0) as 产品受托余额,
       null as FA规模,
       null as 投资余额,
       nvl(decode(c.l_pool_flag, 1, 0, e.f_decrease_agg), 0) as 累计还本, --类资金池项目不统计
       nvl(decode(a.c_struct_type, '0', e.f_balance_agg, 0), 0) as 优先,
       nvl(decode(a.c_struct_type, '2', e.f_balance_agg, 0), 0) as 劣后,
       decode(c.l_pool_flag, 1, b.l_setup_date, a.l_setup_date) 产品起始日期, --类资金池取项目成立日期
       decode(c.l_pool_flag, 1, b.l_expiry_date, a.l_expiry_date) 产品终止日期, --类资金池项目刦项目终止日期
       to_char(k.f_min_rate,'0.0000') || '-' || to_char(k.f_max_rate,'0.0000') as 产品信托报酬率,
       (f.f_actual_xtbc + f.f_actual_xtcgf + f.f_planned_xtbc +
       f.f_planned_xtcgf) as 合同总收入,
       (f.f_actual_xtbc + f.f_planned_xtbc) as 信托报酬,
       f.f_actual_xtbc as 累计已支付信托报酬,
       f.f_planned_xtbc as 尚未支付信托报酬,
       f.f_actual_xtcgf as 累计已支付财务顾问费,
       f.f_planned_xtcgf as 尚未支付财务顾问费,
       c.c_invest_indus_n as 项目实质投向,
       null as 合同受益人单一,
       g.c_inst_name as 实质资金来源,
       j.c_sale_way as 集合资金销售渠道,
       a.c_special_settlor as 集合项目特殊委托人,
       to_char(i.f_min_field,'0.0000') || '-' || to_char(i.f_max_field,'0.0000') as 产品预计收益率,
       case
         when nvl(b.l_expiry_date, 20991231) > 20160930 then
          '存续'
         else
          '清算'
       end as 是否清算,
       decode(a.l_tot_flag, 1, '是') as 是否TOT
  from dim_pb_product       a,
       dim_pb_project_basic b,
       dim_pb_project_biz   c,
       dim_pb_department    d,
       temp_prod_scale      e,
       temp_prod_revenue    f,
       dim_pb_institution   g,
       temp_benefical_right i,
       temp_sale_way        j,
       temp_ic_rate         k ,
       dim_to_book          l
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and b.l_dept_id = d.l_dept_id(+)
   and c.l_bankrec_ho = g.l_inst_id(+)
   and a.l_prod_id = e.l_prod_id(+)
   and a.l_prod_id = f.l_prod_id(+)
   and a.l_prod_id = i.l_prod_id(+)
   and a.l_prod_id = j.l_prod_id(+)
   and a.l_prod_id = k.l_prod_id(+)
   --and b.c_proj_code = 'AVICTC2016X0247'
   and a.l_prod_id = l.l_prod_id(+)
   and substr(a.l_effective_date, 1, 6) <= 201610
   and substr(a.l_expiration_date, 1, 6) > 201610
 order by b.l_setup_date, b.c_proj_code, a.c_prod_code;

/********************************************************************************************************************************************/
--资金运用明细表
select * from(
with temp_invest as
 (select t1.l_cont_id,
         sum(t1.f_invest_agg) as f_invest_agg,
         sum(t1.f_return_agg) as f_return_agg,
         sum(t1.f_balance_agg) as f_balance_agg,
         sum(t1.f_income_agg) as f_income_agg
    from tt_ic_invest_cont_d t1
   where t1.l_day_id = 20161130
   group by t1.l_cont_id)
select b.c_proj_code as 项目编码,
       b.c_name_full as 项目名称,
       a.c_cont_code as 合同编码,
       a.c_cont_name as 合同名称,
       d.c_dept_name as 业务部门,
       c.c_manage_type_n as 管理职责,
       c.c_proj_type_n as 项目类型,
       c.c_func_type_n as 功能分类,
       e.f_balance_agg as 投资余额,
       e.f_return_agg as 累计还本,
       a.l_begin_date as 合同起始日,
       a.l_expiry_date as 合同终止日,
       f.c_party_name as 交易对手,
       a.c_real_party as 实质交易对手,
       a.c_group_party as 集团交易对手,
       decode(b.f_trustpay_rate,null,null,to_char(b.f_trustpay_rate,'0.0000')) as 信托报酬率,
       a.c_invest_indus_n as 资金实质投向,
       g.c_area_name as 实质资金运用地,
       a.f_cost_rate as 投融资成本,
       a.l_xzhz_flag as 是否信政合作,
       c.c_special_type_n as 特殊业务标识,
       a.c_exit_way_n as 资金实质用途及退出,
       decode(a.l_invown_flag, 1, '是') as 是否投资公司自有产品
  from dim_ic_contract      a,
       dim_pb_project_basic b,
       dim_pb_project_biz   c,
       dim_pb_department    d,
       temp_invest          e,
       dim_ic_counterparty  f,
       dim_pb_area          g 
  where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and b.l_dept_id = d.l_dept_id
   and a.l_cont_id = e.l_cont_id(+)
   and a.l_party_id = f.l_party_id(+)
   and a.l_fduse_area = g.l_area_id(+)
   and a.l_effective_flag = 1) temp_am
--and a.c_real_party like '%美凯龙%'
--and b.l_proj_id = 1893
--and a.c_cont_code = 'DK11609C'
--order by b.l_setup_date desc, b.c_proj_code
union all
select * from (
with temp_fa as (select to2.l_proj_id,sum(to1.f_balance_agg) as f_balance_agg 
from tt_to_operating_book_d to1,dim_to_book to2 
where to1.l_book_id = to2.l_book_id 
and to2.l_effective_flag = 1 
and to1.l_day_id = 20161130
group by to2.l_proj_id)
select t1.c_proj_code as 项目编号,
       t1.c_name_full as 项目名称,
       null as 合同编码,
       null as 合同名称,
       t4.c_dept_name as 业务部门,
       t2.c_manage_type_n as 管理职责,
       t2.c_proj_type_n as 项目类型,
       t2.c_func_type_n as 功能分类,
       t3.f_balance_agg as 投资余额,
       null as 累计还本,
       t1.l_setup_date as 合同起始日,
       t1.l_expiry_date as 合同终止日,
       null as 交易对手,
       null as 实质交易对手,
       null as 集团交易对手,
       decode(t1.f_trustpay_rate,
              null,
              null,
              to_char(t1.f_trustpay_rate, '0.0000')) as 项目信托报酬率,
       null as 资金实质投向,
       null as 实质资金运用地,
       null as 投融资成本,
       null as 是否信政合作,
       t2.c_special_type_n as 特殊业务标识,
       null as 资金实质用途及退出,
       null as 是否投资公司自有产品
  from dim_pb_project_basic   t1,
       dim_pb_project_biz     t2,
       temp_fa t3,
       dim_pb_department      t4
 where t1.l_proj_id = t2.l_proj_id
   and (t2.l_pitch_flag = 1 or t2.c_special_type = 'A') --场内场外业务或者消费类项目
   and t1.l_effective_flag = 1
   and t1.l_proj_id = t3.l_proj_id(+)
   and t1.l_dept_id = t4.l_dept_id) temp_xd;

--旧
--资金运用明细底表
with temp_rate as
 (select t.l_proj_id,
         min(t.f_rate) as f_min_rate,
         max(t.f_rate) as f_max_rate
    from dim_ic_rate t
   where t.l_ietype_id = 2
   group by t.l_proj_id)
select b.c_proj_code as 项目编号,
       b.c_proj_name as 项目名称,
       a.c_cont_code as 合同编码,
       a.c_cont_name as 合同名称,
       d.c_dept_name as 业务部门,
       c.c_manage_type_n as 管理职责,
       c.c_proj_type_n as 项目类型,
       c.c_func_type_n as 功能分类,
       g.f_balance_agg as 投融资余额,
       g.f_return_agg as 累计还本,
       a.l_begin_date as 合同起始日,
       a.l_expiry_date as 合同终止日,
       a.l_expiry_date as 合同延期终止日,
       h.f_min_rate || '-' || h.f_max_rate as 项目信托报酬率,
       a.c_invest_indus_n as 资金实质投向,
       e.c_party_name as 实质交易对手,
       f.c_area_name as 实质资金运用地,
       a.f_cost_rate as 投融资成本,
       a.l_xzhz_flag as 是否信政合作,
       c.c_special_type_n as 特殊业务标识,
       a.c_exit_way_n as 资金实质用途及退出,
       a.l_invown_flag as 是否投资公司自有产品
  from dim_ic_contract      a,
       dim_pb_project_basic b,
       dim_pb_project_biz   c,
       dim_pb_department    d,
       dim_ic_counterparty  e,
       dim_pb_area          f,
       tt_ic_invest_cont_d  g,
       temp_rate            h
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and b.l_dept_id = d.l_dept_id
   and a.l_party_id = e.l_party_id
   and a.l_fduse_area = f.l_area_id
   and a.l_cont_id = g.l_cont_id
   and b.l_proj_id = h.l_proj_id(+)
   and g.l_day_id = 20160831
   and a.l_effective_flag = 1
union all
select t1.c_proj_code as 项目编号,
       t1.c_proj_name as 项目名称,
       null as 合同编码,
       null as 合同名称,
       t4.c_dept_name as 业务部门,
       t2.c_manage_type_n as 管理职责,
       t2.c_proj_type_n as 项目类型,
       t2.c_func_type_n as 功能分类,
       t3.f_scale_eot as 投融资余额,
       null as 累计还本,
       t1.l_setup_date as 合同起始日,
       t1.l_expiry_date as 合同终止日,
       null as 合同延期终止日,
       null as 项目信托报酬率,
       null as 资金实质投向,
       null as 实质交易对手,
       null as 实质资金运用地,
       null as 投融资成本,
       null as 是否信政合作,
       t2.c_special_type_n as 特殊业务标识,
       null as 资金实质用途及退出,
       null as 是否投资公司自有产品
  from dim_pb_project_basic t1, dim_pb_project_biz t2,tt_po_rate_proj_d t3,dim_pb_department t4
 where t1.l_proj_id = t2.l_proj_id
   and t2.l_pitch_flag = 1--场内场外业务
   and t1.l_effective_flag = 1
   and t1.l_proj_id = t3.l_proj_id(+)
   and t3.l_day_id = 20160930
   and t1.l_dept_id = t4.l_dept_id;

--是否场内场外业务
select b.l_pitch_flag,a.* from dim_pb_project_basic a,dim_pb_project_biz b where a.l_proj_id = b.l_proj_id and a.c_proj_code = 'AVICTC2014X0641';

--TA、FA、AM规模比较
with temp_ta as
 (select a.l_proj_id,
         sum(a.f_balance_agg) as f_ta
    from tt_tc_scale_cont_m a, dim_pb_product b
   where a.l_prod_id = b.l_prod_id
     and a.l_month_id = 201610
     and substr(b.l_effective_date, 1, 6) <= 201610
     and substr(b.l_expiration_date, 1, 6) > 201610
   group by a.l_proj_id),
temp_fa as
 (select c.l_proj_id,
         sum(c.f_balance_agg) as f_fa
    from tt_to_operating_book_m c,dim_to_book c1
   where c.l_month_id = 201610 
     and c.l_book_id = c1.l_book_id
     and c1.l_effective_flag = 1
   group by c.l_proj_id),
temp_am as
 (select a.l_proj_id,
         sum(a.f_invest_agg) - sum(a.f_return_agg) as f_am
    from tt_ic_invest_cont_m a, dim_ic_contract b
   where a.l_cont_id = b.l_cont_id
     and substr(b.l_effective_date, 1, 6) <= 201610
     and substr(b.l_expiration_date, 1, 6) > 201610
     and a.l_month_id = 201610
   group by a.l_proj_id)
select t.l_proj_id,t.c_proj_code,t.c_proj_name,t.l_setup_date,temp_ta.f_ta, temp_fa.f_fa, temp_am.f_am
  from dim_pb_project_basic t,temp_ta, temp_fa, temp_am
 where t.l_proj_id = temp_ta.l_proj_id 
   and temp_ta.l_proj_id = temp_fa.l_proj_id(+)
   and temp_ta.l_proj_id = temp_am.l_proj_id(+);
--and (temp_ta.f_ta <> temp_fa.f_fa or temp_ta.f_ta <> temp_am.f_am);

select t1.c_proj_code   as 项目编码,
       t1.c_proj_name   as 项目名称,
       t1.l_setup_date  as 成立日期,
       t1.f_balance_eot as TA规模,
       t2.f_scale_eot   as FA规模,
       t2.c_proj_code   as 项目编码,
       t2.c_proj_name   as 项目名称
  from (select b.l_proj_id,b.c_proj_code,b.c_proj_name,b.l_setup_date,a.f_balance_eot
           from tt_sr_scale_proj_m a, dim_pb_project_basic b
          where a.l_proj_id = b.l_proj_id
            and a.l_month_id = 201610
            and substr(b.l_effective_date, 1, 6) <= 201610
            and substr(b.l_expiration_date, 1, 6) > 201610) t1 full outer join
        (select d.l_proj_id,d.c_proj_code,d.c_proj_name,d.l_setup_date,c.f_scale_eot
           from tt_po_rate_proj_d c, dim_pb_project_basic d
          where c.l_proj_id = d.l_proj_id
            and c.l_day_id = 20161031) t2 on t1.l_proj_id = t2.l_proj_id 
  where t1.f_balance_eot <> t2.f_scale_eot
order by t1.l_setup_date;

--AM投资余额
select b.c_proj_code,
       b.c_proj_name,
       sum(a.f_invest_agg),
       sum(a.f_return_agg),
       sum(a.f_invest_agg) - sum(a.f_return_agg) as 投资余额
  from tt_ic_invest_cont_m a, dim_pb_project_basic b,dim_ic_contract c
 where a.l_proj_id = b.l_proj_id
   and a.l_month_id = 201610
   and b.c_proj_code = 'AVICTC2015X1176'
 group by b.c_proj_code, b.c_proj_name;

--AM投资余额
select a.*
  from tt_ic_invest_cont_m a, dim_pb_project_basic b
 where a.l_proj_id = b.l_proj_id
   and a.l_month_id = 201610
   and b.c_proj_code = 'AVICTC2015X1176';
   
--信托业务收入，按收入状态
select b.c_proj_code,
       /*a.l_revtype_id,
       A.L_REVSTATUS_ID,*/
       sum(a.f_actual_eot),
       sum(a.f_actual_agg),
       sum(a.f_actual_agg+a.f_planned_agg)
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b
 where a.l_proj_id = b.l_proj_id
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6) and a.l_revtype_id = 2
   and a.l_month_id = 201609 --and b.c_proj_code = 'AVICTC2014X0232'
 group by b.c_proj_code/*, a.l_revtype_id, A.L_REVSTATUS_ID*/;

select * from dim_sr_revenue_type;
select * from dim_pb_project_basic t where t.c_proj_code = 'AVICTC2014X0232';
select * from tt_sr_revenue_flow_d t where t.l_stage_id  = 3473;

--产品信托收入
select b.c_stage_code,
       /*a.l_revtype_id,
       A.L_REVSTATUS_ID,*/
       sum(a.f_actual_eot) as 今年信托收入,
       sum(a.f_actual_agg) as 累计信托收入,
       sum(a.f_actual_agg + a.f_planned_agg) as 合同总收入
  from tt_sr_tstrev_stage_m a, dim_sr_stage b
 where a.l_stage_id = b.l_stage_id
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201609 --and b.c_proj_code = 'AVICTC2014X0232'
 group by b.c_stage_code /*, a.l_revtype_id, A.L_REVSTATUS_ID*/
having sum(a.f_actual_agg + a.f_planned_agg) <> 0;

--运营简表
select null as 帐套编号,
       a.c_cont_code as 合同编码,
       a.c_cont_no as 合同编号,
       c.c_proj_name as 项目名称,
       d.c_dept_name as 部门名称,
       f.c_manage_type_n as 主/被动,
       e.f_balance_agg   as 受托余额,
       e.f_decrease_agg  as 累计还本,
       decode(b.c_struct_type,'0',e.f_balance_agg,null ) as 优先,
       decode(b.c_struct_type,'2',e.f_balance_agg,null ) as 劣后,
       a.l_sign_date as 合同起点时间,
       a.l_expiry_date as 合同终止时间,
       null as 实际信托报酬率,
       null as 合同总收入,
       null as 本年应计提收入,
       null as 尚未计提收入,
       null as 信托报酬收入,
       null as 合同财务顾问收入
  from dim_tc_contract      a,
       dim_pb_product       b,
       dim_pb_project_basic c,
       dim_pb_department    d,
       tt_tc_scale_cont_m   e,
       dim_pb_project_biz   f
 where a.l_prod_id = b.l_prod_id
   and b.l_proj_id = c.l_proj_id
   and c.l_dept_id = d.l_dept_id
   and a.l_cont_id = e.l_cont_id
   and b.l_proj_id = f.l_proj_id
   and substr(a.l_effective_date, 1, 6) <= e.l_month_id
   and substr(a.l_expiry_date, 1, 6) > e.l_month_id
   and e.l_month_id = 201609;

--收入
select c.c_proj_code as 项目编码,
       c.c_proj_name as 项目名称,
       b.c_stage_code as 产品编码,
       b.l_setup_date as 产品成立日期,
       b.l_expiry_date as 产品到期日期,
       b.c_stage_name as 产品名称,
       d.c_dept_name as 部门名称,
       sum(decode(a.l_revtype_id, 2, a.f_actual_agg, 0)) as 累计已支付信托报酬,
       sum(decode(a.l_revtype_id, 2, a.f_actual_eot, 0)) as 本年已支付信托报酬,
       sum(decode(a.l_revtype_id, 2, a.f_planned_agg, 0)) as 累计未支付信托报酬,
       sum(decode(a.l_revtype_id, 4, a.f_actual_agg, 0)) as 累计已支付财顾费,
       sum(decode(a.l_revtype_id, 4, a.f_actual_eot, 0)) as 本年已支付财顾费,
       sum(decode(a.l_revtype_id, 4, a.f_planned_agg, 0)) as 累计未支付财顾费
  from tt_sr_tstrev_stage_m a,
       dim_sr_stage         b,
       dim_pb_project_basic c,
       dim_pb_department    d
 where a.l_stage_id = b.l_stage_id
   and b.l_proj_id = c.l_proj_id
   and c.l_dept_id = d.l_dept_id
   and substr(c.l_effective_date, 1, 6) <= 201608
   and substr(c.l_expiration_date, 1, 6) > 201608
   and a.l_month_id = 201608
 group by c.c_proj_code,
          c.c_proj_name,
          b.c_stage_code,
          b.c_stage_name,
          b.l_setup_date,
          b.l_expiry_date,
          d.c_dept_name
having sum(a.f_actual_eot) <> 0 or sum(a.f_planned_eot) <> 0
 order by b.l_setup_date;

--成立
select s.c_projcode  as 项目编码,
       s.c_fullname  as 项目名称,
       s.d_begdate   as 项目开始日期,
       s.d_enddate   as 项目结束日期,
       t.c_fundcode  as 产品编码,
       t.c_fundname  as 产品名称,
       t.d_issuedate as 产品发行日期,
       t.d_setupdate as 产品成立日期,
       t.d_enddate   as 产品终止日期,
       t.d_liqudate  as 产品清算日期
  from ta_fundinfo t, pm_projectinfo s
 where t.c_projcode = s.c_projcode
   and t.d_setupdate is null;

--投资合同余额
select b.c_prod_code as 产品编码,
       b.c_prod_name as 产品名称,
       b.l_setup_date,
       sum(a.f_balance_agg) as 投资余额
  from tt_ic_invest_cont_m a, dim_pb_product b, dim_ic_contract c
 where a.l_prod_id = b.l_prod_id
   and a.l_cont_id = c.l_cont_id
   and a.l_month_id = 201608
   and substr(c.l_effective_date, 1, 6) <= 201608
   and substr(c.l_expiration_date, 1, 6) > 201608
 group by b.c_prod_code, b.c_prod_name, b.l_setup_date
 order by sum(a.f_balance_agg);
 
--存续项目个数
select t.l_proj_id,
       t.c_proj_code,
       t.c_proj_name,
       t.l_setup_date,
       t.l_preexp_date,
       t.l_expiry_date,
       t.c_proj_status_n,
       t.c_proj_phase_n,
       s.c_book_code,
       r.f_balance_eot
  from dim_pb_project_basic t, dim_to_book s, (select * from tt_sr_scale_proj_m where l_month_id = 201609) r
 where nvl(t.l_expiry_date, 20991231) > 20160930
   and t.l_proj_id = s.l_proj_id(+)
   and t.l_proj_id = r.l_proj_id(+)
   and t.c_proj_phase >= '35'
   and t.l_effective_flag = 1;
   
   select * from tt_sr_scale_proj_m t where t.l_month_id = 201609;
   
   select * from dim_to_book t where t.c_book_code = '200222';
   
   select * from dim_pb_project_basic t where t.l_proj_id = 597;
   
--存续规模合计
select sum(a.f_balance_eot) / 100000000
  from tt_sr_scale_proj_m a, dim_pb_project_biz b, dim_pb_project_basic c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_month_id >= substr(c.l_effective_date, 1, 6)
   and a.l_month_id < substr(c.l_expiration_date, 1, 6)
   and a.l_month_id = 201606
   and nvl(c.l_expiry_date, '20991231') > 20160630;

--产品收入
select d.c_proj_code,
       d.c_proj_name,
       c.c_prod_code,
       c.c_prod_name,
       b.c_ietype_name,
       sum(a.f_actual_agg) as 累计实现收入,
       sum(a.f_planned_agg) as 累计计划收入,
       sum(a.f_actual_agg - a.f_planned_agg) as 累计未计提收入
  from tt_ic_ie_party_d     a,
       dim_pb_ie_type       b,
       dim_pb_product       c,
       dim_pb_project_basic d
 where a.l_day_id = 20161110
   and a.l_prod_id = c.l_prod_id
   and a.l_proj_id = d.l_proj_id
   and d.l_effective_flag = 1
   and a.l_ietype_id = b.l_ietype_id
   and b.c_ietype_code_l1 = 'XTSR'
 group by d.c_proj_code,
          d.c_proj_name,
          c.c_prod_code,
          c.c_prod_name,
          b.c_ietype_name;

--项目收入
select d.c_proj_code,
       d.c_proj_name,
       d.l_setup_date,
       d.c_Proj_Phase_n,
       b.c_ietype_name,
       sum(a.f_actual_agg) as 累计实现收入,
       sum(a.f_planned_agg) as 累计计划收入,
       sum(a.f_planned_agg - a.f_actual_agg) as 累计未计提收入
  from tt_ic_ie_party_m a, dim_pb_ie_type b, dim_pb_project_basic d
 where a.l_month_id = 201609
   and a.l_proj_id = d.l_proj_id
   and d.l_effective_flag = 1
   and a.l_ietype_id = b.l_ietype_id
   and b.c_ietype_code_l1 = 'XTSR'
 group by d.c_proj_code,
          d.c_proj_name,
          d.l_setup_date,
          d.c_Proj_Phase_n,
          b.c_ietype_name
 order by d.c_proj_phase_n, d.l_setup_date;
 
--项目收入
select d.c_proj_code as 项目编码,
       d.c_proj_name as 项目名称,
       d.l_setup_date as 成立日期,
       d.c_Proj_Phase_n as 项目阶段,
       e.c_dept_name as 部门名称,
       b.c_ietype_name as 收入类型,
       sum(a.f_actual_agg) as 累计实现收入,
       sum(a.f_planned_agg) as 累计计划收入,
       sum(a.f_planned_agg - a.f_actual_agg) as 累计未计提收入
  from tt_ic_ie_party_m a, dim_pb_ie_type b, dim_pb_project_basic d,dim_pb_department e
 where a.l_month_id = 201610
   and a.l_proj_id = d.l_proj_id
   and d.l_dept_id = e.l_dept_id
   and a.l_month_id >= substr(d.l_effective_date, 1, 6)
   and a.l_month_id < substr(d.l_expiration_date, 1, 6)
   and a.l_ietype_id = b.l_ietype_id
   and b.c_ietype_code_l3 = 'XTGDBC'
 group by d.c_proj_code,
          d.c_proj_name,
          d.l_setup_date,
          d.c_Proj_Phase_n,
          e.c_dept_name,
          b.c_ietype_name having sum(a.f_planned_agg - a.f_actual_agg) < 0
 order by  e.c_dept_name,d.c_proj_phase_n,d.l_setup_date;
 
 select * from Dim_Pb_Project_Basic t where t.c_proj_code = 'AVICTC2013X0451'
 
 
--BI简表
with temp_scale as
 (select b.c_proj_code,
         b.c_proj_name,
         round(sum(a.f_balance_agg) / 10000, 2) as 受托余额,
         round(sum(a.f_decrease_agg) / 10000, 2) as 累计还本
    from tt_tc_scale_cont_m a, dim_pb_project_basic b
   where a.l_proj_id = b.l_proj_id
     and a.l_month_id = 201611
     and a.l_proj_id = b.l_proj_id
     and substr(b.l_effective_date, 1, 6) <= 201611
     and substr(b.l_expiration_date, 1, 6) > 201611
     and nvl(b.l_expiry_date, 20991231) > 20161130
   group by b.c_proj_code,b.c_proj_name),
temp_ie as
 (select d.c_proj_code,
         round(sum(c.f_planned_agg) / 10000, 2) as 合同收入,
         round(sum(decode(e.c_ietype_code_l2, 'XTBC', c.f_planned_agg, 0)) /
               10000,
               2) as 合同报酬,
         round(sum(decode(e.c_ietype_code_l2, 'XTCGF', c.f_planned_agg, 0)) /
               10000,
               2) as 合同财顾费
  
    from tt_ic_ie_party_m c, dim_pb_project_basic d, dim_pb_ie_type e
   where c.l_proj_id = d.l_proj_id
     and c.l_month_id = 201611
     and c.l_ietype_id = e.l_ietype_id
     and e.c_ietype_code_l1 = 'XTSR'
     and c.l_proj_id = d.l_proj_id
     and substr(d.l_effective_date, 1, 6) <= 201611
     and substr(d.l_expiration_date, 1, 6) > 201611
     and nvl(d.l_expiry_date, 20991231) > 20161130
   group by d.c_proj_code)
select *
  from temp_scale
  full outer join temp_ie
    on temp_scale.c_proj_code = temp_ie.c_proj_code --where temp_scale.c_proj_code =  'AVICTC2015X1029'
 order by temp_scale.c_Proj_code;


--资管合同投资规模
select b.c_invest_indus_n, round(sum(a.f_balance_agg) / 100000000, 2)
  from tt_ic_invest_cont_m  a,
       dim_ic_contract      b,
       dim_pb_project_basic c,
       dim_pb_department    d
 where a.l_cont_id = b.l_cont_id
   and b.l_proj_id = c.l_proj_id
   and c.l_dept_id = d.l_dept_id
   and d.c_dept_code <> '841'
   and substr(b.l_effective_date, 1, 6) <= 201609
   and substr(b.l_expiration_date, 1, 6) > 201609
   and a.l_month_id = 201609
 group by b.c_invest_indus_n;
 
 select * from dim_pb_department;
 
 select * from dim_ic_contract a where exists(select 1 from dim_pb_project_biz b where a.l_proj_id = b.l_proj_id and a.c_invest_indus<>b.c_invest_indus);
 
 select t.*
   from tt_ic_ie_prod_m t
  where t.l_month_id = 201609
    and t.f_actual_agg > t.f_planned_agg;

select * from dim_pb_budget_item a;

--环比
select *
  from (select a.l_month_id,
               c.month_of_year / 3 as 季度,
               c.year_id as 年度,
               b.c_item_code,
               b.c_item_name,
               lag(a.f_actual, 1, 0) over(partition by b.c_item_code, b.c_item_name order by a.l_month_id),
               a.f_actual
          from tt_pb_budget_m a, dim_pb_budget_item b, dim_month c
         where a.l_item_id = b.l_item_id
           and a.l_month_id = c.month_id
           and b.c_item_code in ('GS000002', 'GS000003', 'GS000004')) t
 where 季度 = 4
   and 年度 = 2016;
   
--同比
select *
  from (select a.l_month_id,
               c.month_of_year / 3 as 季度,
               c.year_id as 年度,
               b.c_item_code,
               b.c_item_name,
               lag(a.f_actual, 1, 0) over(partition by b.c_item_code, b.c_item_name order by c.month_of_year, c.year_id),
               a.f_actual
          from tt_pb_budget_m a, dim_pb_budget_item b, dim_month c
         where a.l_item_id = b.l_item_id
           and a.l_month_id = c.month_id
           and b.c_item_code in ('GS000002', 'GS000003', 'GS000004')) t
 where 季度 = 4
   and 年度 = 2016;
   
--有计划无实际收入
select c.c_proj_code as 项目编码,
       c.c_proj_name as 项目名称,
       c.l_setup_date as 项目成立日期,
       d.c_dept_name as 部门名称,
       b.c_prod_code as 产品编码,
       sum(a.f_actual_agg) as 实际收入,
       sum(a.f_planned_agg) as 计划收入
  from tt_ic_ie_prod_m      a,
       dim_pb_product       b,
       dim_pb_project_basic c,
       dim_pb_department    d
 where a.l_prod_id = b.l_prod_id
   and a.l_proj_id = c.l_proj_id
   and c.l_dept_id = d.l_dept_id
   and a.l_ietype_id = 3
   and a.l_month_id = 201609
      --and c.c_proj_code = 'AVICTC2016X0247'
      --group by c.c_proj_code,c.c_proj_name,c.l_setup_date
   and a.f_planned_agg - a.f_actual_agg < 0
 group by c.c_proj_code,
          c.c_proj_name,
          c.l_setup_date,
          d.c_dept_name,
          b.c_prod_code
 order by c.l_setup_date desc, c.c_proj_code;

select substr(b.l_expiry_date, 1, 6),
       round(sum(a.f_pay_agg * 365) / sum(a.f_days_agg * a.f_scale_agg), 6)
  from tt_to_operating_book_m a,
       dim_pb_project_basic   b,
       dim_to_book            c,
       tt_pb_object_status_m  d,
       dim_pb_object_status   e
 where a.l_proj_id = b.l_proj_id
   and a.l_book_id = c.l_book_id
   and b.l_proj_id = d.l_object_id
   and d.l_objstatus_id = e.l_objstatus_id
   and d.c_object_type = 'XM'
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201610
   and b.l_effective_flag = 1
   and e.l_expiry_ty_flag = 1
 group by substr(b.l_expiry_date, 1, 6)
 order by substr(b.l_expiry_date, 1, 6);

/**************************************************************************************************************************************/
--本年终止项目明细
select c.c_book_code   as 帐套编码,
       b.c_proj_code   as 项目编码,
       b.c_proj_name   as 项目名称,
       b.l_setup_date  as 项目成立日期,
       b.l_expiry_date as 项目终止日期,
       a.f_days_agg    as 项目存续天数,
       a.f_scale_agg   as 实收信托,
       a.f_scale_ad    as 日均规模,
       a.f_cost_agg    as 累计信托费用,
       a.f_income_agg  as 累计受益人收益,
       a.f_pay_agg     as 累计受托人报酬
  from tt_to_operating_book_m a,
       dim_pb_project_basic   b,
       dim_to_book            c,
       tt_pb_object_status_m  d,
       dim_pb_object_status   e
 where a.l_proj_id = b.l_proj_id
   and a.l_book_id = c.l_book_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and d.l_objstatus_id = e.l_objstatus_id
   and e.l_expiry_ty_flag = 1
   and a.l_month_id = d.l_month_id
   and b.l_effective_flag = 1
   and a.l_month_id = 201610
-- and c.c_book_code = '100611'
--and nvl(b.l_expiry_date, 20991231) between 20160101 and 20161031
 order by c.c_book_code;
 
--资管帐套投资类型
select b.c_proj_code     as 项目编码,
       b.c_name_full     as 项目名称,
       a.c_book_code     as 帐套编码,
       a.c_book_name     as 帐套名称,
       a.c_invest_type_n as 帐套投资类型,
       a.c_book_type_n   as 帐套类型
  from dim_to_book a, dim_pb_project_basic b, dim_pb_department c
 where a.l_proj_id = b.l_proj_id
   and a.l_effective_flag = 1
   and b.l_dept_id = c.l_dept_id
   and c.c_dept_code = '841'
 order by b.c_proj_code;
 
--前十资金来源占比
with temp_scale as
 (select t1.l_proj_id, sum(t1.f_increase_agg) as f_increase_agg, sum(t1.f_balance_agg) as f_balance_agg
    from tt_tc_scale_cont_m t1, dim_tc_contract t2
   where t1.l_cont_id = t2.l_cont_id
     and t1.l_month_id = 201609
     and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
     and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
   group by t1.l_proj_id)
select c.c_inst_code,
       c.c_inst_name,
       a.c_proj_code,
       a.c_proj_name,
       b.c_proj_type_n,
       d.f_increase_agg,
       d.f_balance_agg
  from dim_pb_project_basic a,
       dim_pb_project_biz   b,
       dim_pb_institution   c,
       temp_scale           d
 where a.l_proj_id = b.l_proj_id
   and b.l_bankrec_ho = c.l_inst_id
   and a.l_proj_id = d.l_proj_id(+)
   and a.l_effective_flag = 1;

select *
  from dim_pb_project_basic a, dim_pb_project_biz b
 where a.l_proj_id = b.l_proj_id
   and b.l_pool_flag = 1
   and nvl(a.l_expiry_date, 20991231) <= 20161130;

--投资合同明细行业投向
select a.c_cont_code,b.c_indus_name
  from dim_ic_contract a, dim_pb_industry b
 where a.l_invindus_id = b.l_indus_id
   and a.l_effective_flag = 1;

--财报数据查询
select a.c_item_name, b.f_money_tot, b.f_money_eot,b.f_money_lot
  from dim_fi_statement_item a, tt_fi_statement_m b
 where a.l_item_id = b.l_item_id
   and b.l_state_id = 6
   and b.l_month_id = 201609
 order by a.l_column_axis, a.l_row_axis;




-----------------------------------------------------------------存续项目----------------------------------------------------------------
--存续规模合计
select sum(a.f_balance_eot)/100000000 
from tt_sr_scale_proj_m a ,dim_pb_project_biz b ,dim_pb_project_basic c
where a.l_proj_id = b.l_proj_id and b.l_proj_id = c.l_proj_id
and a.l_month_id >= substr(c.l_effective_date,1,6)
and a.l_month_id < substr(c.l_expiration_date, 1,6)
and a.l_month_id = 201606 
and nvl(c.l_expiry_date,'20991231') > 20160630;

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
select b.l_proj_id,b.l_effective_flag,b.l_effective_date,b.c_proj_code,b.c_proj_name,b.l_setup_date,b.l_expiry_date,a.c_proj_type_n,a.c_func_type_n,a.c_affair_props,a.c_affair_props_n 
from dim_pb_project_biz a,dim_pb_project_basic b 
where a.l_Proj_id = b.l_proj_id 
and b.l_effective_flag = 1
order by b.c_proj_code,a.l_proj_id;

-----------------------------------------------------------------新增项目----------------------------------------------------------------
--新增项目个数，按项目类型，功能分类
select b.c_proj_type,
       b.c_proj_type_n,
       b.c_func_type,
       b.c_func_type_n,
       b.c_affair_props,
       b.c_affair_props_n,
       count(*)
  from tt_sr_scale_proj_d a, dim_pb_project_biz b, dim_sr_project_junk c
 where a.l_proj_id = b.l_proj_id
   and a.L_PROJ_JUNK_ID = c.L_PROJ_JUNK_ID
   and a.l_day_id = 20160831
   and c.l_setup_ty_flag = 1
 group by b.c_proj_type,
          b.c_proj_type_n,
          b.c_func_type,
          b.c_func_type_n,
          b.c_affair_props,
          b.c_affair_props_n
 order by b.c_proj_type, b.c_func_type, b.c_affair_props;

--新增项目个数，按期限，需要确认期限都维护准确
select case when nvl(c.l_time_limit,99) <= 12 then '一年期以内 else '一年期以上 end 期限,count(*) 
from tt_sr_scale_proj_d a ,dim_sr_project_junk b,dim_pb_project_basic c
where a.l_proj_id = c.l_proj_id  
and a.L_PROJ_JUNK_ID = b.L_PROJ_JUNK_ID 
and a.l_proj_id = c.l_proj_id
and a.l_day_id = 20160630
and b.l_setup_ty_flag = 1 
group by case when nvl(c.l_time_limit,99) <= 12 then '一年期以内 else '一年期以上 end;

--新增项目个数，按期限明细	
select c.c_proj_code,c.c_proj_name,case when nvl(c.l_time_limit,99) <= 12 then '一年期以内 else '一年期以上 end 期限,count(*),sum(a.f_increase_eot) 
from tt_sr_scale_proj_d a ,dim_sr_project_junk b,dim_pb_project_basic c
where a.l_proj_id = c.l_proj_id  
and a.L_PROJ_JUNK_ID = b.L_PROJ_JUNK_ID 
and a.l_proj_id = c.l_proj_id
and a.l_day_id = 20160630
and b.l_setup_ty_flag = 1 
group by c.c_proj_code,c.c_proj_name,case when nvl(c.l_time_limit,99) <= 12 then '一年期以内 else '一年期以上 end;

--新增项目规模
select sum(a.f_increase_eot) from tt_sr_scale_stage_d a,dim_sr_stage b 
where a.l_stage_id = b.l_stage_id 
and B.L_SETUP_DATE > 20151231 
and a.l_day_id = 20160630;

--新成立规模，非交易类申购
select c.c_proj_type,
       c.c_proj_type_n,
       c.c_func_type,
       c.c_func_type_n,
       c.c_affair_props,
       c.c_affair_props_n,
       sum(case
             when b.c_scatype_code = '50' then
              a.f_incurred_eot
             when b.c_scatype_code = '02' and l_valuation_flag <> 1 then
              a.f_incurred_eot
             else
              0
           end) / 100000000 as f_scale
  from tt_sr_scale_type_m   a,
       dim_sr_scale_type    b,
       dim_pb_project_biz   c,
       dim_pb_project_basic d
 where a.l_proj_id = c.l_proj_id
   and c.l_proj_id = d.l_proj_id
   and a.l_scatype_id = b.l_scatype_id
   and a.l_month_id = 201608
 group by c.c_proj_type,
          c.c_proj_type_n,
          c.c_func_type,
          c.c_func_type_n,
          c.c_affair_props,
          c.c_affair_props_n
 order by c.c_proj_type, c.c_func_type, c.c_affair_props;

-----------------------------------------------------------------清算项目----------------------------------------------------------------
--清算项目个数，按项目类型，功能分类
select b.c_proj_type_n,b.c_func_type_n,b.c_affair_props_n,count(*) from tt_sr_scale_proj_d a ,dim_pb_project_biz b ,dim_sr_project_junk c
where a.l_proj_id = b.l_proj_id  
and a.L_PROJ_JUNK_ID = c.L_PROJ_JUNK_ID
and a.l_day_id = 20160630
and c.l_clear_ty_flag = 1
group by b.c_proj_type_n,b.c_func_type_n,b.c_affair_props_n 
order by b.c_proj_type_n,b.c_func_type_n,b.c_affair_props_n;

--非交易赎回
select c.c_proj_type_n,c.c_func_type_n,c.c_affair_props_n,
sum(case when b.c_scatype_code = '03' and l_valuation_flag <> 1 then a.f_incurred_agg else 0 end)/100000000 as f_scale
from tt_sr_scale_type_m a ,dim_sr_scale_type b,dim_pb_project_biz c ,dim_pb_project_basic d
where a.l_proj_id = c.l_proj_id 
and c.l_proj_id = d.l_proj_id
and a.l_scatype_id = b.l_scatype_id 
and a.l_month_id = 201606
and nvl(d.l_expiry_date,'20010101') > 20151231
and a.l_month_id >= substr(d.l_effective_date,1,6)
and a.l_month_id < substr(d.l_expiration_date, 1,6)
group by c.c_proj_type_n,c.c_func_type_n,c.c_affair_props_n 
order by c.c_proj_type_n,c.c_func_type_n,c.c_affair_props_n ;

--兑付规模：非估值类赎回
select 
sum(case when b.c_scatype_code = '03' and l_valuation_flag <> 1 then a.f_incurred_eot else 0 end)/100000000 as f_scale
from tt_sr_scale_type_m a ,dim_sr_scale_type b,dim_pb_project_biz c ,dim_pb_project_basic d
where a.l_proj_id = c.l_proj_id 
and c.l_proj_id = d.l_proj_id
and a.l_scatype_id = b.l_scatype_id 
and a.l_month_id = 201606;

--兑付规模：估值类终止项目本年赎回
select d.c_proj_code,
sum( a.f_incurred_eot )/100000000 as f_scale
from tt_sr_scale_type_m a ,dim_sr_scale_type b,dim_pb_project_biz c ,dim_pb_project_basic d
where a.l_proj_id = c.l_proj_id 
and c.l_proj_id = d.l_proj_id
and a.l_scatype_id = b.l_scatype_id 
and c.l_valuation_flag = 1
and b.c_scatype_code = '03'
and nvl(d.l_expiry_date,'20991231') between 20160101 and 20160630
and a.l_month_id = 201606
group by d.c_proj_code;

--终止项目情况
select b.c_proj_code,b.c_proj_name,b.l_expiry_date,
a.f_exist_days,a.f_scale_agg,a.f_trust_cost,a.f_benefic_income,a.f_trust_pay,a.f_cost_rate,a.f_benefic_rate,a.f_pay_rate
from tt_po_rate_proj_d a ,dim_pb_project_basic b ,dim_pb_project_biz c
where a.l_proj_id = b.l_proj_id
and b.l_proj_id = c.l_proj_id
and nvl(b.l_expiry_date,20991231) between 20160101 and 20160630
and a.l_day_id = 20160630
order by b.c_proj_code;

--清算规模
select a.l_proj_id,
       a.f_incurred_agg,
       b.l_proj_id,
       b.c_proj_code,
       b.c_proj_name,
       b.l_expiry_date
  from (select t.l_proj_id, sum(t.f_incurred_agg) as f_incurred_agg
          from tt_sr_scale_type_m t
         where t.l_scatype_id = 1301
           and t.l_month_id = 201608
         group by t.l_proj_id) a,
       (select *
          from dim_pb_project_basic t
         where t.l_dept_id = 2
           and t.l_effective_flag = 1
           and nvl(t.l_expiry_date, '20991231') between 20160101 and
               20160831) b
 where a.l_proj_id = b.l_proj_id;
 
--终止项目情况
select b.c_proj_code,
a.f_scale_agg,
a.f_exist_days,
a.f_trust_cost,
a.f_benefic_income,
a.f_trust_Pay,
a.f_cost_rate,
a.f_benefic_rate,
a.f_benefic_rate 
from tt_po_rate_proj_d a,dim_pb_project_basic b 
where b.l_proj_id = a.l_proj_id 
and  a.l_day_id = 20160630
and nvl(b.l_expiry_date,20991231) between 20160101 and 20160630
order by b.c_proj_code;

 --终止项目明细
with temp_qs as
 (select b.l_proj_id,
         b.c_proj_code,
         b.c_proj_name,
         b.l_expiry_date,
         ROUND(a.f_incurred_agg / 10000, 4) as f_qs
    from (select t.l_proj_id, sum(t.f_incurred_agg) as f_incurred_agg
            from tt_sr_scale_type_m t
           where t.l_scatype_id = 1301
             and t.l_month_id = 201608
           group by t.l_proj_id) a,
         (select *
            from dim_pb_project_basic t
           where t.l_effective_flag = 1
             and nvl(t.l_expiry_date, '20991231') between 20160801 and
                 20160831) b
   where a.l_proj_id = b.l_proj_id)
select d.c_proj_type_n,
       d.c_func_type_n,
       d.c_affair_props_n,
       b.c_proj_code,
       b.c_proj_name,
       round(A.F_SCALE_AGG / 10000, 4),
       c.f_qs,
       A.F_EXIST_DAYS,
       A.F_TRUST_PAY,
       A.F_BENEFIC_INCOME,
       A.F_TRUST_COST,
       A.F_PAY_RATE,
       A.F_BENEFIC_RATE,
       A.F_COST_RATE
  from tt_po_rate_proj_d    a,
       dim_pb_project_basic b,
       temp_qs              c,
       dim_pb_project_biz   d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_proj_id
   and a.l_proj_id = c.l_proj_id
   and a.l_day_id = 20160831
   and nvl(b.l_expiry_date, '20991231') between 20160801 and 20160831;
   
--终止项目明细
with temp_qs as
 (select b.l_proj_id,
         b.c_proj_code,
         b.c_proj_name,
         b.l_expiry_date,
         ROUND(a.f_incurred_agg / 10000, 4) as f_qs
    from (select t.l_proj_id, sum(t.f_incurred_agg) as f_incurred_agg
            from tt_sr_scale_type_m t
           where t.l_scatype_id = 1301
             and t.l_month_id = 201608
           group by t.l_proj_id) a,
         (select *
            from dim_pb_project_basic t
           where t.l_effective_flag = 1
             and nvl(t.l_expiry_date, '20991231') between 20160801 and
                 20160831) b
   where a.l_proj_id = b.l_proj_id)
select d.c_proj_type,
       d.c_proj_type_n,
       d.c_func_type,
       d.c_func_type_n,
       d.c_affair_props,
       d.c_affair_props_n,
       count(*),
       round(sum(A.F_SCALE_AGG) / 10000, 4),
       sum(c.f_qs),
       round(sum(A.F_TRUST_PAY) / 10000, 4),
       round(sum(A.F_BENEFIC_INCOME) / 10000, 4),
       round(sum(a.f_trust_cost) / 10000, 4)
  from tt_po_rate_proj_d    a,
       dim_pb_project_basic b,
       temp_qs              c,
       dim_pb_project_biz   d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_proj_id
   and a.l_proj_id = c.l_proj_id
   and a.l_day_id = 20160831
   and nvl(b.l_expiry_date, '20991231') between 20160801 and 20160831
 group by d.c_proj_type,
          d.c_proj_type_n,
          d.c_func_type,
          d.c_func_type_n,
          d.c_affair_props,
          d.c_affair_props_n
 order by d.c_proj_type, d.c_func_type, d.c_affair_props;

-----------------------------------------------------------------兑付规模----------------------------------------------------------------
select t1.c_dept_name,
       t1.c_proj_code,
       t1.c_proj_name,
       t1.L_valuation_flag,
       t1.f_scale - nvl(t2.f_scale, 0)
  from (select e.c_dept_name,
               d.c_proj_code,
               d.c_proj_name,
               c.L_valuation_flag,
               sum(a.f_incurred_eot) as f_scale
          from tt_sr_scale_type_m   a,
               dim_sr_scale_type    b,
               dim_pb_project_biz   c,
               dim_pb_project_basic d,
               dim_pb_department    e
         where a.l_proj_id = c.l_proj_id
           and c.l_proj_id = d.l_proj_id
           and a.l_scatype_id = b.l_scatype_id
           and d.l_dept_id = e.l_dept_id
           and c.l_valuation_flag = 0
           and b.c_scatype_code = '03'
           and nvl(d.l_expiry_date, '20991231') >= 20160101
           and a.l_month_id = 201608
         group by e.c_dept_name,
                  d.c_proj_code,
                  d.c_proj_name,
                  c.L_valuation_flag) t1,
       (select e.c_dept_name,
               d.c_proj_code,
               d.c_proj_name,
               c.l_valuation_flag,
               sum(a.f_incurred_agg) as f_scale
          from tt_sr_scale_type_m   a,
               dim_sr_scale_type    b,
               dim_pb_project_biz   c,
               dim_pb_project_basic d,
               dim_pb_department    e
         where a.l_proj_id = c.l_proj_id
           and c.l_proj_id = d.l_proj_id
           and a.l_scatype_id = b.l_scatype_id
           and d.l_dept_id = e.l_dept_id
           and c.l_valuation_flag = 0
           and b.c_scatype_code = 'QS'
           and nvl(d.l_expiry_date, '20991231') between 20160101 and
               20160831
           and a.l_month_id = 201608
         group by e.c_dept_name,
                  d.c_proj_code,
                  d.c_proj_name,
                  c.l_valuation_flag) t2
 where t1.c_proj_code = t2.c_proj_code(+)
   and t1.c_dept_name = '资产管理一部'
order by t1.c_dept_name,t1.c_proj_code;

-----------------------------------------------------------------交易类规模变动----------------------------------------------------------------
select c.c_proj_code,c.c_proj_name,
round(sum(decode(b.c_scatype_code,'02',a.f_incurred_tot,0))/10000,2) as 申购, 
round(sum(decode(b.c_scatype_code,'03',a.f_incurred_tot,0))/10000,2) as 赎回
from tt_sr_scale_type_d a,dim_sr_scale_type b,dim_pb_project_basic c,dim_pb_project_biz d
where a.l_scatype_id = b.l_scatype_id 
and a.l_proj_id = c.l_proj_id 
and c.l_proj_id = d.l_proj_id 
and c.l_effective_flag = 1 
and d.l_valuation_flag = 1
and B.C_SCATYPE_CLASS = 'XTHTGM' 
and b.c_scatype_code in ('02','03') and a.f_incurred_tot <> 0
and  a.l_day_id >= 20161001 and  a.l_day_id <= 20161010
group by c.c_proj_code,c.c_proj_name;

-----------------------------------------------------------------收入结构----------------------------------------------------------------
--信托业务收入，按收入状态
select A.L_REVSTATUS_ID,sum(a.f_actual_eot)/10000 from tt_sr_tstrev_proj_m a,dim_pb_project_basic b 
where a.l_proj_id = b.l_proj_id 
and a.l_month_id >= substr(b.l_effective_date,1,6)
and a.l_month_id < substr(b.l_expiration_date, 1,6)
and a.l_month_id = 201606 group by A.L_REVSTATUS_ID;

--信托业务收入按项目类型
select c.c_proj_type_n,sum(a.f_planned_eot)/10000 from tt_sr_tstrev_proj_m a,dim_pb_project_basic b,dim_pb_project_biz c
where a.l_proj_id = b.l_proj_id 
and b.l_proj_id = C.L_PROJ_ID
and a.l_month_id >= substr(b.l_effective_date,1,6)
and a.l_month_id < substr(b.l_expiration_date, 1,6)
and a.l_month_id = 201606 
group by c.c_proj_type_n;

--信托业务收入按业务范围、项目类型、功能分类
select c.c_busi_scope_n,
       c.c_proj_type_n,
       c.c_func_type_n,
       round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201608
 group by c.c_busi_scope_n,
          c.c_proj_type_n,
          c.c_func_type_n having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_busi_scope_n, c.c_proj_type_n, c.c_func_type_n;

--信托业务收入按业务范围、项目类型、功能分类
select c.c_busi_scope, 
        c.c_busi_scope_n,
        c.c_proj_type,
       c.c_proj_type_n,
       c.c_func_type,
       c.c_func_type_n,
       c.c_affair_props,
       c.c_affair_props_n,
       round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201608
 group by c.c_busi_scope, c.c_busi_scope_n,
          c.c_proj_type,c.c_proj_type_n,
           c.c_func_type,c.c_func_type_n,
          c.c_affair_props,c.c_affair_props_n 
          having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_busi_scope, c.c_proj_type, c.c_func_type,c.c_affair_props;

--部门收入
select b.l_dept_id,
b.c_dept_name,
sum(decode(a.l_revstatus_id,2,a.f_actual_eot,0))/10000 as f_exist,
sum(decode(a.l_revstatus_id,1,a.f_actual_eot,0))/10000 as f_new
from tt_pe_dept_revenue_m a,dim_pb_department b 
where a.l_dept_id = b.l_dept_id 
and a.l_month_id = 201607
group by b.l_dept_id,b.c_dept_name
order by b.l_dept_id,b.c_dept_name;

-----------------------------------------------------------------直投银信----------------------------------------------------------------
--本年新增银信/直投个数
select s.c_proj_code,s.c_proj_name,s.l_setup_date,t.c_fdsrc_name,t.c_inst_name
  from (select a.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_scale_inst_d a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_pb_project_basic d
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_proj_id = d.l_proj_id
           and substr(d.l_setup_date,1,4) = 2016
           and a.l_day_id = 20160630
           and b.c_fdsrc_code like '11%'
           and c.c_inst_name like '%交通银行'
           /*and a.f_balance_eot > 0*/
           group by a.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.c_inst_name,s.c_proj_code;

--本年新增银信/直投规模，项目
select s.c_proj_code,s.c_proj_name,s.l_setup_date,t.c_fdsrc_name,t.c_inst_name,t.f_scale
  from (select a.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_scale_inst_d a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_pb_project_basic d
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_proj_id = d.l_proj_id
           and a.l_day_id = 20160630
           and b.c_fdsrc_code like '11%'
           and c.c_inst_name like '%交通银行'
           /*and a.f_balance_eot > 0*/
           and exists(select 1 from dim_sr_stage e,dim_pb_project_basic f 
                      where e.l_proj_id = f.l_proj_id 
                      and d.c_proj_code = f.c_proj_code 
                      and substr(e.l_setup_date,1,4) = 2016)
           group by a.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.c_inst_name,s.c_proj_code;

--本年新增银信/直投规模，期次
select s.c_proj_code,s.c_proj_name,s.l_setup_date,t.c_fdsrc_name,t.c_inst_name,t.f_scale
  from (select e.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_fdsrc_stage_d a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_sr_stage d,
               dim_pb_project_basic e
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_stage_id = d.l_stage_id
           and d.l_proj_id = e.l_proj_id
           and a.l_day_id = 20160630
           and b.c_fdsrc_code like '12%'
           and c.c_inst_name like '%交通银行%'
           /*and a.f_balance_eot > 0*/
           and substr(d.l_setup_date,1,4) = 2016
           group by e.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.c_inst_name,s.c_proj_code;

--存续个数规模
select s.c_proj_code,s.c_proj_name,s.l_expiry_date,t.c_fdsrc_name,t.c_inst_name,t.f_scale
  from (select a.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_scale_inst_d a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_pb_project_basic d
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_proj_id = d.l_proj_id
           and nvl(d.l_expiry_date,20991231) > 20160630
           and a.l_day_id = 20160630
           and b.c_fdsrc_code like '11%'
           /*and c.c_inst_name not like '%交通银行/
           /*and a.f_balance_eot > 0*/
           group by a.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.c_inst_name,s.c_proj_code;
   
--存续个数规模
select s.c_proj_code,s.c_proj_name,s.l_expiry_date,t.c_fdsrc_name,t.c_inst_name,t.f_scale
  from (select a.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_fdsrc_proj_m a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_pb_project_basic d
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_proj_id = d.l_proj_id
           and nvl(d.l_expiry_date,20991231) > 20161031
           and a.l_month_id = 201610
           and b.c_fdsrc_code like '12%'
           /*and c.c_inst_name not like '%交通银行/
           /*and a.f_balance_eot > 0*/
           group by a.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.c_inst_name,s.c_proj_code;
   
--合同资金来源
select b.c_cont_code,
       s.c_proj_code,
       s.c_proj_name,
       e.c_cust_name,
       c.c_fdsrc_name,
       d.c_inst_name,
       sum(t.f_scale)
  from tt_tc_scale_flow_d   t,
       dim_tc_contract      b,
       dim_pb_project_basic s,
       dim_tc_fund_source   c,
       dim_pb_institution   d,
       dim_ca_customer      e
 where t.l_cont_id = b.l_cont_id
   and b.l_proj_id = s.l_proj_id
   and b.l_settler_id = e.l_cust_id(+)
   and nvl(b.l_fdsrc_Id, 0) = c.l_fdsrc_id(+)
   and nvl(b.l_fdsrc_inst_id, 0) = d.l_inst_id(+)
   and s.c_proj_name like '%稳健1304号%'
   and t.l_change_date <= 20160831
   and b.l_expiration_date > 20160831
 group by b.c_cont_code,
          s.c_proj_code,
          s.c_proj_name,
          e.c_cust_name,
          c.c_fdsrc_name,
          d.c_inst_name
 order by s.c_proj_code,
          s.c_proj_name,
          e.c_cust_name,
          c.c_fdsrc_name,
          d.c_inst_name;

-----------------------------------------------------------------信托运营----------------------------------------------------------------
--存续项目资金运用方式明细
select c.c_proj_type_n,d.c_proj_code,d.c_proj_name,b.c_scatype_name,
sum(f_incurred_agg) as f_scale
from tt_sr_scale_type_m a ,dim_sr_scale_type b,dim_pb_project_biz c ,dim_pb_project_basic d
where a.l_proj_id = c.l_proj_id
and c.l_proj_id = d.l_proj_id
and a.l_scatype_id = b.l_scatype_id 
and b.c_scatype_class = 'ZJYYFS' 
and nvl(d.l_expiry_date,20991231) > 20160630
and a.l_month_id = 201606
group by c.c_proj_type_n,d.c_proj_code,d.c_proj_name,b.c_scatype_name having sum(f_incurred_agg) > 0
order by c.c_proj_type_n,d.c_proj_code,d.c_proj_name,b.c_scatype_name;

--存续项目资金运用方式明细
select c.c_proj_type_n,d.c_proj_code,d.c_proj_name,
round(sum(decode(b.c_scatype_code,'DK',a.f_incurred_agg,0))/10000,2) as f_dk,
round(sum(decode(b.c_scatype_code,'JYXJRZC',a.f_incurred_agg,0))/10000,2) as f_JYXJRZC,
round(sum(decode(b.c_scatype_code,'KGCS',a.f_incurred_agg,0))/10000,2) as f_KGCS,
round(sum(decode(b.c_scatype_code,'CQGQTZ',a.f_incurred_agg,0))/10000,2) as f_CQGQTZ,
round(sum(decode(b.c_scatype_code,'ZL',a.f_incurred_agg,0))/10000,2) as f_ZL,
round(sum(decode(b.c_scatype_code,'MRFS',a.f_incurred_agg,0))/10000,2) as f_MRFS,
round(sum(decode(b.c_scatype_code,'CC',a.f_incurred_agg,0))/10000,2) as f_CC,
round(sum(decode(b.c_scatype_code,'CFTY',a.f_incurred_agg,0))/10000,2) as f_CFTY,
round(sum(decode(b.c_scatype_code,'QTZJYYFS',a.f_incurred_agg,0))/10000,2) as f_QTZJYYFS
from tt_sr_scale_type_m a ,dim_sr_scale_type b,dim_pb_project_biz c ,dim_pb_project_basic d
where a.l_proj_id = c.l_proj_id
and c.l_proj_id = d.l_proj_id
and a.l_scatype_id = b.l_scatype_id 
and b.c_scatype_class = 'ZJYYFS' 
and nvl(d.l_expiry_date,20991231) > 20160831
and a.l_month_id = 201608
group by c.c_proj_type_n,d.c_proj_code,d.c_proj_name
order by c.c_proj_type_n,d.c_proj_code,d.c_proj_name;

--存续项目投向行业明细
select c.c_proj_type_n,d.c_proj_code,d.c_proj_name,b.c_scatype_name,
sum(f_incurred_agg) as f_scale
from tt_sr_scale_type_m a ,dim_sr_scale_type b,dim_pb_project_biz c ,dim_pb_project_basic d
where a.l_proj_id = c.l_proj_id 
and c.l_proj_id = d.l_proj_id
and a.l_scatype_id = b.l_scatype_id 
and b.c_scatype_class = 'TXHY' and nvl(d.l_expiry_date,20991231) > 20160630
and a.l_month_id = 201606
group by c.c_proj_type_n,d.c_proj_code,d.c_proj_name,b.c_scatype_name having sum(f_incurred_agg) > 0
order by c.c_proj_type_n,d.c_proj_code,d.c_proj_name,b.c_scatype_name;

	

--房地产
select b.c_proj_code,b.c_proj_name,e.c_invest_indus_n,c.c_scatype_name,a.f_incurred_agg
from tt_sr_scale_type_m a,dim_pb_project_basic b ,dim_sr_scale_type c,dim_pb_project_biz e
where a.l_proj_id = b.l_proj_id 
and a.l_scatype_id = c.l_scatype_id 
and c.c_scatype_class = 'TXHY' 
and b.l_proj_id = e.l_proj_id
and nvl(b.l_expiry_date,20991231) >=20160630 
and a.l_month_id = 201606 and a.f_incurred_agg > 0
and exists (select 1 from tt_sr_scale_type_m t where a.l_proj_id = t.l_proj_id and a.l_month_id = t.l_month_id and t.l_scatype_id = 1011 and t.f_incurred_agg > 0)
order by b.c_proj_code,b.c_proj_name,e.c_invest_indus_n,a.f_incurred_agg desc;

-----------------------------------------------------------------协同效应----------------------------------------------------------------
--中间业务收入
select c.c_revtype_name,sum(a.f_midrev_int_eot) from tt_ic_midrev_proj_m a,dim_pb_project_basic b,dim_sr_revenue_type c
where a.l_proj_id = b.l_proj_id 
and a.l_revtype_id = c.l_revtype_id
and substr(B.L_EFFECTIVE_DATE,1,6) <= A.L_MONTH_ID
and substr(B.L_EXPIRATION_DATE,1,6) > A.L_MONTH_ID
and a.l_month_id = 201606
group by c.c_revtype_name;

--无分行有中收
select c.c_proj_code, c.c_proj_name, sum(a.f_midrev_int_eot)
  from tt_ic_midrev_proj_m a, dim_pb_project_biz b, dim_pb_project_basic c
 where a.l_proj_id = b.l_proj_id(+)
   and b.l_proj_id = c.l_proj_id
   and b.l_bankrec_sub is null
   and a.l_month_id = 201608
   and substr(c.L_EFFECTIVE_DATE, 1, 6) <= A.L_MONTH_ID
   and substr(c.L_EXPIRATION_DATE, 1, 6) > A.L_MONTH_ID
 group by c.c_proj_code, c.c_proj_name
having sum(a.f_midrev_int_eot) <> 0;

--加上手工预计值
select a.c_item_code,a.c_item_name,B.F_ACTUAL
from dim_pb_budget_item a ,tt_pb_budget_y b
where A.L_ITEM_ID = B.L_ITEM_ID 
and A.C_ITEM_CODE in ('JYGS0011','JYGS0012','JYGS0013','JYGS0014')
and b.l_year_id = 2016;

--中间业务收入按部门
select d.l_dept_id,d.c_dept_Name,
round(sum(decode(c.c_revtype_name,'中间保管费',a.f_midrev_int_eot,0))/10000,2) 中间保管费,
round(sum(decode(c.c_revtype_name,'中间财顾费',a.f_midrev_int_eot,0))/10000,2) 中间财顾费,
round(sum(decode(c.c_revtype_name,'中间发行费',a.f_midrev_int_eot,0))/10000,2) 中间发行费,
round(sum(decode(c.c_revtype_name,'中间管理费',a.f_midrev_int_eot,0))/10000,2) 中间管理费
from tt_ic_midrev_proj_m a,dim_pb_project_basic b,dim_sr_revenue_type c,dim_pb_department d
where a.l_proj_id = b.l_proj_id 
and a.l_revtype_id = c.l_revtype_id
and b.l_dept_id = d.l_dept_id
and substr(B.L_EFFECTIVE_DATE,1,6) <= A.L_MONTH_ID
and substr(B.L_EXPIRATION_DATE,1,6) > A.L_MONTH_ID
and a.l_month_id = 201608
group by d.l_dept_id,d.c_dept_Name
order by d.l_dept_id,d.c_dept_Name
;

--某部门某类收入
select b.c_proj_code,
       b.c_proj_name,
       c.c_revtype_name,
       round(sum(a.f_midrev_int_eot) / 10000, 2)
  from tt_ic_midrev_proj_m  a,
       dim_pb_project_basic b,
       dim_sr_revenue_type  c,
       dim_pb_department    d
 where a.l_proj_id = b.l_proj_id
   and a.l_revtype_id = c.l_revtype_id
   and b.l_dept_id = d.l_dept_id
   and d.c_dept_name = '信托业务一部'
and substr(B.L_EFFECTIVE_DATE,1,6) <= A.L_MONTH_ID
and substr(B.L_EXPIRATION_DATE,1,6) > A.L_MONTH_ID
and a.l_month_id = 201608
and c.c_revtype_name = '中间保管费'
 group by b.c_proj_code, b.c_proj_name, c.c_revtype_name
having sum(a.f_midrev_int_eot) <> 0;

--单个项目中间业务收入流水
select b.c_proj_code,b.c_proj_name,c.c_revtype_name,a.* from tt_ic_revenue_flow_d a ,dim_pb_project_basic b,dim_sr_revenue_type c 
where a.l_proj_id = b.l_proj_id 
and a.l_revtype_id = c.l_revtype_id
and b.c_proj_code = 'EA42'
order by c.c_revtype_name, l_revdate_id;

--分行收入
with temp_fdsrc as (
select row_number()over(partition by c.c_proj_code 
                        order by a.l_fdsrc_id,case when b.c_fdsrc_code like '11%' and d.c_inst_name ='交通银行' then '1直投' when b.c_fdsrc_code like '12%' and d.c_inst_name ='交通银行' then '2理财' else '3其他' end desc) as l_rn,
c.c_proj_code ,
case when b.c_fdsrc_code like '11%' and d.c_inst_name ='交通银行' then '1直投' when b.c_fdsrc_code like '12%' and d.c_inst_name ='交通银行' then '2理财' else '3其他' end as c_fdsrc_name
from tt_tc_scale_inst_d a,dim_tc_fund_source b,dim_pb_project_basic c,dim_pb_institution d
where 
a.l_fdsrc_id = b.l_fdsrc_id 
and a.l_proj_id = c.l_proj_id and a.l_fdsrc_inst_id = d.l_inst_id(+)
and a.l_day_id = 20160831
),
temp_actual_year as (select b.c_proj_code,sum(a.f_actual_tot) as f_actual_year
from tt_sr_tstrev_proj_m a,dim_pb_project_basic b 
where a.l_proj_id = b.l_proj_id 
and a.l_month_id >= substr(b.l_effective_date,1,6)
and a.l_month_id < substr(b.l_expiration_date, 1,6)
and substr(a.l_month_id,1,4) = 2016 and a.l_month_Id <= 201608
group by b.c_proj_code,b.c_proj_name),
temp_planned_year as (select b.c_proj_code,sum(a.f_planned_eot) as f_planned_year
from tt_sr_tstrev_proj_m a,dim_pb_project_basic b 
where a.l_proj_id = b.l_proj_id 
and a.l_month_id >= substr(b.l_effective_date,1,6)
and a.l_month_id < substr(b.l_expiration_date, 1,6)
and a.l_month_id = 201608
group by b.c_proj_code)
select d.c_fdsrc_name,c.c_inst_name,a.c_proj_code ,a.c_proj_name,sum(e.f_actual_year)
from dim_pb_project_basic a ,dim_pb_project_biz b,dim_pb_institution c,temp_fdsrc d,temp_actual_year e,temp_planned_year f
where b.l_bankrec_sub = c.l_inst_id
and a.l_proj_id = b.l_proj_id
--and nvl(A.L_EXPIRY_DATE,20991231) >= 20160101
and a.l_effective_flag = 1
and a.c_proj_code = d.c_proj_code 
and d.l_rn = 1
and a.c_proj_code = e.c_proj_code
and a.c_proj_code = f.c_proj_code
group by d.c_fdsrc_name, c.c_inst_name,a.c_proj_code ,a.c_proj_name
order  by d.c_fdsrc_name,c.c_inst_name, a.c_proj_code ,a.c_proj_name;

--项目资金来源明细
select row_number()over(partition by c.c_proj_code order by case when b.c_fdsrc_code like '11%' then '1直投 when b.c_fdsrc_code like '12%' then '2理财 else '3其他 end desc) as l_rn,
c.c_proj_code ,
case when b.c_fdsrc_code like '11%' then '1直投 when b.c_fdsrc_code like '12%' then '2理财 else '3其他 end as c_fdsource_name
from tt_tc_scale_inst_d a,dim_tc_fund_source b,dim_pb_project_basic c
where 
a.l_fdsrc_id = b.l_fdsrc_id 
and a.l_proj_id = c.l_proj_id
and C.C_PROJ_CODE = 'G224'
and a.l_day_id = 20160630;



-----------------------------------------------------------------部门变更	----------------------------------------------------------------
select t.c_proj_code,
       t.c_proj_name,
       c.c_dept_name,
       d.c_dept_name,
       t.l_effective_date
  from dim_pb_project_basic t,
       (select *
          from dim_pb_project_basic s
         where s.l_effective_flag = 0
           and substr(S.L_EXPIRATION_DATE, 1, 6) = 201606) b,
       dim_pb_department c,
       dim_pb_department d
 where substr(t.l_effective_date, 1, 6) = 201606
   and t.l_effective_flag = 1
   and t.l_dept_id = c.l_dept_id
   and b.l_dept_id = d.l_dept_id
   and t.c_proj_code = b.c_proj_code
   and t.l_dept_id <> b.l_dept_id;	

-----------------------------------------------------------------非银信明细------------------------------------------------------------   
--不存在银信、直投施罗德   
SELECT sum(F_VALUE)
  FROM (SELECT b.c_proj_code,
               b.c_proj_name,
               round(sum(A.F_ACTUAL_EOT) / 10000, 2) AS F_VALUE
          FROM TT_SR_TSTREV_PROJ_M  A,
               DIM_PB_PROJECT_BASIC B,
               DIM_PB_PROJECT_BIZ   C
         WHERE A.L_PROJ_ID = B.L_PROJ_ID
           AND B.L_PROJ_ID = C.L_PROJ_ID
           AND SUBSTR(B.L_EFFECTIVE_DATE, 1, 6) <= A.L_MONTH_ID
           AND SUBSTR(B.L_EXPIRATION_DATE, 1, 6) > A.L_MONTH_ID
           AND B.C_PROJ_CODE <> 'E942'
           AND C.C_BUSI_SCOPE <> '3'
           and not exists
         (select 1
                  from tt_tc_fdsrc_proj_m   d,
                       dim_pb_project_basic e,
                       dim_tc_fund_source   f
                 where d.l_proj_id = e.l_proj_id
                   and d.l_fdsrc_id = f.l_fdsrc_id
                   and (f.c_fdsrc_code like '12%' or f.c_fdsrc_code = '113')
                   and b.c_proj_code = e.c_proj_code
                   and d.l_month_id = 201611)
           AND A.L_MONTH_ID = 201611
         group by b.c_proj_code, b.c_proj_name
        UNION ALL
        SELECT b.c_proj_code,
               b.c_proj_name,
               round(SUM(A.F_ACTUAL_EOT) / 10000, 2) AS F_VALUE
          FROM TT_SR_TSTREV_PROJ_M  A,
               DIM_PB_PROJECT_BASIC B,
               DIM_PB_PROJECT_BIZ   C
         WHERE A.L_PROJ_ID = B.L_PROJ_ID
           AND B.L_PROJ_ID = C.L_PROJ_ID
           AND SUBSTR(B.L_EFFECTIVE_DATE, 1, 6) <= A.L_MONTH_ID
           AND SUBSTR(B.L_EXPIRATION_DATE, 1, 6) > A.L_MONTH_ID
           AND (B.C_PROJ_CODE = 'E942' OR C.C_BUSI_SCOPE = '3')
           AND A.L_MONTH_ID = 201611
         group by b.c_proj_code, b.c_proj_name); 
        
--估值类项目            
SELECT b.c_proj_code,b.c_proj_name,SUM(A.F_ACTUAL_EOT) 
        FROM TT_SR_TSTREV_PROJ_M A,
               DIM_PB_PROJECT_BASIC B,
               DIM_PB_PROJECT_BIZ   C
         WHERE A.L_PROJ_ID = B.L_PROJ_ID
           AND B.L_PROJ_ID = C.L_PROJ_ID
           AND SUBSTR(B.L_EFFECTIVE_DATE,1,6) <= A.L_MONTH_ID
           AND SUBSTR(B.L_EXPIRATION_DATE,1,6) > A.L_MONTH_ID
           AND (B.C_PROJ_CODE = 'E942' OR C.C_BUSI_SCOPE = '3')
           AND B.L_EFFECTIVE_FLAG = 1
           AND A.L_MONTH_ID = 201606 
           group by b.c_proj_code,b.c_proj_name having sum(A.F_ACTUAL_EOT) <> 0;        
        
-----------------------------------------------------------------解决集团融资规模------------------------------------------------------------
--联动融资规模，本年新成立+往年二期
SELECT b.c_proj_code,b.c_proj_name,SUM(A.F_INCREASE_EOT) AS F_VALUE
  FROM TT_SR_SCALE_PROJ_M A, DIM_PB_PROJECT_BASIC B, DIM_PB_PROJECT_BIZ C
 WHERE A.L_PROJ_ID = B.L_PROJ_ID 
   AND B.L_PROJ_ID = C.L_PROJ_ID
   AND A.L_MONTH_ID >= SUBSTR(B.L_EFFECTIVE_DATE,1,6)
   AND A.L_MONTH_ID < SUBSTR(B.L_EXPIRATION_DATE,1,6)
   AND C.L_GRPREC_FLAG = 1 AND C.L_BANLKREC_SUB IS NOT NULL   
   AND (C.C_FUNC_TYPE = '1' OR
       (C.C_FUNC_TYPE = '3' AND C.C_AFFAIR_PROPS = '1'))
   AND EXISTS (SELECT 1
          FROM DIM_SR_STAGE D,DIM_PB_PROJECT_BASIC E
         WHERE E.L_PROJ_ID = D.L_PROJ_ID
           AND B.C_PROJ_CODE = E.C_PROJ_CODE
           AND D.L_EFFECTIVE_FLAG = 1
           AND SUBSTR(D.L_SETUP_DATE, 1, 4) = 2016)
   AND A.L_MONTH_ID = 201608
   group by b.c_proj_code,b.c_proj_name 
   order by b.c_proj_code,b.c_proj_name;

--查询项目是否集团推荐，功能分类，事务性质
select t.c_proj_code,s.l_proj_id,s.l_grprec_flag,s.c_func_type,s.c_func_type_n,s.c_affair_props,s.c_affair_props_n 
from dim_pb_project_basic t,dim_pb_project_biz s 
where t.l_proj_id = s.l_proj_id 
and t.c_proj_name like '%稳健643%';

--联动融资规模统计个数，本年成立的项目，往年二期不算
SELECT b.c_proj_code,b.c_proj_name,d.c_inst_name,SUM(A.F_INCREASE_EOT) AS F_VALUE
  FROM TT_SR_SCALE_PROJ_M A, DIM_PB_PROJECT_BASIC B, DIM_PB_PROJECT_BIZ C,dim_pb_institution d
 WHERE A.L_PROJ_ID = B.L_PROJ_ID 
   AND B.L_PROJ_ID = C.L_PROJ_ID
  and c.l_bankrec_sub= d.l_inst_id
   AND A.L_MONTH_ID >= SUBSTR(B.L_EFFECTIVE_DATE,1,6)
   AND A.L_MONTH_ID < SUBSTR(B.L_EXPIRATION_DATE,1,6)
   AND C.L_GRPREC_FLAG = 1
   AND (C.C_FUNC_TYPE = '1' OR
       (C.C_FUNC_TYPE = '3' AND C.C_AFFAIR_PROPS = '1'))
   AND EXISTS (SELECT 1
          FROM DIM_SR_STAGE D,DIM_PB_PROJECT_BASIC E
         WHERE E.L_PROJ_ID = D.L_PROJ_ID
           AND B.C_PROJ_CODE = E.C_PROJ_CODE
           AND D.L_EFFECTIVE_FLAG = 1
           AND SUBSTR(D.L_SETUP_DATE, 1, 4) = 2016)
   AND A.L_MONTH_ID = 201611
   --and b.l_setup_date >= 20160101
   group by b.c_proj_code,b.c_proj_name,d.c_inst_name 
   order by b.c_proj_code,b.c_proj_name,d.c_inst_name;

-----------------------------------------------------------------部门规模------------------------------------------------------------
select b.l_dept_id, b.c_dept_name, sum(a.f_balance_eot)
  from tt_sr_scale_proj_m a, dim_pb_department b,dim_pb_project_basic c
 where c.l_dept_id = b.l_dept_id and a.l_proj_id = c.l_proj_id
   and a.l_month_id = 201606 
   and a.l_month_id >= substr(c.l_effective_date,1,6)
and a.l_month_id < substr(c.l_expiration_date, 1,6)
 group by b.l_dept_id, b.c_dept_name
 order by b.l_dept_id, b.c_dept_name;
 
--月中部门变更情况
with temp_dept_change as
 (select a.l_proj_id,
         a.c_proj_code,
         a.c_proj_name,
         a.l_dept_id,
         b.c_dept_name,
         decode(a.l_effective_flag, 1, e.f_balance_eot, -1 * e.f_balance_eot) as f_balance_eot
    from dim_pb_project_basic a,
         dim_pb_department b,
         (select c_proj_code, l_dept_id, l_expiration_date
            from dim_pb_project_basic
           where substr(l_expiration_date, 1, 6) = 201608) c,
         (select c_proj_code, l_dept_id, l_effective_date
            from dim_pb_project_basic
           where substr(l_effective_date, 1, 6) = 201608) d,
         tt_sr_scale_proj_m e
   where a.l_dept_id = b.l_dept_id
     and a.c_proj_code = c.c_proj_code
     and a.c_proj_code = d.c_proj_code
     and c.l_dept_id <> d.l_dept_id
     and a.l_proj_id = e.l_proj_id
     and e.l_month_id = 201608
     and a.l_expiration_date >= 20160801),
--上月末部门规模
temp_dept_actual as
 (select a.l_dept_id,
         count(distinct case
                 when substr(nvl(a.l_expiry_date, 20991231), 1, 6) > t.l_month_id then
                  t.l_proj_id
                 else
                  null
               end) as l_count,
         sum(t.f_balance_eot) as f_exist
    from tt_sr_scale_proj_m t, dim_pb_project_basic a, dim_pb_currency b
   where t.l_proj_id = a.l_proj_id
     and a.l_cy_id = b.l_cy_id
     and t.l_month_id =
         to_char(add_months(To_Date('31-08-2016', 'dd-mm-yyyy'), -1),
                 'yyyymm')
     and substr(a.l_effective_date, 1, 6) <= t.l_month_id
     and substr(a.l_expiration_date, 1, 6) > t.l_month_id
     and b.c_cy_code = 'CNY'
   group by a.l_dept_id)
select temp_dept_actual.l_dept_id,
       temp_dept_actual.l_count,
       temp_dept_actual.f_exist + nvl(temp_dept_change.f_balance_eot, 0) as f_exist
  from temp_dept_actual, temp_dept_change
 where temp_dept_actual.l_dept_id = temp_dept_change.l_dept_id(+)

 
-----------------------------------------------------------------部门收入	------------------------------------------------------------ 
select T.L_OBJECT_ID, S.C_PROJ_CODE, s.c_proj_name, sum(t.f_actual_eot)
  from tt_pe_revenue_stage_m t, dim_pb_project_basic s
 where t.l_proj_id = s.l_proj_id
   and s.l_effective_flag = 1
   and t.l_object_id = 10
   and t.l_month_id = 201606 
   group by  T.L_OBJECT_ID, S.C_PROJ_CODE, s.c_proj_name having sum(t.f_actual_eot) <> 0 ;
   
--部门月初规模，需要将月中调整的项目反馈进去   
select a.l_proj_id,a.c_proj_code,a.c_proj_name,b.c_dept_name,decode(a.l_effective_flag,1,e.f_balance_eot,-1*e.f_balance_eot) as f_balance_eot
from dim_pb_project_basic a,
dim_pb_department b,
(select c_proj_code,l_dept_id,l_expiration_date from dim_pb_project_basic where substr(l_expiration_date,1,6) = 201608 ) c,
(select c_proj_code,l_dept_id,l_effective_date from dim_pb_project_basic where substr(l_effective_date,1,6) = 201608 ) d,
tt_sr_scale_proj_m e
where a.l_dept_id = b.l_dept_id
and a.c_proj_code = c.c_proj_code
and a.c_proj_code = d.c_proj_code 
and c.l_dept_id <> d.l_dept_id
and a.l_proj_id = e.l_proj_id
and e.l_month_id = 201608
and a.l_expiration_date >= 20160801;

-----------------------------------------------------------------明细规模	------------------------------------------------------------ 
select c.c_proj_code,c.c_proj_Name,round(sum(a.f_incurred_eot)/100000000,4) 
from tt_sr_scale_type_m a,dim_pb_project_biz b ,dim_pb_project_basic c
where a.l_proj_id = b.l_proj_id and b.l_proj_id = c.l_proj_id
and b.l_valuation_flag = 1 
and  a.l_Month_id = 201607
and a.l_scatype_id = 2
group by c.c_proj_code,c.c_proj_Name 
order by c.c_proj_code,c.c_proj_Name;

select distinct t.c_proj_code,wmsys.wm_concat(t.c_fdsrc_name)over(partition by  t.c_proj_code order by t.l_fdsrc_id) from (
select s.c_proj_code,c.l_fdsrc_id,C.C_FDSRC_NAME,round(sum(t.f_scale)/10000,2)
from tt_tc_scale_flow_d t ,dim_tc_contract b,dim_pb_project_basic s ,dim_tc_fund_source c
where t.l_cont_id = b.l_cont_id 
and b.l_proj_id = s.l_proj_id
and nvl(b.l_fdsrc_Id,0) = c.l_fdsrc_id(+)
and t.l_change_date <= 20160930
and b.l_expiration_date >20160930
group by s.c_proj_code,c.l_fdsrc_id,C.C_FDSRC_NAME ) t;


-----------------------------------------------------------------调整后部门规模------------------------------------------------------------
--年初存续
select t3.c_dept_code,t3.c_dept_name,round(sum(t1.f_Scale_boy)/100000000,2)
from tt_pe_scale_type_m t1,dim_pb_project_basic t2,dim_pb_department t3
where t1.l_proj_id = t2.l_proj_id
and t1.l_object_id = t3.l_dept_id
and t1.l_month_id >= substr(t2.l_effective_date,1,6)
and t1.l_month_id < substr(t2.l_expiration_date, 1,6) and T1.L_MONTH_ID = 201610 and t1.l_scatype_id < 10
group by t3.c_dept_code,t3.c_dept_name order by t3.c_dept_code;

--新增规模
select t4.c_dept_code,t4.c_dept_name,
round(sum(case when t3.l_valuation_flag = 1 and t5.c_scatype_code = '02' then 0 else t1.f_scale_eot end)/100000000,2) as 本年新增规模 
from tt_pe_scale_type_m t1,dim_pb_project_basic t2,dim_pb_project_biz t3,dim_pb_department t4,dim_sr_scale_type t5
where t1.l_proj_id = t2.l_proj_id
and t2.l_proj_id = t3.l_proj_id
and t1.l_object_id = t4.l_dept_id
and t1.l_scatype_id = t5.l_scatype_id
and t5.c_scatype_code in ('50','02')  
and t1.l_month_id >= substr(t2.l_effective_date,1,6)
and t1.l_month_id < substr(t2.l_expiration_date, 1,6) 
and T1.L_MONTH_ID = 201610
group by t4.c_dept_code,t4.c_dept_name order by t4.c_dept_code;

--申购赎回
select t4.c_dept_code,t4.c_dept_name,
round(sum(case when t5.c_scatype_code in ('02','70') then t1.f_scale_eot else 0 end)/100000000,2) as 本年申购规模, 
round(sum(case when t5.c_scatype_code in ('03','71') then t1.f_scale_eot else 0 end)/100000000,2) as 本年赎回规模
from tt_pe_scale_type_m t1,dim_pb_project_basic t2,dim_pb_project_biz t3,dim_pb_department t4,dim_sr_scale_type t5
where t1.l_proj_id = t2.l_proj_id
and t2.l_proj_id = t3.l_proj_id
and t1.l_object_id = t4.l_dept_id
and t1.l_scatype_id = t5.l_scatype_id
and t5.c_scatype_code in( '02','03','70','71')
and t3.l_valuation_flag = 1
and t1.l_month_id >= substr(t2.l_effective_date,1,6)
and t1.l_month_id < substr(t2.l_expiration_date, 1,6) 
and T1.L_MONTH_ID = 201610
group by t4.c_dept_code,t4.c_dept_name order by t4.c_dept_code;

--清算规模
select t4.c_dept_code,t4.c_dept_name,
round(sum(t1.f_scale_eot)/100000000,2) as 本年清算规模 
from tt_pe_scale_type_m t1,dim_pb_project_basic t2,dim_pb_project_biz t3,dim_pb_department t4,dim_sr_scale_type t5
where t1.l_proj_id = t2.l_proj_id
and t2.l_proj_id = t3.l_proj_id
and t1.l_object_id = t4.l_dept_id
and t1.l_scatype_id = t5.l_scatype_id
and t5.c_scatype_code in( '03')
and nvl(t2.l_expiry_date,209912331) between 20160101 and 20161031
and t1.l_month_id >= substr(t2.l_effective_date,1,6)
and t1.l_month_id < substr(t2.l_expiration_date, 1,6)
and T1.L_MONTH_ID = 201610
group by t4.c_dept_code,t4.c_dept_name order by t4.c_dept_code;

--兑付规模
select a.c_dept_code,sum(-a-nvl(b,0)) from (
select t2.c_proj_code,t4.c_dept_code,
round(sum(t1.f_scale_eot)/100000000,2) as a 
from tt_pe_scale_type_m t1,dim_pb_project_basic t2,dim_pb_project_biz t3,dim_pb_department t4,dim_sr_scale_type t5
where t1.l_proj_id = t2.l_proj_id
and t2.l_proj_id = t3.l_proj_id
and t1.l_object_id = t4.l_dept_id
and t1.l_scatype_id = t5.l_scatype_id and t3.l_valuation_flag = 0
and t5.c_scatype_code in( '03','71')
and t1.l_month_id >= substr(t2.l_effective_date,1,6)
and t1.l_month_id < substr(t2.l_expiration_date, 1,6)
and T1.L_MONTH_ID = 201610 --and t4.c_dept_code = '0_80'
group by t2.c_proj_code,t4.c_dept_code)a,
(
select t2.c_proj_code,t4.c_dept_code,
round(sum(t1.f_scale_eot)/100000000,2) as b 
from tt_pe_scale_type_m t1,dim_pb_project_basic t2,dim_pb_project_biz t3,dim_pb_department t4,dim_sr_scale_type t5
where t1.l_proj_id = t2.l_proj_id
and t2.l_proj_id = t3.l_proj_id
and t1.l_object_id = t4.l_dept_id
and t1.l_scatype_id = t5.l_scatype_id and t3.l_valuation_flag = 0
and t5.c_scatype_code in( 'QS')
and nvl(t2.l_expiry_date,209912331) between 20160101 and 20161031
and t1.l_month_id >= substr(t2.l_effective_date,1,6)
and t1.l_month_id < substr(t2.l_expiration_date, 1,6) --and  t4.c_dept_code = '0_80'
and T1.L_MONTH_ID = 201610
group by t2.c_proj_code,t4.c_dept_code) b where a.C_proj_code = b.c_proj_code(+) group by a.c_dept_code order by a.c_dept_code;

--存续规模
select t4.c_dept_code,t4.c_dept_name,
round(sum(t1.f_scale_agg)/100000000,2) as 本年存续规模 
from tt_pe_scale_type_m t1,dim_pb_project_basic t2,dim_pb_project_biz t3,dim_pb_department t4,dim_sr_scale_type t5
where t1.l_proj_id = t2.l_proj_id
and t2.l_proj_id = t3.l_proj_id
and t1.l_object_id = t4.l_dept_id
and t1.l_scatype_id = t5.l_scatype_id
and t5.c_scatype_class = 'XTHTGM'
and t1.l_month_id >= substr(t2.l_effective_date,1,6)
and t1.l_month_id < substr(t2.l_expiration_date, 1,6)
and T1.L_MONTH_ID = 201610
group by t4.c_dept_code,t4.c_dept_name order by t4.c_dept_code;

--行外机构资金变动
select s.c_proj_code,s.c_proj_name,c.c_fdsrc_name,d.c_inst_name,round(sum(t.f_scale)/10000,2)
from tt_tc_scale_flow_d t ,dim_tc_contract b,dim_pb_project_basic s ,dim_tc_fund_source c,dim_pb_institution d
where t.l_cont_id = b.l_cont_id 
and b.l_proj_id = s.l_proj_id 
and nvl(b.l_fdsrc_Id,0) = c.l_fdsrc_id(+)
and nvl(b.l_fdsrc_inst_id,0) = d.l_inst_id(+)
and t.l_change_date between 20161201 and 20161209
group by s.c_proj_code,s.c_proj_name,c.c_fdsrc_name,d.c_inst_name
order by s.c_proj_code,s.c_proj_name,c.c_fdsrc_name,d.c_inst_name;

--项目关键要素
select a.c_proj_code,
       a.c_proj_name,
       a.l_setup_date,
       a.l_preexp_date,
       a.l_expiry_date,
       a.c_proj_phase_n,
       a.c_proj_status_n,
       c.c_dept_name,
       c.c_dept_cate_n,
       b.c_manage_type_n,
       b.c_proj_type_n,
       b.c_func_type_n,
       b.c_special_type_n
  from dim_pb_project_basic a, dim_pb_project_biz b, dim_pb_department c
 where a.l_proj_id = b.l_proj_id
   and a.l_dept_id = c.l_dept_id
   and a.l_effective_flag = 1
   order by a.c_proj_phase;

--存续项目规模-按部门
select c.c_dept_cate_n,c.c_dept_name, sum(b.f_balance_agg)
  from dim_pb_project_basic   a,
       tt_to_operating_book_m b,
       dim_pb_department      c
 where a.l_proj_id = b.l_proj_id
   and a.l_dept_id = c.l_dept_id
   and b.l_month_id = 201611
   and b.f_balance_agg <> 0
   and a.l_effective_flag = 1
   and c.c_dept_cate = '04'--中后台业务部门
 group by c.c_dept_cate_n,c.c_dept_name;

--创新项目个数,规模
select b.c_special_type_n, count(*), sum(c.f_balance_agg) / 100000000
  from dim_pb_project_basic   a,
       dim_pb_project_biz     b,
       tt_to_operating_book_m c
 where a.l_proj_id = b.l_proj_id
   and a.l_proj_id = c.l_proj_id
   and c.l_month_id = 201611
   and a.l_effective_flag = 1
   and nvl(b.c_special_type, '99') <> '99'
 group by b.c_special_type_n;

--公司年度指标预算值
select a.c_item_code,a.c_item_name, b.*
  from dim_pb_budget_item a, tt_pb_budget_y b
 where a.l_item_id = b.l_item_id
   and b.l_year_id = 2016;


--备份
--信托资产类型
select t.c_status, count(t.l_count), sum(t.)
  from tt_project_summary t
 where t.l_dayid = to_number(to_char(trunc(sysdate), 'YYYYMMDD'))
 group by t.c_status;

--信托资产类型核对
Select a.l_monthid,
       b.c_projecttype,
       b.c_projecttypename,
       Sum(Case
             When a.f_balance_scale > 0 Then
              1
             Else
              0
           End) As f_count_exists,--存续个数
       Sum(a.f_balance_scale) As f_exists_scale,
       Sum(Case
             When a.f_new_inc_scale > 0 Then
              1
             Else
              0
           End) As f_count_new,
       Sum(a.f_new_inc_scale) As f_new_scale,
       Sum(Case
             When a.f_clear_scale > 0 Then
              1
             Else
              0
           End) As f_count_clear,
       Sum(a.f_clear_scale) As f_clear_scale,
       Sum(Case
             When a.f_clear_scale > 0 and
                 a.f_balance_scale = 0 Then
              1
             Else
              0
           End) As f_count_end,
       Sum(Case
             When a.f_clear_scale > 0 and
                  a.f_balance_scale = 0 Then
              a.f_clear_scale
             Else
              0
           End) As f_clear_end
  From tt_project_monthly a, dim_projectinfo b
 Where a.l_projectid = b.l_projectid
   And b.c_intrustflag = '1'
   And a.l_monthid = 201605
 Group By a.l_monthid, b.c_projecttype, b.c_projecttypename
 Order By a.l_monthid, b.c_projecttype, b.c_projecttypename;

--信托资产功能分类核对
Select a.l_monthid,
       b.c_funtype,
       b.c_funtypename,
       Sum(Case
             When a.f_balance_scale > 0 Then
              1
             Else
              0
           End) As f_count_exists,
       Sum(a.f_balance_scale) As f_exists_scale,
       Sum(Case
             When a.f_new_inc_scale > 0 Then
              1
             Else
              0
           End) As f_count_new,
       Sum(a.f_new_inc_scale) As f_new_scale,
       Sum(Case
             When a.f_clear_scale > 0 Then
              1
             Else
              0
           End) As f_count_clear,
       Sum(a.f_clear_scale) As f_clear_scale,
       Sum(Case
             When a.f_clear_scale > 0 and
                  a.f_balance_scale = 0 Then
              1
             Else
              0
           End) As f_count_end,
       Sum(Case
             When a.f_clear_scale > 0 and
                  a.f_balance_scale = 0 Then
              a.f_clear_scale
             Else
              0
           End) As f_clear_end
  From tt_project_monthly a, dim_projectinfo b
 Where a.l_projectid = b.l_projectid
   And b.c_intrustflag = '1'
   And a.l_monthid = 201605
 Group By a.l_monthid, b.c_funtype, b.c_funtypename
 Order By a.l_monthid, b.c_funtype, b.c_funtypename;

--项目信息明细
with temp_scale as
 (select t1.l_proj_id,
         t1.f_increase_eot,
         t1.f_decrease_eot,
         t1.f_balance_eot
    from tt_sr_scale_proj_m t1, dim_pb_project_basic t2
   where t1.l_proj_id = t2.l_proj_id
     and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
     and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
     and t1.l_month_id = 201609),
temp_revenue as
 (select t1.l_proj_id,
         sum(case when t1.l_revtype_id = 2 and t1.l_revstatus_id = 1 then t1.f_actual_eot else 0 end) as f_new_xtbc,
         sum(case when t1.l_revtype_id = 2 and t1.l_revstatus_id = 2 then t1.f_actual_eot else 0 end) as f_exist_xtbc,
         sum(case when t1.l_revtype_id = 4 and t1.l_revstatus_id = 1 then t1.f_actual_eot else 0 end) as f_new_xtcgf,
         sum(case when t1.l_revtype_id = 4 and t1.l_revstatus_id = 2 then t1.f_actual_eot else 0 end) as f_exist_xtcgf
    from tt_sr_tstrev_proj_m t1, dim_pb_project_basic t2
   where t1.l_proj_id = t2.l_proj_id
     and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
     and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
     and t1.l_month_id = 201609
   group by t1.l_proj_id),
temp_fa as
 (select t1.l_proj_id, t1.f_scale_eot,t1.f_scale_agg
    from tt_po_rate_proj_d t1, dim_pb_project_basic t2
   where t1.l_proj_id = t2.l_proj_id
     and t2.l_effective_flag = 1
     and t1.l_day_id = 20160930)
select a.c_proj_code as 项目编码,
       a.c_proj_name as 项目名称,
       c.c_dept_name as 信托部门,
       g.c_emp_name  as 信托经理
       a.c_proj_phase_n as 项目阶段,
       a.c_proj_status_n as 项目状态,
       a.l_setup_date as 成立日期,
       a.l_preexp_date as 预到期日期,
       a.l_expiry_date as 结束日期,
       b.c_busi_scope_n as 业务范围,
       b.c_proj_type_n as 项目类型,
       --b.c_property_type_n as 项目财产权类型,
       b.c_func_type_n as 功能类型,
       --b.c_coop_type_n as 合作类型,
       b.c_trust_type_n as 信托类型,
       b.c_manage_type_n as 管理方式,
       a.c_operating_way_n as 运行方式,
       b.c_special_type_n as 特殊业务类型,
       b.c_fduse_way_n as 资金运用方式,
       b.c_invest_indus_n as 投向行业,
       b.c_invest_dir_n as 投资方向,
       --b.c_invest_way_n as 投资方式,
       d.f_increase_eot as 本年新增规模,
       d.f_decrease_eot as 本年减少规模,
       d.f_balance_eot as 当前存续规模,
       f.f_scale_eot as FA存续信托规模,
       f.f_scale_agg as FA累计实收信托规模,
       e.f_new_xtbc as 新增信托报酬,
       e.f_exist_xtbc as 存续信托报酬,
       e.f_new_xtbc + e.f_exist_xtbc as 本年信托报酬,
       e.f_new_xtcgf as 新增信托财顾费,
       e.f_exist_xtcgf as 存续信托财顾费,
       e.f_new_xtcgf + e.f_exist_xtcgf as 本年信托财顾费
  from dim_pb_project_basic a,
       dim_pb_project_biz   b,
       dim_pb_department    c,
       temp_scale           d,
       temp_revenue         e,
       temp_fa              f,
       dim_pb_employee      g
 where a.l_proj_id = b.l_proj_id
   and a.l_dept_id = c.l_dept_id
   and a.l_tstmgr_id = g.l_emp_id
   and a.l_proj_id = d.l_proj_id(+)
   and a.l_proj_id = e.l_proj_id(+)
   and a.l_proj_id = f.l_proj_id(+)
   and a.l_effective_flag = 1
 order by a.l_setup_date;

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

