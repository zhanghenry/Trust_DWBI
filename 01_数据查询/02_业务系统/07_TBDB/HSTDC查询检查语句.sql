--项目要素
select case when t.d_begdate is null then '成立日期为空'
            when (t.c_projphase = '99' and t.d_enddate is null) then '项目阶段已经终止但终止日期未维护'
              when (t.d_enddate is null and t.c_projphase <> '99' ) then '项目已终止但阶段不为99'
            when (nvl(t.d_enddate,to_date('20991231','yyyymmdd')) < t.d_begdate) then '结束日期小于成立日期'
                  end as 异常,
       t.c_projcode as 项目编码,
       t.c_fullname as 项目名称,
       t.c_shortname as 项目简称,
       t.d_begdate as 开始日期,
       t.d_predue as  预计到期日期,
       t.d_enddate as 结束日期,
       t.c_dptid as 部门ID,
       t.c_tmanager as 信托经理,
       t.c_projstatus as 项目状态,
       t.c_projphase as 项目阶段,
       t.l_busiscope as 业务范围,
       t.l_singleset as 单一集合,
       t.c_trustclass as 信托类型,
       t.l_functype as 功能分类,
       t.l_runmode as 运行方式,
       t.l_managemode as 管理方式,
       t.c_capuseway as 资金运用方式,
       t.l_industry as 投向行业,
       t.c_investdir as 运用方向,
       t.c_coopbit as 合作方式
  from pm_projectinfo t 
  order by t.c_projcode;
  
--部门要素
select a.c_orgid as 部门ID,
       a.c_orgcode as 部门编码,
       a.c_orgname as 部门名称,
       a.c_parentid as 父级部门ID,
       a.l_level as 层级,
       a.l_leaf as 是否叶节点,
       a.c_orgcalss as 组织分类,
       a.c_busiclass as 业务分类,
       a.l_sort as 排序号
  from hr_org a
 order by a.l_sort;
 
--员工要素
select a.c_userid, a.c_usercode, a.c_username, b.c_orgname
  from hr_user a, hr_org b
 where a.c_orgid = b.c_orgid(+);
 
--产品要素
select a.c_fundcode as 产品编码,
       a.c_fundname as 产品名称,
       a.c_projcode as 项目编码,
       a.d_setupdate as 成立日期,
       a.d_enddate as 终止日期,
       a.l_strucflag as 结构化标识,
       a.l_beneftype as 受益权类型
  from ta_fundinfo a;

--产品销售商
select * from TA_FUNDAGENCY;

--信托合同要素
select * from ta_pact;
select * from ta_order;
select * from ta_fundagency t where t.c_agencyno = '008008';

--投资合同要素
select/* distinct t.c_btype*/* from am_pact t where t.l_pactprop = 2 and t.l_ifflag = 2; --and t.c_btype = '1';
select * from am_busiflag t where t.c_functype = '8' and  t.l_busiid = 22151;
select * from am_order;
select * from am_guarantee;
select * from am_pactrate;
select * from am_pactvary;
select * from am_pactiou;
select * from cm_rival;
select * from cm_rivalholder;
