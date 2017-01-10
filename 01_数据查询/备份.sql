 
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


/********************************************************************************************************************************************/


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
   
--存续规模合计
select sum(a.f_balance_eot) / 100000000
  from tt_sr_scale_proj_m a, dim_pb_project_biz b, dim_pb_project_basic c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_month_id >= substr(c.l_effective_date, 1, 6)
   and a.l_month_id < substr(c.l_expiration_date, 1, 6)
   and a.l_month_id = 201606
   and nvl(c.l_expiry_date, '20991231') > 20160630;

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

--清算规模
select t4.c_dept_code,
       t4.c_dept_name,
       round(sum(t1.f_scale_eot) / 100000000, 2) as 本年清算规模
  from tt_pe_scale_type_m   t1,
       dim_pb_project_basic t2,
       dim_pb_project_biz   t3,
       dim_pb_department    t4,
       dim_sr_scale_type    t5
 where t1.l_proj_id = t2.l_proj_id
   and t2.l_proj_id = t3.l_proj_id
   and t1.l_object_id = t4.l_dept_id
   and t1.l_scatype_id = t5.l_scatype_id
   and t5.c_scatype_code in ('03')
   and nvl(t2.l_expiry_date, 209912331) between 20160101 and 20161031
   and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
   and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
   and T1.L_MONTH_ID = 201610
 group by t4.c_dept_code, t4.c_dept_name
 order by t4.c_dept_code;

--申购赎回
select t4.c_dept_code, t4.c_dept_name,
round(sum(case when t5.c_scatype_code in ('02','70') then t1.f_scale_eot else 0 end)/100000000,2) as 本年申购规模, 
round(sum(case when t5.c_scatype_code in ('03','71') then t1.f_scale_eot else 0 end)/100000000,2) as 本年赎回规模
  from tt_pe_scale_type_m   t1,
       dim_pb_project_basic t2,
       dim_pb_project_biz   t3,
       dim_pb_department    t4,
       dim_sr_scale_type    t5
 where t1.l_proj_id = t2.l_proj_id
   and t2.l_proj_id = t3.l_proj_id
   and t1.l_object_id = t4.l_dept_id
   and t1.l_scatype_id = t5.l_scatype_id
   and t5.c_scatype_code in ('02', '03', '70', '71')
   and t3.l_valuation_flag = 1
   and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
   and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
   and T1.L_MONTH_ID = 201610
 group by t4.c_dept_code, t4.c_dept_name
 order by t4.c_dept_code;
 
--兑付规模
--JYXT
select a.c_dept_code, sum(-a - nvl(b, 0))
  from (select t2.c_proj_code,
               t4.c_dept_code,
               round(sum(t1.f_scale_eot) / 100000000, 2) as a
          from tt_pe_scale_type_m   t1,
               dim_pb_project_basic t2,
               dim_pb_project_biz   t3,
               dim_pb_department    t4,
               dim_sr_scale_type    t5
         where t1.l_proj_id = t2.l_proj_id
           and t2.l_proj_id = t3.l_proj_id
           and t1.l_object_id = t4.l_dept_id
           and t1.l_scatype_id = t5.l_scatype_id
           and t3.l_valuation_flag = 0
           and t5.c_scatype_code in ('03', '71')
           and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
           and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
           and T1.L_MONTH_ID = 201610 --and t4.c_dept_code = '0_80'
         group by t2.c_proj_code, t4.c_dept_code) a,
       (select t2.c_proj_code,
               t4.c_dept_code,
               round(sum(t1.f_scale_eot) / 100000000, 2) as b
          from tt_pe_scale_type_m   t1,
               dim_pb_project_basic t2,
               dim_pb_project_biz   t3,
               dim_pb_department    t4,
               dim_sr_scale_type    t5
         where t1.l_proj_id = t2.l_proj_id
           and t2.l_proj_id = t3.l_proj_id
           and t1.l_object_id = t4.l_dept_id
           and t1.l_scatype_id = t5.l_scatype_id
           and t3.l_valuation_flag = 0
           and t5.c_scatype_code in ('QS')
           and nvl(t2.l_expiry_date, 209912331) between 20160101 and
               20161031
           and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
           and t1.l_month_id < substr(t2.l_expiration_date, 1, 6) --and  t4.c_dept_code = '0_80'
           and T1.L_MONTH_ID = 201610
         group by t2.c_proj_code, t4.c_dept_code) b
 where a.C_proj_code = b.c_proj_code(+)
 group by a.c_dept_code
 order by a.c_dept_code;
