--项目关键要素
select t.c_projectcode         as 项目编码,
       t.c_projname            as 项目名称,
       t.c_projfullname        as 项目全称,
       t1.c_deptname           as 部门名称,
       t.c_trustmanager        as 信托经理,
       t.c_dealmanage          as 运营经理,
       t.c_investmentmanager   as 投资经理,
       t.c_accountant          as 信托会计,
       t.c_investment_officer  as 投后专员,
       t.c_loan_officer        as 贷款专员,
       t.l_setupdate           as 成立日期,
       t.l_prestopdate         as 预计到期日期,
       t.l_stopdate            as 到期日期,
       t.l_extenddate          as 延期日期,
       t.c_projectphase        as 项目阶段,
       t.c_projectphasename    as 项目阶段说明,
       t.c_projectstatus       as 项目阶段,
       t.c_projectstatusname   as 项目阶段说明,
       t.c_intrustflag         as 业务范围,
       t.c_intrustflagname     as 业务范围说明,
       t.c_projecttype         as 项目类型,
       t.c_projecttypename     as 项目类型说明,
       t.c_projectpropertytype as 财产权类型,
       t.c_projectpropertytype as 财产权类型说明,
       t.c_managetype          as 管理方式,
       t.c_managetypename      as 管理方式说明,
       t.c_funtype             as 功能分类,
       t.c_funtypename         as 功能分类说明,
       t.c_cootype             as 合作方式,
       t.c_cootypename         as 合作方式说明,
       t.c_industry            as 投向行业,
       t.c_industryname        as 投向行业说明,
       t.c_industrydtl1        as 投向行业明细,
       t.c_industrydtl1name    as 投向行业明细说明,
       t.c_investarea          as 投资范围,
       t.c_investareaname      as 投资范围说明,
       t.c_investdirection     as 投资方向,
       t.c_investdirectionname as 投资方向说明,
       t.c_riskmeasure         as 担保措施,
       t.c_riskmeasurename     as 担保措施说明
  from dim_projectinfo t, dim_department t1
 where t.l_deptid = t1.l_deptid
   and t.l_effective_flag = 1
 order by t.c_projectcode;

--期次关键要素核对
select a.c_stage_code  as 期次编码,
       a.c_stage_name  as 期次名称,
       b.c_projectcode as 项目编码,
       a.l_period      as 期次,
       a.l_setup       as 成立日期,
       a.l_predate     as 预计到期日期,
       a.l_enddate     as 到期日期,
       a.f_trustpay    as 报酬率
  from dim_stage a, dim_projectinfo b
 where a.l_projectid = b.l_projectid
   and b.l_effective_flag = 1
 order by a.c_stage_code;

--项目规模
select  b.c_projectcode,
       sum(a.f_balance_scale) / 100000000 as 当前规模,
       sum(a.f_exist_scale_boy) / 100000000 as 年初存续规模,
       sum(a.f_new_inc_scale) / 100000000 as 新增规模,
       sum(a.f_clear_scale) / 100000000 as 清算规模,
       sum(a.f_bridge_scale) / 100000000 as 过桥规模,
       sum(a.f_net_inc_scale) / 100000000 as 净增规模
  from tt_project_daily a, dim_projectinfo b
 where a.l_projectid = b.l_projectid
   and b.l_effective_date <= a.l_dayid
   and b.l_expiration_date > a.l_dayid
   and a.l_dayid = 20161231
 group by b.c_projectcode
 order by b.c_projectcode;

--期次粒度的规模核对
select b.c_stage_code      as 期次编码,
       a.f_exist_scale_boy as 年初存续规模,
       a.f_new_inc_scale   as 本年新增规模,
       a.f_clear_scale     as 本年减少规模,
       a.f_net_inc_scale   as 净增规模,
       a.f_bridge_scale    as 过桥规模,
       a.f_balanze_scale   as 规模余额
  from tt_stage_daily a, dim_stage b, dim_projectinfo c
 where a.l_stageid = b.l_stageid
   and b.l_projectid = c.l_projectid
   and ((nvl(c.c_propertytype, '0') = '1' and b.l_period = 0) or
       (nvl(c.c_propertytype, '0') <> '1'))
   and a.l_dayid = 20161231
 order by b.c_stage_code;

--项目收入
select sum(a.f_trust_pay + a.f_consultant_fee) / 10000 as 信托收入,
       sum(a.f_trust_pay) / 10000 as 信托报酬,
       sum(a.f_consultant_fee) / 10000 as 财顾费,
       sum(a.f_new_income) / 10000 as 新增收入,
       sum(a.f_exist_income) / 10000 as 存续收入,
       sum(a.f_plan_new_income) / 10000 as 新增计划收入,
       sum(a.f_plan_exist_income) / 10000 as 存续计划收入
  from tt_project_monthly a, dim_projectinfo b
 where a.l_projectid = b.l_projectid
   and substr(b.l_effective_date, 1, 6) <= a.l_monthid
   and substr(b.l_expiration_date, 1, 6) > a.l_monthid
   and a.l_monthid = 201612;

