--项目关键要素
select a.c_proj_code,
       a.c_proj_name,
       a.c_name_full,
       c.c_dept_name,
       (select c_emp_name
          from dim_pb_employee
         where l_emp_id = a.l_tstmgr_id) as 信托经理,
       (select c_emp_name from dim_pb_employee where l_emp_id = a.l_opmgr_id) as 运营经理,
       (select c_emp_name
          from dim_pb_employee
         where l_emp_id = a.l_invmgr_id) as 投资经理,
       (select c_emp_name
          from dim_pb_employee
         where l_emp_id = a.l_tstacct_id) as 信托会计,
       (select c_emp_name
          from dim_pb_employee
         where l_emp_id = a.l_invclerk_id) as 投后专员,
       (select c_emp_name
          from dim_pb_employee
         where l_emp_id = a.l_loanclerk_id) as 贷款专员,
       a.l_setup_date as 成立日期,
       a.l_preexp_date as 预计到期日期,
       a.l_expiry_date as 到期日期,
       a.l_extend_date as 延期日期,
       a.c_proj_phase as 项目阶段,
       a.c_proj_phase_n as 项目阶段说明,
       a.c_proj_status as 项目状态,
       a.c_proj_status_n as 项目状态说明,
       b.c_busi_scope as 业务范围,
       b.c_busi_scope_n as 业务范围说明,
       b.c_proj_type as 项目类型,
       b.c_proj_type_n as 项目类型说明,
       b.c_property_type as 财产权类型,
       b.c_property_type_n as 财产权类型说明,
       b.c_manage_type as 管理方式,
       b.c_manage_type_n as 管理方式说明,
       b.c_func_type as 功能分类,
       b.c_func_type_n as 功能分类说明,
       b.c_coop_type as 合作方式,
       b.c_coop_type_n as 合作方式说明,
       b.c_invest_indus as 投向行业,
       b.c_invest_indus_n as 投向行业说明,
       b.c_invest_way as 投资方式,
       b.c_invest_way_n as 投资方式说明,
       b.c_invest_dir as 投资方向,
       b.c_invest_dir_n as 投资方向说明,
       null as 担保措施,
       null as 担保措施说明
  from dim_pb_project_basic a, dim_pb_project_biz b, dim_pb_department c
 where a.l_proj_id = b.l_proj_id
   and a.l_dept_id = c.l_dept_id
   and a.l_effective_flag = 1
 order by a.c_proj_code;

--期次关键要素核对
select a.c_stage_code  as 期次编码,
       a.c_stage_name  as 期次名称,
       b.c_proj_code   as 项目编码,
       a.l_period      as 期次,
       a.l_setup_date  as 成立日期,
       a.l_preexp_date as 预计到期日期,
       a.l_expiry_date     as 到期日期,
       a.f_trustpay    as 报酬率
  from dim_sr_stage a, dim_pb_project_basic b
 where a.l_stage_id = b.l_proj_id
   and b.l_effective_flag = 1
 order by a.c_stage_code;

--信托规模
select sum(a.f_balance_agg) / 100000000 as 时点规模,
       sum(decode(c.c_busi_scope,'1',a.f_balance_agg)) / 100000000 as 信托时点规模,
       sum(case when c.c_busi_scope = '1' and c.c_manage_type= '1' then a.f_balance_agg else 0 end)/100000000 as 主动类信托时点规模,
       sum(decode(c.c_busi_scope,'2',a.f_balance_agg)) / 100000000 as 基金时点规模,
       sum(case when c.c_busi_scope = '2' and c.c_manage_type= '1' then a.f_balance_agg else 0 end)/100000000 as 主动类基金时点规模
  from tt_sr_scale_stage_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id;
   
