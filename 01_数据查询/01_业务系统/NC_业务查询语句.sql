--NC字典表
--根据PK_DEFDOC查询
select *
  from BD_DEFDOC t
 where t.pk_defdoc = '0001Q010000000004W5L';

--公司信息
select t.pk_corp as 公司主键,
       t.unitcode as 公司编码,
       t.unitname as 公司名称,
       t.unitshortname as 公司简称,
       t.fathercorp 父级公司编码,
       t.busibegindate as 开始日期,
       t.isworkingunit as 是否有效,
       t.dr,
       t.ts,
       t.holdflag,
       t.isuseretail,
       t.innercode,
       t.maxinnercode,
       t.ownersharerate,
       t.saleaddr
  from bd_corp t order by t.unitcode;

--部门信息
select --t.pk_corp,
 t1.unitcode    as 公司编码,
 t1.unitname    as 公司名称,
 t.pk_deptdoc   as 部门主键,
 t.deptcode     as 部门编码,
 t.deptname     as 部门名称,
 t.deptattr     as ,
 t.depttype     as 是否虚拟,
 t.def1         as 部门类型,
 t.def2         as 办公地点,
 t.def3         as 管理情况,
 t.memo         as 备注,
 t.pk_fathedept as 父级部门,
 t.pk_psndoc,
 t.pk_psndoc2,
 t.pk_psndoc3,
 t.createdate   as 创建日期,
 t.canceled     as 是否取消,
 t.hrcanceled   as 是否HR取消,
 t.innercode,
 t.isuseretail,
 t.maxinnercode,
 t.dr,
 t.ts
  from bd_deptdoc t, bd_corp t1
 where t.pk_corp = t1.pk_corp
   and t1.unitcode = '1';

--员工信息表
select t.pk_psndoc     as 员工信息表主键,
       t.psncode       as 员工编码,
       t.psnname       as 员工姓名,
       t.psnnamepinyin as 员工拼音,
       t3.psnclasscode as 员工类别,
       t3.psnclassname as 员工类别名称,
       t1.unitcode     as 公司编码,
       t1.unitname     as 公司名称,
       t2.deptcode     as 部门编码,
       t2.deptname     as 部门名称,
       t.regular as 是否转正,
       t.regulardata as 转正日期,
       t.groupdef2 as 转正情况,
       --t.pk_om_job     as 岗位,
       t4.jobcode      as 职位编码,
       t4.jobname      as 职位名称,
       --t.jobseries as 岗位序列,
       t.indutydate as 到职日期,
       --t.pk_psnbasdoc  as 个人信息表主键,
       t.psnclscope,
       t.dutyname as 岗位主键, 
       t.groupdef1 as 工作城市,
       t.createtime as 创建时间,
       t.creator as 创建人员,
       t.modifier as 修改人员,
       t.modifytime as 修改时间,
       t.hroperator as HR操作人员,
       t.iscalovertime,
       t.isreturn as 是否返聘,
       t.onpostdate as 到岗日期,
       t.poststat,
       t.showorder,
       t.tbm_prop,
       t.clerkflag,
       t.indocflag,
       t.series as 管理,
       t.jobrank  as 岗位排序,
       t.dr,
       t.ts
  from BD_PSNDOC t, bd_corp t1, bd_deptdoc t2, bd_psncl t3,om_job t4
 where t.pk_corp = t1.pk_corp
   and t1.unitcode = '1'
   and t.pk_deptdoc = t2.pk_deptdoc
   and t.pk_psncl = t3.pk_psncl
   and t.pk_om_job = t4.pk_om_job
   and t.psnname = '陈瑶';

select * from bd_psndoc t where t.psnname = '陈瑶';
select * from bd_psncl t where t.pk_psncl = '0001XT100000000000RR';

