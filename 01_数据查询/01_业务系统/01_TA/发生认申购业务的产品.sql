--产品16年以后成立的包含自然人的
--16年以后发生过业务的
with temp_wtr as
 (select t1.c_fundcode, t2.l_serialno, t3.c_custno, t3.c_custname
    from ttrustcontracts t1, ttrustcontractdetails t2, ttrustclientinfo t3
   where t1.l_serialno = t2.l_contractserialno
     and t2.c_clientinfoid = t3.c_clientinfoid
     and t3.c_custtype = '1')
select c.c_projectcode      as 项目编码,
       c.c_projectname      as 项目名称,
       c.d_projectsetupdate as 项目成立日期,
       c.d_enddate          as 项目到期日期,
       a.c_fundcode         as 产品编码,
       a.c_fundname         as 产品名称,
       a.d_setupdate        as 产品成立日期,
       a.d_contractenddate  as 产品到期日期,
       a.d_extenddate       as 产品延期日期
  from tfundinfo a, ttrustprojects c
 where a.c_projectcode = c.c_projectcode
      --and to_char(a.d_setupdate, 'yyyy') >= '2016'
   and exists (select 1 from temp_wtr b where a.c_fundcode = b.c_fundcode)
   and exists (select 1
          from tconfirm d
         where a.c_fundcode = d.c_fundcode
           and to_char(d.d_cdate, 'yyyy') >= '2016' and d.c_businflag in ('50','02'));

--16年以后签约的合同
with temp_wtr as
 (select t1.c_fundcode, t2.l_serialno, t3.c_custno, t3.c_custname
    from ttrustcontracts t1, ttrustcontractdetails t2, ttrustclientinfo t3
   where t1.l_serialno = t2.l_contractserialno
     and t2.c_clientinfoid = t3.c_clientinfoid
     and t3.c_custtype = '1')
select c.c_projectcode      as 项目编码,
       c.c_projectname      as 项目名称,
       c.d_projectsetupdate as 项目成立日期,
       c.d_enddate          as 项目到期日期,
       a.c_fundcode         as 产品编码,
       a.c_fundname         as 产品名称,
       a.d_setupdate        as 产品成立日期,
       a.d_contractenddate  as 产品到期日期,
       a.d_extenddate       as 产品延期日期
  from tfundinfo a, ttrustprojects c
 where a.c_projectcode = c.c_projectcode
      --and to_char(a.d_setupdate, 'yyyy') >= '2016'
   and exists (select 1 from temp_wtr b where a.c_fundcode = b.c_fundcode)
   and exists (select 1
          from ttrustcontractdetails d,ttrustcontracts e
         where d.l_contractserialno = e.l_serialno
         and e.c_fundcode = a.c_fundcode
           and to_char(d.d_contractsigndate, 'yyyy') >= '2016');