--公司收入
select sum(case when c.c_ietype_code_l1 in ('XTSR','TZSR') then a.f_planned_eoy end )/10000 as 合同收入,
       sum(case when c.c_ietype_code_l1 in ('XTSR') then a.f_planned_eoy end )/10000 as 合同信托基金收入,
       sum(case when c.c_ietype_code_l1 in ('TZSR') then a.f_planned_eoy end )/10000 as 合同自营收入
  from tt_sr_ie_stage_m a,
       dim_pb_ie_type   c,
       dim_pb_ie_status d,
       dim_pb_project_basic e,
       dim_pb_project_biz f
 where a.l_month_id = 201612
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and d.l_recog_flag = 0--非确认收入
   and a.l_proj_id = e.l_proj_id
   and e.l_proj_id = f.l_proj_id
   and substr(e.l_effective_date, 1, 6) <= a.l_month_id
   and substr(e.l_expiration_date, 1, 6) > a.l_month_id;

--部门费用
select c.c_dept_code,
       sum(case when b.c_subj_code_l2 = '660102' or b.c_subj_code_l3 = '66010301' then a.f_amount_eot else 0 end)/10000 as 部门日常及拓展费用
  from tt_fi_accounting_dept_m a, dim_fi_subject b,dim_pb_department c
 where a.l_month_id = 201612
   and a.l_subj_id = b.l_subj_id
   and a.l_dept_id = c.l_dept_id 
   and substr(c.l_effective_date, 1, 6) <= a.l_month_id
   and substr(c.l_expiration_date, 1, 6) > a.l_month_id
   group by c.c_dept_code
   order by c.c_dept_code;

--当前信托规模
select sum(a.f_balance_agg) / 100000000 as 当前存续,
       sum(a.f_increase_eot) / 100000000 as 本年新增,
       sum(a.f_decrease_eot) / 100000000 as 本年清算
  from tt_sr_scale_stage_m a, dim_sr_stage b
 where a.l_stage_id = b.l_stage_id
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id;

--年初信托规模
select sum(a.f_balacne_bot) / 100000000 as 年初存续规模
  from tt_sr_scale_stage_m a, dim_sr_stage b
 where a.l_stage_id = b.l_stage_id
   and a.l_month_id = 201601
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id;

--当前信托收入
select sum(decode(c.c_ietype_code_l1, 'XTSR', a.f_planned_eoy, 0))/10000 as 信托收入,
       sum(case when c.c_ietype_code_l2 = 'XTBC' then a.f_planned_eoy else 0 end)/10000 as 新增信托收入,
       sum(case when c.c_ietype_code_l2 = 'XTCGF' then a.f_planned_eoy else 0 end)/10000 as 存续信托收入
  from tt_sr_ie_stage_m a,
       dim_sr_stage     b,
       dim_pb_ie_type   c,
       dim_pb_ie_status d
 where a.l_stage_id = b.l_stage_id
   and a.l_month_id = 201612
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and d.l_recog_flag = 1
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id;

--期次粒度的规模核对
with temp_bridge as
 (select t1.l_month_id, t1.l_stage_id, sum(t1.f_scale_eot) as f_scale_eot
    from tt_sr_scale_type_m t1, dim_pb_scale_type t2
   where t1.l_scatype_id = t2.l_scatype_id
     and t2.c_scatype_code = '62'
   group by t1.l_month_id, t1.l_stage_id)
select b.c_stage_code as 期次编码,
       a.f_increase_eot as 本年新增规模,
       a.f_decrease_eot as 本年减少规模,
       decode(substr(b.l_setup_date, 1, 4),
              substr(a.l_month_id, 1, 4),
              a.f_balance_eot,
              0) as 净增规模,
       nvl(c.f_scale_eot, 0) as 过桥规模,
       a.f_balance_agg as 规模余额
  from tt_sr_scale_stage_m a, dim_sr_stage b, temp_bridge c
 where a.l_stage_id = b.l_stage_id
   and a.l_month_id = 201612
   and a.l_stage_id = c.l_stage_id(+)
   and a.l_month_id = c.l_month_id(+)
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 order by b.c_stage_code;

