--受益权转让前后的合同到期日期
with temp_wtr as
 (select t1.c_fundcode, t2.l_serialno, t3.c_custno, t3.c_custname
    from ttrustcontracts t1, ttrustcontractdetails t2, ttrustclientinfo t3
   where t1.l_serialno = t2.l_contractserialno
     and t2.c_clientinfoid = t3.c_clientinfoid
     and t3.c_custtype = '1'),
temp_zr as
 (select distinct t.l_contractserialno, L_OTHERCONTRACTSERIALNO, t.d_cdate
    from tconfirm t
   where t.c_businflag in ('14')
     and to_char(t.d_cdate, 'yyyymmdd') >= '2016')
select t6.c_projectcode      as 项目编码,
       t6.c_projectname      as 项目名称,
       t6.d_projectsetupdate as 成立日期,
       t4.c_fundcode         as 产品编码,
       t4.c_fundname         as 产品名称,
       t4.d_setupdate        as 产品成立日期,
       t2.c_trustcontractid  as 合同外部编号,
       t5.d_cdate            as 转让日期,
       t2.l_serialno         as 转让前合同号,
       t2.d_contractenddate  as 转让前合同到期日期,
       t1.l_serialno         as 转让后合同号,
       t1.d_contractenddate  as 转让后合同到期日期
  from (select a.l_serialno,
               a.c_trustcontractid,
               a.d_contractsigndate,
               a.d_contractenddate,
               a.l_parentserialno
          from ttrustcontractdetails a
         where a.l_parentserialno is not null) t1,
       ttrustcontractdetails t2,
       ttrustcontracts t3,
       tfundinfo t4,
       temp_zr t5,
       ttrustprojects t6     
 where t1.l_parentserialno = t2.l_serialno
   and t2.l_contractserialno = t3.l_serialno
   and t3.c_fundcode = t4.c_fundcode
   and t2.l_serialno = t5.l_contractserialno
   and t1.l_serialno = t5.L_OTHERCONTRACTSERIALNO
   and t4.c_projectcode = t6.c_projectcode
   and nvl(t1.d_contractenddate, to_date('20991231', 'yyyymmdd')) <>
       nvl(t2.d_contractenddate, to_date('20991231', 'yyyymmdd'))
   and exists( select 1 from temp_wtr t7 where t1.l_serialno = t7.l_serialno)
 order by t5.d_cdate;

select t.d_begincalcdate,t.d_contractsigndate,t.d_contractenddate from ttrustcontractdetails t where t.l_serialno = 462221;