--个人信息表
select t.pk_corp       as 所属公司,
       t1.unitname      as 公司名称,
       t.pk_psnbasdoc  as 信息主键,
       t.psnname       as 员工姓名,
       t.sex           as 性别,
       t.ssnum         as 身份证号,
       t.id            as 身份证号,
       t.birthdate     as 出生日期,
       t.email         as 邮件地址,
       t.addr          as 地址,
       t.dr,
       t.postalcode    as 邮编,
       t.homephone     as 家庭电话,
       t.joinworkdate  as 参加工作日期,
       t.mobile        as 手机,
       t.officephone   as 办公电话,
       t.nationality   as 民族,
       t.nativeplace   as 籍贯,
       t.createtime    as 创建日期,
       t.creator       as 创建人员,
       t.modifier      as 修改人员,
       t.modifytime    as 修改时间,
       t.hroperator    as HR操作人员,
       t.joinsysdate   as 加入日期,
       t.basgroupdef1 as 工作地,
       t.basgroupdef8 as 学历,
       t.marital as 婚姻状况,
       t.permanreside as 居住地,
       t.polity as 政治面貌,
       t.ts,
       t.approveflag,
       t.basgroupdef10,
       t.basgroupdef5,
       t.basgroupdef7,
       t.basgroupdef9,
       t.indocflag,
       t.basgroupdef3 as 新增转入转出
  from bd_psnbasdoc t,bd_corp t1
 where t.pk_corp = t1.pk_corp and t1.unitcode = '1' and t.psnname = '陈昊' ;

--职位信息表
select t.pk_om_job as 职位主键,
       t.jobcode   as 职位编码,
       t.jobname   as 职位名称,
       --t.pk_corp as 公司主键,
       t1.unitcode as 公司编码,
       t1.unitname as 公司名称,
       --t.pk_deptdoc   as 部门主键,
       t2.deptcode as 部门编码,
       t2.deptname as 部门名称,
       t.suporior  as 上级职位,
       --t.jobseries    as 职位序列,
       t3.doccode     as 职位序列编码,
       t3.docname     as 职位序列名称,
       t.isabort      as 是否中止,
       t.abortdate    as 中止日期,
       t.builddate    as 创建日期,
       t.createcorp   as 创建公司,
       t.isdeptrespon,
       t.jobrank,
       t.dr,
       t.ts
  from om_job t, bd_corp t1, bd_deptdoc t2, bd_defdoc t3
 where t.pk_corp = t1.pk_corp
   and t.pk_deptdoc = t2.pk_deptdoc
   and t.jobseries = t3.pk_defdoc
   and t1.unitcode = '1';
   
--人员离职信息
select
    --t.pk_psndoc      as 员工主键,
     t1.psncode      as 员工编码,
     t1.psnname      as 员工名称,
     t.pk_psndoc_sub,
     t.pk_psnbasdoc  as 员工个人信息主键,
     t.type           as 变动类型,
     t2.doccode       as 变动类型编码,
     t2.docname       as 变动类型说明,
     t.psnclbefore    as 变动前员工类别,
     t.psnclafter     as 变动后员工类别,
     t.pk_corp        as 变动前公司主键,
     t.pk_corpafter   as 变动后公司主键,
     t.pkdeptbefore   as 变动前部门主键,
     t.pkdeptafter    as 变动后部门主键,
     t.pkomdutybefore,
     t.pkpostbefore,
     t.poststat,
     t.isreturn       as 是否返聘,
     t.lastflag       as 是否最后标识,
     t.leavedate      as 离开日期,
     t.reason         as 变动原因,
     t.recordnum,
     t.salarystopdate as 最后薪水日期,
     t.hroperator     as HR操作人员,
     t.dr,
     t.ts
  from HI_PSNDOC_DIMISSION t, bd_psndoc t1, bd_defdoc t2
 where t.pk_psndoc = t1.pk_psndoc
   and t.type = t2.pk_defdoc and t.pk_psndoc = '0001Q010000000001NJZ';

select * from bd_deptdoc t where t.pk_deptdoc = '1001XT1000000000004E';

--岗位变动流水
select
--t.pk_corp ,
 t1.unitcode as 公司编码,
 t1.unitname as 公司名称,
 --t.pk_deptdoc,
 t2.deptcode    as 部门编码,
 t2.deptname    as 部门名称,
 t.pk_detytype  as 部门类型,
 t.pk_dutyrank,
 t.pk_jobrank,
 t.pk_jobserial,
 t.jobtype,
 t.pk_om_duty as 岗位主键,
 t3.dutycode  as 岗位编码,
 t3.dutyname  as 岗位名称,
 t.pk_postdoc,
 --t.pk_psndoc,
 t4.psncode      as 员工编码,
 t4.psnname      as 员工名称,
 t.pk_psndoc_sub,
 t.pk_psncl      as 员工类型,
 --t.pk_psnbasdoc,
 t.approveflag   as 是否同意标志,
 t.begindate     as 开始日期,
 t.enddate       as 结束日期,
 t.lastflag      as 最后标志,
 t.isreturn      as 是否返聘,
 t.hroperator    as HR操作员,
 t.dr,
 t.ts,
 t.poststat,
 t.preparereason,
 t.preparetype,
 t.recordnum,
 t.tbm_prop,
 t.bendflag,
 t.iscalovertime
  from hi_psndoc_deptchg t,
       bd_corp           t1,
       bd_deptdoc        t2,
       om_duty           t3,
       bd_psndoc         t4
 where t.pk_corp = t1.pk_corp
   and t1.unitcode = '1'
   and t.pk_deptdoc = t2.pk_deptdoc
   and t.pk_om_duty = t3.pk_om_duty
   and t.pk_psndoc = t4.pk_psndoc
   and t.pk_psndoc = '0001Q010000000001NJZ' order by t.begindate;