--项目粒度的规模核对
with temp_bridge as
 (select t1.l_month_id, t1.l_proj_id, sum(t1.f_scale_eot) as f_scale_eot
    from tt_sr_scale_type_m t1, dim_pb_scale_type t2
   where t1.l_scatype_id = t2.l_scatype_id
     and t2.c_scatype_code = '62'
   group by t1.l_month_id, t1.l_proj_id)
select d.c_proj_code as 项目编码,
 sum(a.f_increase_eot) / 100000000 as 本年新增规模,
 sum(a.f_decrease_eot) / 100000000 as 本年减少规模,
 sum(decode(substr(b.l_setup_date, 1, 4),
            substr(a.l_month_id, 1, 4),
            a.f_balance_eot,
            0)) / 100000000 as 净增规模,
 sum(nvl(c.f_scale_eot, 0)) / 100000000 as 过桥规模,
 sum(a.f_balance_agg) / 100000000 as 规模余额
  from tt_sr_scale_stage_m  a,
       dim_sr_stage         b,
       temp_bridge          c,
       dim_pb_project_basic d
 where a.l_stage_id = c.l_proj_id(+)
   and a.l_month_id = 201612
   and a.l_month_id = c.l_month_id(+)
   and a.l_proj_id = d.l_proj_id
   and a.l_stage_id = b.l_stage_id
   and substr(d.l_effective_date, 1, 6) <= a.l_month_id
   and substr(d.l_expiration_date, 1, 6) > a.l_month_id
 group by d.c_proj_code
 order by d.c_proj_code;

--期次粒度收入核对
select b.c_stage_code as 期次编码,
       sum(case when c.c_ietype_code = 'XTGDBC' and d.l_recog_flag = 0 then a.f_planned_eoy else 0 end) as 本年信托固定报酬,
       sum(case when c.c_ietype_code = 'XTFDBC' and d.l_recog_flag = 0 then   a.f_planned_eoy else 0 end ) as 本年信托浮动报酬,
       sum(case when c.c_ietype_code= 'XTCGF' and d.l_recog_flag = 0 then  a.f_planned_eoy else  0 end) as 本年信托财顾费,
       sum(case when c.c_ietype_code_l2 = 'XTYXFY'and d.l_recog_flag = 0 then a.f_planned_eoy else 0 end) as 本年营销费用,
       sum(case when c.c_ietype_code = 'XTFXBC'and d.l_recog_flag = 0 then  a.f_planned_eoy else 0 end) as 本年分享信托报酬,
       sum(case when c.c_ietype_code= 'XTFXCGF'and d.l_recog_flag = 0 then a.f_planned_eoy else 0 end) as 本年分享财顾费,
       sum(case when c.c_ietype_code= 'TZZYFX'and d.l_recog_flag = 0 then a.f_planned_eoy else 0 end) as 本年自营分享
  from tt_sr_ie_stage_m a,
       dim_sr_stage     b,
       dim_pb_ie_type   c,
       dim_pb_ie_status d
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by b.c_stage_code;
 
--考核后部门粒度规模核对
select d.c_dept_code as 部门编码,
       d.c_dept_name as 部门名称,
       sum(a.f_scale_eot) as 分成后规模
  from tt_pe_scale_stage_m a,
       dim_sr_stage        b,
       dim_pb_scale_type   c,
       dim_pb_department   d
 where a.l_stage_id = b.l_stage_id
   and a.l_scatype_id = c.l_scatype_id
   and a.c_object_type = 'BM'
   and a.l_object_id = d.l_dept_id
   and substr(b.l_setup_date, 1, 4) = substr(a.l_month_id, 1, 4)
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by d.c_dept_code, d.c_dept_name
 order by d.c_dept_code, d.c_dept_name;