--期次粒度的收入核对
select b.c_stage_code           as 期次编码,
       a.f_base_pay             as 本年信托固定报酬,
       a.f_float_pay            as 本年信托浮动报酬,
       a.f_consultant_fee       as 本年信托财顾费,
       a.f_marketing_fee        as 营销费用,
       a.f_share_trust_pay      as 分享信托报酬,
       a.f_share_consultant_fee as 分享信托财顾费,
       a.f_self_share           as 自营分享
  from tt_stage_daily a, dim_stage b
 where a.l_stageid = b.l_stageid
   and a.l_dayid = 20161231
 order by b.c_stage_code;

--部门净增规模
select b.c_deptcode as 部门编码,
       b.c_deptname as 部门名称,
       sum(a.f_shared_scale) as 分成后规模
  from tt_kpi_dept_stage_m a, dim_department b, dim_stage c
 where a.l_deptid = b.l_deptid
   and a.l_monthid = 201612
   and a.l_stageid = c.l_stageid
   and substr(c.l_setup, 1, 4) = 2016
 group by b.c_deptcode, b.c_deptname
 order by b.c_deptcode, b.c_deptname;

--某部门下分成规模明细
select c.c_stage_code as 期次编码,
       c.c_stage_name as 期次名称,
       sum(a.f_shared_scale) as 分成后规模
  from tt_kpi_dept_stage_m a, dim_department b, dim_stage c
 where a.l_deptid = b.l_deptid
   and a.l_monthid = 201612
   and a.l_stageid = c.l_stageid
   and substr(c.l_setup, 1, 4) = 2016
   and b.c_deptcode = '0_ms2003'
 group by c.c_stage_code, c.c_stage_name
 order by c.c_stage_code, c.c_stage_name;

--部门信托收入
select b.c_deptcode as 部门编码,
       b.c_deptname as 部门编码,
       sum(a.f_trust_pay) as 信托报酬,
       sum(a.f_consultant_fee) as 财顾费,
       sum(a.f_sell_income) as 财富收入,
       sum(a.f_income_sum) as 确认收入,
       sum(a.f_innate_income) as 自营收入
  from tt_kpi_dept_stage_m a, dim_department b
 where a.l_deptid = b.l_deptid
   and a.l_monthid = 201612
 group by b.c_deptcode, b.c_deptname
 order by b.c_deptcode, b.c_deptname;

--分成后期次收入明细
select b.c_stage_code,
       sum(a.f_trust_pay) as 信托报酬,
       sum(a.f_consultant_fee) as 财顾费,
       sum(a.f_sell_income) as 财富收入,
       sum(a.f_income_sum) as 确认收入,
       sum(a.f_innate_income) as 自营收入
  from tt_kpi_dept_stage_m a, dim_stage b, dim_department c
 where a.l_deptid = c.l_deptid
   and a.l_stageid = b.l_stageid(+)
   and a.l_monthid = 201612
   --and c.c_deptcode = '0_ms1501'
 group by b.c_stage_code
 order by b.c_stage_code;
 
--期次粒度考核后信托报酬
select b.c_stage_code, sum(a.f_trust_pay)
  from tt_kpi_dept_stage_m a, dim_stage b, dim_department c
 where a.l_stageid = b.l_stageid
   and a.l_deptid = c.l_deptid
   and a.l_monthid = 201612
 group by b.c_stage_code
having sum(a.f_trust_pay) <> 0
 order by b.c_stage_code;
 
--确认信托报酬核对
select b.c_stage_code as 期次编码,
       sum(decode(c.quarter_desc, '1', a.f_trust_pay_sum, 0)) as 一季度信托报酬,
       sum(decode(c.quarter_desc, '2', a.f_trust_pay_sum, 0)) as 二季度信托报酬,
       sum(decode(c.quarter_desc, '3', a.f_trust_pay_sum, 0)) as 三季度信托报酬,
       sum(decode(c.quarter_desc, '4', a.f_trust_pay_sum, 0)) as 四季度信托报酬
  from tt_kpi_income_quarter a, dim_stage b, dim_quarter c,dim_projectinfo d
 where a.l_stageid = b.l_stageid
   and a.l_quarterid = c.quarter_id
   and c.year_id = 2016
   and a.l_projectid = d.l_projectid
   and d.l_effective_date <= 20161231
   and d.l_expiration_date > 20161231
 group by b.c_stage_code
 order by b.c_stage_code;
select * from dim_projectinfo;
select * from dim_stage t where t.c_stage_code = 'F079-2';
select * from tt_kpi_income_quarter t where t.L_stageid = 19855;

--固有业务
select b.c_projectcode,
       sum(a.f_invest_capital - a.f_invest_back) / 100000000 as 在投金额,
       sum(a.f_invest_return) / 10000 as 投资收益,
       sum(a.f_innate_share) / 10000 as 自营分享
  from tt_innate_income_daily a, dim_projectinfo b
 where a.l_projectid = b.l_projectid
   and a.l_dayid = 20161231
   and b.l_effective_date <= a.l_dayid
   and b.l_expiration_date > a.l_dayid
 group by b.c_projectcode
 order by b.c_projectcode;
 
--部门拓展费用
select b.c_deptcode, sum(a.f_entry_cost_sum) / 10000
  from tt_cost_summary a, dim_department b
 where a.l_deptid = b.l_deptid
   and a.l_monthid = 201612
 group by b.c_deptcode
having sum(a.f_entry_cost_sum) / 10000 <> 0
order by b.c_deptcode;
