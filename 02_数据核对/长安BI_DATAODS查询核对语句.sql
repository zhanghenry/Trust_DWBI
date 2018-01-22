select * from TCHANNELTREE;

select a.c_fundcode, a.c_fundname, c.c_projectcode
  from tfundinfo a, tsaleprofundrelation b, tsaleproject c
 where a.c_fundcode = b.c_fundcode(+)
   and b.l_proserialno = c.l_proserialno;

select * from tprojectinfo;
select * from TSALEPROJECTITEMRELATION;
select * from tsaleproject;
select * from TSALEPROFUNDRELATION;

select * from user_tables t where t.TABLE_NAME like '%FUND%';

select count(*) from tstaticshares t where t.c_fundacco not like 'ZG%';

select rowid,t.* from ttainfo t;

select * from ts_crm_trustfundprofit;

select * from ts_crm_projectinfo t where t.c_projectcode = '201320502386';

select * from ts_crm_sharecurrents;

select distinct t.c_businflag 
  from tconfirm t where t.c_businflag is not null
 where not exists (select 1
          from ttrustbenefitcert b
         where t.l_certificateserialno = b.l_serialno);

select * from ttrustcontractdetails;

select * from tunregister t where t.c_phone = '13572068002' t.c_identitytype <> '0' and t.c_factcustno is null and t.c_custtype = '1';


--交易确认表份额
select a.c_custno,a.f_shares-b.f_shares from (
select t.c_custno,
       sum(case
             when t.c_businflag in ('50', '01', '02', '70', '74') then
              t.f_confirmshares
             else
              t.f_confirmshares * -1
           end) as f_shares
  from tconfirm t
 where t.c_businflag in
       ('50', '01', '02', '03', '52', '53', '70', '71', '74')
   and t.d_cdate <= to_date('20161130', 'yyyymmdd') --and t.c_custno = '000000499227'
 group by t.c_custno) a,(
select s.c_custno,sum(s.f_realshares) as f_shares from tstaticshares s group by s.c_custno) b where a.c_custno = b.c_custno;


select t.c_businflag,t.d_cdate,t.c_fundcode,t.f_confirmshares from tconfirm t where t.c_custno = '000000475066';
select */*sum(t.f_realshares) */from tstaticshares t where t.c_custno = '000000475066';

select /*distinct t.c_businflag*/* from tconfirm t where t.c_businflag = '70' not in ('50','02','74','03','14','15','01');

select * from tdictionary t where /*t.l_keyno = 3548 */t.c_caption = '申购'

select * from tbrokertree;

select count(*) from tcustomerinfo  t where t.c_memberno is not null;

select count(*) from tcustcard t where t.c_status = ;

select sum(t.f_lastshares) from tsharecurrents t where t.d_sharevaliddate = to_date('20991231','yyyymmdd');

select a.c_nodecode, a.c_brokeraccount, b.c_emp_code, b.c_emp_name
  from tbrokermanage a, datadock.tde_employee b
 where a.c_brokeraccount = b.c_emp_code(+);
 
select s.c_nodevalue,t.* from tbrokermanage t,tbrokertree s  where t.c_nodecode = s.c_nodecode(+) order by t.c_nodecode,t.c_brokeraccount;

select * from tde_employee;

select * from tbrokertree t where t.c_nodecode = '000100010001';

select * from tfundbroker t where t.c_brokeraccount = '100002';
select * from treserve t where t.c_brokeraccount = '100002';

select * from tfundbroker t where  exists(select 1 from tcustomerinfo s where t.c_brokeraccount = s.c_broker);

--交易确认表
select a.c_businflag,
       a.d_cdate,
       a.c_cserialno,
       a.d_date,
       a.l_serialno,
       a.c_agencyno,
       a.c_netno,
       a.c_fundacco,
       a.c_tradeacco,
       a.c_fundcode,
       a.c_sharetype,
       a.f_confirmbalance,
       a.f_confirmshares,
       a.c_status,
       a.c_custno,
       a.c_requestno,
       a.f_lastshares,
       a.c_bonustype,
       a.f_totalbalance,
       a.f_totalshares,
       a.c_outbusinflag,
       a.l_certificateserialno
  from tconfirm a;

truncate table test_20161227_1;
drop table test_20161227_1;
create table test_20161227_1 as 
select t.c_custno,t.c_fundcode,sum(case
             --when t.c_businflag = '01' and t.c_fundcode like 'ZG%' then 0
             when t.c_businflag in ('50', '02','15', '70', '74') then t.f_confirmshares
             else t.f_confirmshares * -1
           end) as f_shares
  from tconfirm t
 where t.c_businflag in
       ('50', '02', '03','14','15' ,'52', '53', '70', '71', '74')
   --and t.d_cdate <= to_date('20161130', 'yyyymmdd')
   group by t.c_custno,t.c_fundcode
   order by t.c_custno,t.c_fundcode;

--静态份额明细表
truncate table test_20161227_2;
drop table test_20161227_2;
create table test_20161227_2 as 
select a.c_custno, a.c_fundcode, sum(a.f_realshares) as f_shares
  from tstaticshares a
 group by a.c_custno, a.c_fundcode
 order by a.c_custno, a.c_fundcode;
 
select a.*,b.*
  from test_20161227_1 a, test_20161227_2 b
 where a.c_custno = b.c_custno(+)
   and a.c_fundcode = b.c_fundcode(+)
   and b.f_shares <> 0
   and a.f_shares <> b.f_shares;

--合同明细表
select b.l_serialno,
       b.l_contractserialno,
       b.l_certificateserialno,
       b.c_fundacco,
       b.c_fundcode,
       b.c_trustcontractid,
       b.c_status,
       b.c_profitclass,
       b.d_contractsigndate,
       b.c_trustagencyno,
       b.c_sourcetype,
       b.c_custno
  from ttrustcontractdetails b;
  

SELECT TACCOINFO.D_OPENDATE   AS D_OPENDATE,
       TACCOINFO.D_LASTMODIFY AS D_LASTMODIFY,
       TACCOINFO.C_CUSTNO     AS C_CUSTNO
  FROM (SELECT T.C_CUSTNO,
               MIN(T.D_OPENDATE) AS D_OPENDATE,
               MAX(T.D_LASTMODIFY) AS D_LASTMODIFY
          FROM TACCOINFO T
         GROUP BY T.C_CUSTNO) TACCOINFO