--某部门下的期次分成后净增规模明细
select b.c_stage_code as 期次编码,
       b.c_stage_name as 期次名称,
       sum(a.f_scale_eot) as 分成后规模
  from tt_pe_scale_stage_m a,
       dim_sr_stage        b,
       dim_pb_scale_type   c,
       dim_pb_department   d
 where a.l_stage_id = b.l_stage_id
   and a.l_scatype_id = c.l_scatype_id
   and a.c_object_type = 'BM'
   and a.l_object_id = d.l_dept_id
   and substr(b.l_setup_date, 1, 4) = substr(a.l_month_id, 1, 4)
   and d.c_dept_code = '0_ms2003'
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by b.c_stage_code, b.c_stage_name
 order by b.c_stage_code, b.c_stage_name;

--考核后员工粒度规模核对
select d.c_emp_code as 员工编码,
       d.c_emp_name as 员工名称,
       sum(a.f_scale_eot) as 分成后规模
  from tt_pe_scale_stage_m a,
       dim_sr_stage        b,
       dim_pb_scale_type   c,
       dim_pb_employee   d
 where a.l_stage_id = b.l_stage_id
   and a.l_scatype_id = c.l_scatype_id
   and a.c_object_type = 'YG'
   and a.l_object_id = d.l_emp_id
   and substr(b.l_setup_date, 1, 4) = substr(a.l_month_id, 1, 4)
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by d.c_emp_code, d.c_emp_name
 order by d.c_emp_code, d.c_emp_name;