select * from BD_DEFDOC t where t.pk_defdoc in ('0001XT100000000000PX');
select * from bd_defdoc t where t.pk_defdoclist = 'HI000000000000000051';

select * from om_job t where t.pk_jobdoc = '1001XT1000000000004P';0001XT100000000000QG 0001Q010000000004W5L
select * from om_job t where t.pk_om_duty = '1001XT1000000000004P';
select * from om_duty t where t.pk_om_duty in( '0001XT10000000000GGE','0001XT10000000000GGF');

select t.pk_psndoc from hi_psndoc_deptchg t group by t.pk_psndoc having count(*) > 6;

select * from hi_psndoc_family t where t.pk_psndoc = '1001XT100000000000SI';
select * from hi_psndoc_training t where t.pk_psndoc = '1001XT100000000000SI';

--员工入职
select s.begindate as 入职日期,
       s.enddate   as 合同结束日期,
       s2.unitcode as 公司编码,
       s2.unitname as 公司名称,
       s3.deptcode as 部门编码,
       s3.deptname as 部门名称,
       s1.psncode  as 员工编码,
       s1.psnname  as 员工姓名,
       s4.dutycode as 岗位编码,
       s4.dutyname as 岗位名称,
       s5.psnclasscode as 员工类型编码,
       s5.psnclassname as 员工类型名称
  from (select row_number() over(partition by t.pk_psndoc order by t.begindate) as l_rn,
               t.*
          from hi_psndoc_deptchg t) s,
       bd_psndoc s1,
       bd_corp s2,
       bd_deptdoc s3,
       om_duty s4,
       bd_psncl s5
 where s.l_rn = 1
   and s.pk_psndoc = s1.pk_psndoc
   and s.pk_corp = s2.pk_corp
   and s.pk_deptdoc = s3.pk_deptdoc 
   and s.pk_om_duty = s4.pk_om_duty
   and s.pk_psncl = s5.pk_psncl
   order by s.begindate;
   
select t1.pk_psndoc
  from (select distinct t.pk_psndoc, t.pk_psncl from hi_psndoc_deptchg t) t1
 group by t1.pk_psndoc
having count(*) > 1;

select * from hi_psndoc_deptchg t where t.pk_psndoc = '1001XT100000000000ZE';

select * from bd_psncl t where t.pk_psncl in ('0001XT100000000000RR','0001XT100000000000RT');

--入职信息
SELECT HI_PSNDOC_DEPTCHG.BEGINDATE as BEGINDATE,
       BD_PSNDOC.PSNCODE as PSNCODE,
       BD_PSNDOC.PSNNAME as PSNNAME,
       BD_CORP.UNITCODE as UNITCODE,
       BD_DEPTDOC.DEPTCODE as DEPTCODE,
       BD_PSNCL.PSNCLASSCODE as PSNCLASSCODE,
       OM_DUTY.DUTYCODE as DUTYCODE
  FROM (select row_number() over(partition by t.pk_psndoc order by t.begindate) as l_rn,
               t.*
          from hi_psndoc_deptchg t) HI_PSNDOC_DEPTCHG,
       BD_PSNDOC,
       BD_CORP,
       BD_DEPTDOC,
       BD_PSNCL,
       OM_DUTY
 where HI_PSNDOC_DEPTCHG.l_rn = 1
   and HI_PSNDOC_DEPTCHG.Pk_Corp = BD_CORP.Pk_Corp
   and HI_PSNDOC_DEPTCHG.Pk_Deptdoc = BD_DEPTDOC.Pk_Deptdoc
   and HI_PSNDOC_DEPTCHG.Pk_Psndoc = BD_PSNDOC.Pk_Psndoc
   and HI_PSNDOC_DEPTCHG.Pk_Psncl = BD_PSNCL.Pk_Psncl
   and HI_PSNDOC_DEPTCHG.pk_om_duty = OM_DUTY.pk_om_duty;
