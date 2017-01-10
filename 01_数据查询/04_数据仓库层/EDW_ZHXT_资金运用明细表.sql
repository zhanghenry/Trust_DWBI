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