--考核后部门粒度收入核对
select d.c_dept_code as 部门编码,
       d.c_dept_name as 部门名称,
       sum(case when c.c_ietype_code_l2 = 'XTBC' and e.l_recog_flag = 0 then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC', 'TZZYFX') then a.f_planned_eoy * -1 else 0 end) as 分成后信托报酬,
       sum(case when c.c_ietype_code_l2 = 'XTCGF'and e.l_recog_flag = 0 then a.f_planned_eoy else 0 end) as 分成后财顾费,
       sum(case when  c.c_ietype_code_l2 = 'XTYXFY' and e.l_recog_flag = 0 then a.f_planned_eoy else  0 end) as 分成后财富收入,
       sum(case when c.c_ietype_code_l1 = 'XTSR' and e.l_recog_flag = 1 then a.f_Planned_Eoy else 0 end) as 确认收入
  from tt_pe_ie_stage_m  a,
       dim_sr_stage      b,
       dim_pb_ie_type    c,
       dim_pb_department d,
       dim_pb_ie_status  e
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.c_object_type = 'BM'
   and a.l_object_id = d.l_dept_id
   and a.l_iestatus_id = e.l_iestatus_id
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by d.c_dept_code, d.c_dept_name
 order by d.c_dept_code, d.c_dept_name;
 
--考核后期次粒度收入核对
select b.c_stage_code as 期次编码,
       sum(case when c.c_ietype_code_l2 = 'XTBC'and e.l_recog_flag = 0 then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC', 'TZZYFX')and e.l_recog_flag = 0 then a.f_planned_eoy * -1 else 0 end) as 分成后信托报酬,
       sum(case when c.c_ietype_code_l2 = 'XTCGF'and e.l_recog_flag = 0 then a.f_planned_eoy else 0 end) as 分成后财顾费,
       sum(case when c.c_ietype_code_l2='XTYXFY' and e.l_recog_flag = 0 then a.f_planned_eoy else 0 end) as 分成后财富收入,
       sum(case when c.c_ietype_code_l1= 'XTSR' and e.l_recog_flag = 1 then a.f_Planned_Eoy else 0 end) as 确认收入
  from tt_pe_ie_stage_m  a,
       dim_sr_stage      b,
       dim_pb_ie_type    c,
       dim_pb_department d,
       dim_pb_ie_status  e
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.c_object_type = 'BM'
   --and d.c_dept_code = '0_ms1501'
   and a.l_object_id = d.l_dept_id
   and a.l_iestatus_id = e.l_iestatus_id
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by b.c_stage_code 
 order by b.c_stage_code;

--考核后部门粒度收入核对
select d.c_emp_code as 部门编码,
       d.c_emp_name as 部门名称,
       sum(case when c.c_ietype_code_l2 = 'XTBC' and e.l_recog_flag = 0 then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC', 'TZZYFX') then a.f_planned_eoy * -1 else 0 end) as 分成后信托报酬,
       sum(case when c.c_ietype_code_l2 = 'XTCGF'and e.l_recog_flag = 0 then a.f_planned_eoy else 0 end) as 分成后财顾费,
       sum(case when  c.c_ietype_code_l2 = 'XTYXFY' and e.l_recog_flag = 0 then a.f_planned_eoy else  0 end) as 分成后财富收入,
       sum(case when c.c_ietype_code_l1 = 'XTSR' and e.l_recog_flag = 1 then a.f_Planned_Eoy else 0 end) as 确认收入
  from tt_pe_ie_stage_m  a,
       dim_sr_stage      b,
       dim_pb_ie_type    c,
       dim_pb_employee d,
       dim_pb_ie_status  e
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.c_object_type = 'YG'
   and a.l_object_id = d.l_emp_id
   and a.l_iestatus_id = e.l_iestatus_id
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by d.c_emp_code, d.c_emp_name
 order by d.c_emp_code, d.c_emp_name;

--固有在投金额
select b.c_proj_code, sum(a.f_balance_agg) / 100000000 as 在投金额
  from tt_sr_fund_stage_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_month_id = 201612
   and c.c_busi_scope = '0'
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by b.c_proj_code
 order by b.c_proj_code;

--固有自营分享
select sum(decode(d.c_ietype_code_l1, 'TZSR', a.f_planned_eoy, 0)) / 10000 as 自营收入,
       sum(decode(d.c_ietype_code, 'TZZYFX', a.f_planned_eoy, 0)) / 10000 as 自营分享,
       sum(case when d.c_ietype_code in('TZSY','TZLX','TZFX','TZWYJ') then a.f_planned_eoy else 0 end) / 10000 as 自营收入不含自营分享
  from tt_sr_ie_stage_m     a,
       dim_pb_project_basic b,
       dim_pb_project_biz   c,
       dim_pb_ie_type       d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_ietype_id = d.l_ietype_id
   and a.l_month_id = 201612
   and c.c_busi_scope = '0'
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id;

--确认收入
select b.c_stage_code,
       sum(case
             when c.c_ietype_code in ('XTGDBC', 'XTFDBC') then
              a.f_planned_eoy
             else
              0
           end) as 四季度考核信托报酬
  from tt_sr_ie_stage_m a,
       dim_sr_stage     b,
       dim_pb_ie_type   c,
       dim_pb_ie_status d
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and d.l_recog_flag = 1
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by b.c_stage_code
 order by b.c_stage_code;
 
--信托项目自营分享
select sum(case
             when c.c_ietype_code = 'TZZYFX' and d.l_recog_flag = 0 then
              a.f_planned_eoy
             else
              0
           end) as 本年自营分享
  from tt_sr_ie_stage_m a,
       dim_sr_stage     b,
       dim_pb_ie_type   c,
       dim_pb_ie_status d
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id;

--自营项目自营分享
select sum(case
             when d.c_ietype_code = 'TZZYFX' and e.l_recog_flag = 0 then
              a.f_planned_eoy
             else
              0
           end) as 本年自营分享
  from tt_sr_ie_stage_m     a,
       dim_pb_project_biz   b,
       dim_pb_project_basic c,
       dim_pb_ie_type       d,
       dim_pb_ie_status     e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_ietype_id = d.l_ietype_id
   and a.l_iestatus_id = e.l_iestatus_id
   and b.c_busi_scope = '0'
   and a.l_month_id = 201612
   and substr(c.l_effective_date, 1, 6) <= a.l_month_id
   and substr(c.l_expiration_date, 1, 6) > a.l_month_id; 

